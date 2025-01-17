import 'package:flutter/material.dart';

class MarkingPage extends StatefulWidget {
  @override
  _MarkingPageState createState() => _MarkingPageState();
}

class _MarkingPageState extends State<MarkingPage> with SingleTickerProviderStateMixin {
  final List<List<int>> _scores = List.generate(10, (index) => [0, 0, 0, 0, 0]); // 10 rows, 5 columns
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
    )..repeat(reverse: true); // Repeats the animation back and forth

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

  // Calculate totals for each game
  List<int> _calculateTotals() {
    List<int> totals = [0, 0, 0, 0, 0];
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 5; j++) {
        totals[j] += _scores[i][j];
      }
    }
    return totals;
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> totals = _calculateTotals();

    return Scaffold(
      body: Container(
        color: Colors.orange, // Set the entire background to orange
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0), // Add top padding
            child: Column(
              children: [
                // Points Selection
                Row(
                  children: [
                    const Text("Award/Deduct Points:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16), // Adds space between the text and the dropdown
                    Material(
                      elevation: 4, // Elevation for the dropdown button
                      child: DropdownButton<int>(
                        value: _pointValue,
                        items: [5, 10, 20, 50]
                            .map((int value) {
                          return DropdownMenuItem<int>(value: value, child: Text('$value points'));
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

                // Score Table with Numbered Rows and Aesthetics
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16, // Adjusts the space between columns
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1), // Border around the table
                      borderRadius: BorderRadius.circular(12), // Rounded corners for the table
                    ),
                    columns: const [
                      DataColumn(label: Text("")),
                      DataColumn(label: Text("Team 1", style: TextStyle(color: Colors.black))),
                      DataColumn(label: Text("Team 2", style: TextStyle(color: Colors.red))),
                      DataColumn(label: Text("Team 3", style: TextStyle(color: Colors.green))),
                      DataColumn(label: Text("Team 4", style: TextStyle(color: Colors.blue))),
                      DataColumn(label: Text("Team 5", style: TextStyle(color: Colors.grey))),
                    ],
                    rows: List.generate(10, (rowIndex) {
                      return DataRow(
                        cells: [
                          DataCell(Text((rowIndex + 1).toString())), // Row Number
                          ...List.generate(5, (colIndex) {
                            return DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.red),
                                    onPressed: () {
                                      _updateScore(rowIndex, colIndex, -_pointValue);
                                    },
                                  ),
                                  Text('${_scores[rowIndex][colIndex]}'),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.green),
                                    onPressed: () {
                                      _updateScore(rowIndex, colIndex, _pointValue);
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

                // Display Total Points at the Bottom inside the same orange background
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align at the start to give room for space
                    children: [
                      for (int i = 0; i < 5; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adds space between each team's points
                          child: Text(
                            "Team ${i + 1}: ${totals[i]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),

                // Green Play Icon with Animation below total points
                const SizedBox(height: 0),
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green, // Background color of the circular button
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
                      onPressed: () {
                        // Add functionality for play button press
                      },
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
