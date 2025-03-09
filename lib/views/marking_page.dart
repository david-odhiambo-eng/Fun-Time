import 'package:flutter/material.dart';
import '../ads_manager.dart';
import 'landing_page.dart';

class MarkingPage extends StatefulWidget {
  @override
  _MarkingPageState createState() => _MarkingPageState();
}

class _MarkingPageState extends State<MarkingPage>
    with SingleTickerProviderStateMixin {
  final List<List<int>> _scores =
  List.generate(12, (index) => [0, 0, 0, 0, 0]); // 12 rows, 5 columns
  int _pointValue = 5; // Default to 5 points

  // Animation controller for the play button animation
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize the animation (Tween)
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  // Function to update the points for a specific row and column
  void _updateScore(int row, int column, int value) {
    setState(() {
      _scores[row][column] += value;
    });
  }

  // Reset all scores and point value to default
  void _resetScores() {
    setState(() {
      for (int i = 0; i < 12; i++) {
        for (int j = 0; j < 5; j++) {
          _scores[i][j] = 0;
        }
      }
      _pointValue = 5;
    });
  }

  // Calculate totals for each game/team
  List<int> _calculateTotals() {
    List<int> totals = [0, 0, 0, 0, 0];
    for (int i = 0; i < 12; i++) {
      for (int j = 0; j < 5; j++) {
        totals[j] += _scores[i][j];
      }
    }
    return totals;
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller when done.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> totals = _calculateTotals();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // The banner ad is placed in the bottomNavigationBar.
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Container(
            height: 50, // Adjust based on your ad size
            width: double.infinity,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: AdManager.getBannerAd(), // Display the banner ad
          ),
        ),
        body: Container(
          color: Colors.orange, // Background color for the page
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50.0, left: 16.0, right: 16.0),
                      child: Column(
                        children: [
                          // Points Selection Section
                          Row(
                            children: [
                              const Text(
                                "Award/Deduct Points:",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 16),
                              Material(
                                elevation: 4,
                                child: DropdownButton<int>(
                                  value: _pointValue,
                                  items: [5, 10, 20, 50]
                                      .map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text('$value points'),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _pointValue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Score Table Section
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 16,
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              columns: const [
                                DataColumn(label: Text("")),
                                DataColumn(
                                    label: Text("Team 1",
                                        style: TextStyle(
                                            color: Colors.black))),
                                DataColumn(
                                    label: Text("Team 2",
                                        style: TextStyle(color: Colors.red))),
                                DataColumn(
                                    label: Text("Team 3",
                                        style: TextStyle(
                                            color: Colors.green))),
                                DataColumn(
                                    label: Text("Team 4",
                                        style: TextStyle(color: Colors.blue))),
                                DataColumn(
                                    label: Text("Team 5",
                                        style: TextStyle(
                                            color: Colors.grey))),
                              ],
                              rows: List.generate(12, (rowIndex) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text((rowIndex + 1).toString())),
                                    ...List.generate(5, (colIndex) {
                                      return DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _updateScore(rowIndex, colIndex,
                                                    -_pointValue);
                                              },
                                            ),
                                            Text('${_scores[rowIndex][colIndex]}'),
                                            IconButton(
                                              icon: const Icon(Icons.add,
                                                  color: Colors.green),
                                              onPressed: () {
                                                _updateScore(rowIndex, colIndex,
                                                    _pointValue);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Totals Display Section
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Team ${i + 1}: ${totals[i]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Buttons Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScaleTransition(
                                scale: _animation,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back,
                                        color: Colors.white, size: 30),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LandingPage()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.refresh,
                                      color: Colors.white, size: 30),
                                  onPressed: _resetScores,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
