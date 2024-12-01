import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:MapMarking/game.dart';
import 'package:MapMarking/main.dart';



class GameOptionsPage extends StatefulWidget {
  @override
  _GameOptionsPageState createState() => _GameOptionsPageState();
}

class _GameOptionsPageState extends State<GameOptionsPage> {
  String? selectedMap = "Srilanka - Places"; // Default value
  String? selectedDifficulty = "Easy"; // Default value
  String? selectedPlaces = "5"; // Default value
  String? selectedLanguage = "Tamil"; // Default value

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height; 
    return Scaffold(
      body: Stack(
        children: [
          Container(width: screenWidth,height: screenHeight,color: const Color(0xFF20242a),), 
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
          Container(width: screenWidth,height: screenHeight,color: const Color.fromARGB(165, 0, 0, 0),),
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
                      color: Color.fromARGB(255, 19, 21, 24),
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
                            options: ["Srilanka - Places"],
                            selectedValue: selectedMap,
                            onChanged: (value) => setState(() => selectedMap = value),
                            isStartGamePressed: isStartGamePressed,
                          ),
                          DropdownTile(
                            title: "Difficulty",
                            options: ["Easy", "Medium", "Hard", "Impossible"],
                            selectedValue: selectedDifficulty,
                            onChanged: (value) => setState(() => selectedDifficulty = value),
                            isStartGamePressed: isStartGamePressed,
                          ),
                          DropdownTile(
                            title: "Number of Places",
                            options: ["5", "10", "15","30"],
                            selectedValue: selectedPlaces,
                            onChanged: (value) => setState(() => selectedPlaces = value),
                            isStartGamePressed: isStartGamePressed,
                          ),
                          DropdownTile(
                            title: "Language",
                            options: ["Tamil", "Sinhala", "English"],
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
                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MainPage()),
                                  );
                                },
                                child: Icon(Icons.home_rounded,size: 18,color: Color(0xFFc7e3da),), 
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isStartGamePressed = true;
                                  });


                                  if (areAllOptionsSelected()) {
                                    // Navigate to GameApp
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameApp(
                                          Language: selectedLanguage!,
                                          Map: selectedMap!,
                                          level: selectedDifficulty!,
                                          numOfPlaces: int.parse(selectedPlaces!),
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Show Snackbar if options are incomplete
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(
                                          child: Text(
                                            "Please select all options!",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        backgroundColor: Color.fromARGB(255, 16, 18, 21),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Start Game',style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      height: 1.2,
                                    ),))
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
              style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      height: 1.2,
                                    )) 
            ),
          ),
          Center(
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 13, 15, 18),
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
                dropdownColor: Color.fromARGB(255, 13, 15, 18),
                value: selectedValue,
                hint: Text("Select", style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      height: 1.2,
                                    )),), 
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                items: options
                    .map((option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(option, style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      height: 1.2,
                                    ),)),
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
