import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kenyan_game/global.dart';

class Webrtc {
  String roomId;
  Webrtc({required this.roomId});

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  // Initialize WebRTC & Get Screen Stream
  Future<void> initWebRTC(bool isSharing) async {
    debugPrint("webrtc roomID $roomId");
    await remoteRenderer.initialize();
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    // Listen for ICE candidates
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) async {
      if (candidate.candidate != null) {
        // Send ICE candidate regardless of role
        await sendIceCandidates(isSharing, candidate);
      }
    };
  }

  void listenForTracks(Function() onFrameUpdate) {
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
        debugPrint("Remote stream received and assigned to renderer.");
      } else {
        //remoteRenderer.srcObject ??= MediaStream();
        remoteRenderer.srcObject!.addTrack(event.track);
        debugPrint("Remote track added to renderer's stream.");
      }

      // Trigger the callback to update the UI
      onFrameUpdate();
    };
  }


  // Handle Signaling (Exchange ICE Candidates & SDP)
  Future<void> createOffer() async {
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    // Send `offer.toMap()` to the remote peer via signaling server.
    await signalingRef.child("$roomId/offer").set(offer.toMap());
  }

  Future<void> _createAnswer() async {
    RTCSessionDescription answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    await signalingRef.child("$roomId/answer").set(answer.toMap());
  }

  Future<void> listenForOffer() async {
    signalingRef.child("$roomId/offer").onValue.listen((event) async {
      if (event.snapshot.exists) {
        if (event.snapshot.value != null) {
          var data = event.snapshot.value as Map<dynamic, dynamic>?;
          if (data != null && data.containsKey("sdp") && data.containsKey("type")) {
            RTCSessionDescription offer = RTCSessionDescription(
              data["sdp"] as String,
              data["type"] as String,
            );

            // Only set the offer if the connection is in a 'new' state (i.e. no remote description set yet)
            var currentSDP = await _peerConnection!.getRemoteDescription();
            if (currentSDP != null) {
              debugPrint("Offer already set. Ignoring duplicate.");
              return;
            }

            await _peerConnection!.setRemoteDescription(offer);
            await _createAnswer();
          } else {
            debugPrint("Invalid SDP data received: $data");
          }
        } else {
          debugPrint("No offer data found in Firebase.");
        }
      }
    });
  }

  Future<void> listenForAnswer() async {
    signalingRef.child("$roomId/answer").onValue.listen((event) async {
      if (event.snapshot.exists && event.snapshot.value != null) {
        var data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null && data.containsKey("sdp") && data.containsKey("type")) {
          RTCSessionDescription answer = RTCSessionDescription(
            data["sdp"] as String,
            data["type"] as String,
          );

          if (_peerConnection != null) {
            // Check if the peer connection is in the correct state to set the remote answer.
            if (_peerConnection!.signalingState != RTCSignalingState.RTCSignalingStateHaveLocalOffer) {
              debugPrint(
                  "Not in the correct state to set remote answer. Current state: ${_peerConnection!.signalingState}");
              return;
            }

            await _peerConnection!.setRemoteDescription(answer);
            debugPrint("Answer received and set.");
          } else {
            debugPrint("Peer connection is null, cannot set remote description.");
          }
        } else {
          debugPrint("Invalid answer format: $data");
        }
      } else {
        debugPrint("No answer found in Firebase.");
      }
    });
  }

  // Send ICE candidates
  Future<void> sendIceCandidates(bool isSharing, RTCIceCandidate candidate) async {
    try {
      await signalingRef
          .child("$roomId/ice_candidates/${isSharing ? "sender" : "receiver"}")
          .push() // Ensures that each candidate is added as a new entry
          .set(candidate.toMap());

      debugPrint("ICE candidate sent by ${isSharing ? "sender" : "receiver"}");
    } catch (e) {
      debugPrint("Error sending ICE candidates: $e");
    }
  }

  // Listen for ICE Candidates
  Future<void> listenForIceCandidates(bool isSharing) async {
    signalingRef
        .child("$roomId/ice_candidates/${isSharing ? "receiver" : "sender"}")
        .onChildAdded
        .listen((event) async {
      if (event.snapshot.exists && event.snapshot.value != null) {
        var data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null &&
            data.containsKey("candidate") &&
            data.containsKey("sdpMid") &&
            data.containsKey("sdpMLineIndex")) {
          RTCIceCandidate candidate = RTCIceCandidate(
            data["candidate"] as String,
            data["sdpMid"] as String?,
            (data["sdpMLineIndex"] as num?)?.toInt(), // Ensure integer conversion
          );

          if (_peerConnection != null) {
            await _peerConnection!.addCandidate(candidate);
            debugPrint("ICE candidate added successfully.");
          } else {
            debugPrint("Peer connection is null, cannot add ICE candidate.");
          }
        } else {
          debugPrint("Invalid ICE candidate data received: $data");
        }
      }
    });
  }

  Future<MediaStream> getScreenStream() async {
    if (Platform.isAndroid) {
      ScreenCaptureService.startForegroundService(); // Start foreground service
    }

    final Map<String, dynamic> constraints = {
      'video': {
        'mandatory': {
          'minWidth': 640,
          'minHeight': 360,
          'minFrameRate': 15,
        },
      },
      'audio': false
    };
    debugPrint("🖥️ Available media devices: ${await navigator.mediaDevices.enumerateDevices()}");

    MediaStream stream = await navigator.mediaDevices.getDisplayMedia(constraints);

    debugPrint("📹 Total Video Tracks: ${stream.getVideoTracks().length}");

    if (stream.getVideoTracks().isNotEmpty) {
      var videoTrack = stream.getVideoTracks().first;

      videoTrack.onEnded = () {
        debugPrint("⚠️ Screen sharing stopped.");
      };

      videoTrack.onMute = () {
        debugPrint("🔇 Video track muted.");
      };

      videoTrack.onUnMute = () {
        debugPrint("🔊 Video track unmuted.");
      };
    }

    return stream;
  }

  Future<void> startScreenShare() async {
    _localStream = await getScreenStream();

    if (_localStream != null) {
      debugPrint("✅ Screen stream obtained. Tracks: ${_localStream!.getTracks().length}");

      _localStream!.getTracks().forEach((track) {
        debugPrint("🔹 Adding track: ${track.kind}, ID: ${track.id}");
        var sender = _peerConnection?.addTrack(track, _localStream!);
        debugPrint("📡 Track added: ${sender != null}");
      });


      debugPrint("🎥 Screen sharing started.");
    } else {
      debugPrint("❌ Failed to obtain screen stream.");
    }
  }

  Future<void> endCall() async {
    await signalingRef.child(roomId).remove();
    await _peerConnection?.close();
    _peerConnection = null;
  }
}

class ScreenCaptureService {
  static const MethodChannel _channel = MethodChannel('screen_capture_service');

  static Future<void> startForegroundService() async {
    try {
      await _channel.invokeMethod('startService');
    } catch (e) {
      debugPrint("⚠️ Error starting foreground service: $e");
    }
  }

  static Future<void> stopForegroundService() async {
    try {
      await _channel.invokeMethod('stopService');
    } catch (e) {
      debugPrint("⚠️ Error stopping foreground service: $e");
    }
  }
}