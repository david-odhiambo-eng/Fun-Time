
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kenyan_game/database.dart';

import 'global.dart';
class Auth{

  Future<void> signInWithEmailPassword(
      String email,
      String password,
      CallBackAction callback) async{

    if(email.isEmpty){
      callback(false, "Email required");
      return;
    }
    if(password.isEmpty){
      callback(false, "Password required");
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Call the callback with success = true if sign-in is successful
      callback(true, "Logged in!");
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      String message = "";
      if(e.code == "user-not-found"){
        //user not available
        message = "Account not found";
      }else if(e.code == "wrong-password"){
        message = "Wrong password.";
      }else if(e.code == "invalid-credential"){
        message="Incorrect username or password";
      }else{
        message="Cant login now!";
      }
      callback(false,message);
    } catch (e) {
      // Handle other unexpected exceptions
      callback(false, 'An unknown error occurred: ${e.toString()}');
    }
  }
  Future<void> sendPasswordResetEmail(String email, CallBackAction callback) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      callback(true, "Password reset link sent. Check email.");
    }catch(e){
      callback(false, "Error: ${e.toString()}");
    }
  }
  Future<void> signUpWithEmailPassword(String username, String email, String password, CallBackAction callback) async{
    if(email.isEmpty){
      callback(false, "Email required");
      return;
    }
    if(!EmailValidator.validate(email)){
      callback(false, "Invalid email provided");
      return;
    }
    if(password.isEmpty || password.length < 6){
      callback(false, "Password too short, 6 characters required");
      return;
    }
    if(username.isEmpty || username.length > 20){
      callback(false, "Invalid username or too long");
      return;
    }
    try{
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      await user!.updateDisplayName(username);
      //send email verification
      //await user.sendEmailVerification();
      Map<String, dynamic> update  = {
        "username":username,
        "email": email,
        "userId":user.uid
      };
      Database().uploadUserData(update, callback);

    }on FirebaseAuthException catch (e){
      String message = "";
      if (e.code == 'weak-password') {
        message= "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message="The account already exists for that email.";
      }else{
        message="Cant create account now";
      }
      callback(false, message);
    }catch(e){
      callback(false,"Error ${e.toString()}");
    }
  }
  Future<void> signInWithGoogle(CallBackAction callback) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign-In process
        callback(false, "Google sign-in canceled by user");
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in/up to Firebase with the Google credential
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user was newly created
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final user = userCredential.user!;
        Map<String, dynamic> update  = {
          "username":user.displayName,
          "email": user.email,
          "userId":user.uid
        };
        Database().uploadUserData(update, callback);
      }else{
        // If sign-in is successful
        callback(true, "Logged in with Google successfully!");
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      String message = "";
      if (e.code == "account-exists-with-different-credential") {
        message = "Account exists with a different credential.";
      } else if (e.code == "invalid-credential") {
        message = "Invalid credential.";
      } else {
        message = "Error. ${e.toString()}";
      }
      callback(false, message);
    } catch (e) {
      // Handle other unexpected exceptions
      callback(false, 'An unknown error occurred: ${e.toString()}');
    }
  }
  Future<void> signInAnonymously(CallBackAction callback) async{
    try {
      await FirebaseAuth.instance.signInAnonymously();
      callback(true, "Signed in anonymously!");
    } on FirebaseAuthException catch (e) {
      String message = "";
      switch (e.code) {
        case "operation-not-allowed":
          message = "Anonymous auth hasn't been enabled for this project.";
          break;
        default:
          message = "Error. ${e.code}";
      }
      callback(false, message);
    }catch (e){
      callback(false, e.toString());
    }
  }
}