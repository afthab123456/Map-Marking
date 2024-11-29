import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(GameOptionsApp());
}

class GameOptionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Options',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 67, 6, 6),
        scaffoldBackgroundColor: const Color(0xFF20242a),
      ),
      home: GameOptionsPage(),
    );
  }
}

class GameOptionsPage extends StatefulWidget {
  @override
  _GameOptionsPageState createState() => _GameOptionsPageState();
}

class _GameOptionsPageState extends State<GameOptionsPage> {
  String? selectedMap;
  String? selectedDifficulty;
  String? selectedPlaces;
  String? selectedLanguage;

  bool isStartGamePressed = false;

  bool areAllOptionsSelected() {
    return selectedMap != null &&
        selectedDifficulty != null &&
        selectedPlaces != null &&
        selectedLanguage != null;
  }

  void showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Options Selected"),
          content: Text(
            "Map: $selectedMap\n"
            "Difficulty: $selectedDifficulty\n"
            "Number of Places: $selectedPlaces\n"
            "Language: $selectedLanguage",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Containers
          Positioned( 
            top: 0,
            left: 0,
            child: Container(
              width: 250,
              child: Image.asset("assets/dots.png"),  
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0, 
            child: Container(
              width: 250,
              child: Image.asset("assets/dots.png"), 
            ),
          ),
          
          // Main Form
          Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF2b3038),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_pin,
                                    size: 33, color: Color.fromARGB(255, 202, 35, 35)),
                                Text(
                                  'Map\nMarking'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      fontStyle: FontStyle.italic,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          DropdownTile(
                            title: "Select Map",
                            options: ["Map 1", "Map 2", "Map 3"],
                            selectedValue: selectedMap,
                            onChanged: (value) => setState(() => selectedMap = value),
                            isStartGamePressed: isStartGamePressed,
                          ),
                          DropdownTile(
                            title: "Difficulty",
                            options: ["Easy", "Medium", "Hard"],
                            selectedValue: selectedDifficulty,
                            onChanged: (value) => setState(() => selectedDifficulty = value),
                            isStartGamePressed: isStartGamePressed,
                          ),
                          DropdownTile(
                            title: "Number of Places",
                            options: ["5", "10", "15"],
                            selectedValue: selectedPlaces,
                            onChanged: (value) => setState(() => selectedPlaces = value),
                            isStartGamePressed: isStartGamePressed,
                          ),
                          DropdownTile(
                            title: "Language",
                            options: ["English", "Spanish", "French"],
                            selectedValue: selectedLanguage,
                            onChanged: (value) => setState(() => selectedLanguage = value),
                            isStartGamePressed: isStartGamePressed,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF20242a),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {},
                                child: Icon(Icons.home_rounded),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF20242a),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isStartGamePressed = true;
                                  });

                                  if (areAllOptionsSelected()) {
                                    showPopup();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(
                                          child: Text(
                                            "Please select all options!",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        backgroundColor: Color.fromARGB(255, 62, 70, 81),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Start Game'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownTile extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final bool isStartGamePressed;

  const DropdownTile({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.isStartGamePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Center(
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                color: Color(0xFF20242a),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isStartGamePressed && selectedValue == null
                      ? Colors.red
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                dropdownColor: Color(0xFF20242a),
                value: selectedValue,
                hint: Text("Select", style: TextStyle(color: Colors.white)),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                items: options
                    .map((option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(option, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: onChanged,
                underline: SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
