import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:MapMarking/main.dart';
import 'package:MapMarking/marking_popup.dart';
import 'package:MapMarking/widgets/pin.dart';



class ViewerApp extends StatefulWidget {
  @override
  _ViewerAppState createState() => _ViewerAppState();
}

class _ViewerAppState extends State<ViewerApp> {
  List<Pin> pins = [];
  bool isMenu = false;
  bool isSettings = false;
  bool islanguageSelect = true;
  String selectedLanguage = 'Tamil';
  void toggleVisibility(int index) {
    setState(() {
      pins[index].isVisible = !pins[index].isVisible;
    });
  }
  void hideAllPins(List<Pin> pins) {
  for (var pin in pins) {
    setState(() {
      pin.isVisible = false;
    });
  }
}
void showAllPins(List<Pin> pins) {
  for (var pin in pins) {
    setState(() {
      pin.isVisible = true; 
    });
  }
}

  void updateVisibilityAll(List<Pin> pins, bool isVisible) {
  for (var pin in pins) {
    pin.isVisible = isVisible;
  }
}
  @override  
  Widget build(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;
      
    return MaterialApp(
      home: Scaffold(
        body:Stack(
          children: [

              InteractiveContainer(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onPinsUpdated: (updatedPins) {
                  setState(() {
                    pins = updatedPins;
                  });                
                },
                selectedLanguage: selectedLanguage,
            
        
        
          ), 
          if (!isSettings&&!islanguageSelect) 
            Positioned(
                      top: 20,
                      left: 20,
                      child: TextButton(
                        style: TextButton.styleFrom(
    iconColor: Colors.white, //  Text color
    backgroundColor: const Color.fromARGB(0, 33, 149, 243), // Button background color
  ),
                        onPressed:() {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );}, child: Icon(Icons.arrow_back_ios_new_rounded ))),
            if(!isSettings&&!islanguageSelect)
            Positioned(
                      top: 20,
                      right: 20,
                      child: TextButton(
                        style: TextButton.styleFrom(
    iconColor: Colors.white, //  Text color
    backgroundColor: const Color.fromARGB(0, 33, 149, 243), // Button background color
  ),
                        onPressed:() {setState(() {
                                  isSettings = true;
                                });}, child: Icon(Icons.settings_rounded ))),
              isSettings ? Center(
  child: Stack(
    children: [
      
      Container(
        width: 550,
        height: screenHeight - 50,
        padding: screenWidth > 355 ? EdgeInsets.all(50) : EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 19, 21, 24), // Plain background color
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text("Map Settings", style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 20,  
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      height: 1.2,
                                    ),
                                  )),
            SizedBox(height: 30),
            Text('Language', style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      height: 1.2,
                                    ),
                                  )),
            SizedBox(height: 15),
            Wrap(
              alignment: WrapAlignment.spaceBetween,  
              children: ['Tamil', 'Sinhala', 'English'].map((language) {
                bool isSelected = selectedLanguage == language; // Track selection
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0,top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Color.fromARGB(255, 34, 39, 46) : Color.fromARGB(255, 13, 15, 18),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () async {
                      setState(() {
                        selectedLanguage = language; // Update selected language
                      });
                      await Future.delayed(Duration(seconds: 1));
                      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var pin in pins) {
          _updatePinDimensions(pin.key);
        }
      });  
                    },
                    child: Text(
                      language,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Pin Visibility', style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 15, 
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      height: 1.2,
                                    ),
                                  )),
            SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {showAllPins(pins);}, 
                  icon: Icon(Icons.visibility, size: 18, color: Colors.white),
                  label: Text('Show All', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 13, 15, 18)),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {hideAllPins(pins);},
                  icon: Icon(Icons.visibility_off, size: 18, color: Colors.white),
                  label: Text('Hide All', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 13, 15, 18)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
  child: ScrollConfiguration(
    behavior: ScrollBehavior().copyWith(overscroll: false, scrollbars: false),
    child: ListView.builder(
      itemCount: pins.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 13, 15, 18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ((selectedLanguage == "Tamil" ? pins[index].labelT: selectedLanguage == "Sinhala" ? pins[index].labelS : pins[index].labelE)),
                
                style: TextStyle(fontSize: 13.0, color: Colors.white),
              ), 
              IconButton(
                icon: Icon(
                  pins[index].isVisible ? Icons.visibility : Icons.visibility_off,
                  color: pins[index].isVisible ? Colors.white : Colors.grey,
                ),
                onPressed: () => toggleVisibility(index),
              ),
            ],
          ),
        );
      },
    ),
  ),
) 
],
        ),
      ),
      Positioned(
        right: 40, 
        top: 20, 
        child: CloseButton(onPressed: (){setState(() {
          isSettings = false; 
        });},color: Colors.white,), )   

    ],
  ),
):SizedBox(),
 if(islanguageSelect) Center(
  child: Container(
    height: 250, 
    width: 200, 
    decoration: BoxDecoration(
      color:Color.fromARGB(255, 19, 21, 24),
      borderRadius: BorderRadius.circular(20) 
    ), 
    padding: EdgeInsets.all(20),
    child: Column(
      children: [
        Text('Select Language', style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      height: 1.2,
                                    ),
                                  )),
                                  SizedBox(height: 20,), 
         Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,   
              children: ['Tamil', 'Sinhala', 'English'].map((language) {
                bool isSelected = selectedLanguage == language; // Track selection
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0,top: 3), 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color.fromARGB(255, 13, 15, 18), 
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () async {
                      setState(() {
                        selectedLanguage = language; // Update selected language
                      });
                       setState(() {
          islanguageSelect = false; 
        });
                      await Future.delayed(Duration(seconds: 1)); 
                      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var pin in pins) {
          _updatePinDimensions(pin.key);
        }
       
      }); 
                    },
                    child: Text(
                      language,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
           
      ],
    ),
  ),
 )
])));

   
 
    
  }
  
  
  Future<void> _updatePinVisibilityInFirestore(Pin pin) async {
    try {
      await FirebaseFirestore.instance.collection('pins').doc(pin.id).update({'isVisible': pin.isVisible});
    } catch (e) {
      print('Error updating pin visibility: $e');
    }
  }
  void _updatePinDimensions(GlobalKey pinKey) {
    final renderBox = pinKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      setState(() {
        final pin = pins.firstWhere((pin) => pin.key == pinKey);
        pin.width = size.width;
        pin.height = size.height;
      });
    }
  } 
}

class InteractiveContainer extends StatefulWidget {
  final Function(List<Pin>) onPinsUpdated;  
  final double screenHeight;
  final double screenWidth;
  final String selectedLanguage;
  InteractiveContainer({required this.onPinsUpdated,required this.screenHeight,required this.screenWidth,required this.selectedLanguage});

  @override
  _InteractiveContainerState createState() => _InteractiveContainerState();
}
class _InteractiveContainerState extends State<InteractiveContainer> {
  Offset mousePosition = Offset.zero;
  Offset clickPosition = Offset.zero; // Position of the click
  final GlobalKey containerKey = GlobalKey(); // Key for the container
  List<Pin> pins = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //remove 
  int tindex = 0; 

  @override
  void initState() {
    super.initState();
    _loadPinsFromFirestore();
    
  }

  @override
  Widget build(BuildContext context) {
    bool isProperRatio = true;
    if (widget.screenHeight / 2 > widget.screenWidth) {
      isProperRatio = false;
    }
    double scaleY = isProperRatio ? widget.screenHeight / 600: (widget.screenWidth*2)/600;
    double scaleX = isProperRatio ? widget.screenHeight / 2 / 300 : (widget.screenWidth)/300;
    double driftX = (widget.screenWidth - (widget.screenHeight / 2)) / 2;
    double driftY = (widget.screenHeight - (widget.screenWidth * 2)) / 2; 

    return GestureDetector(
      onDoubleTapDown: (details) async {
        final renderBox = 
            containerKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {clickPosition = renderBox.globalToLocal(details.globalPosition);
          double px = ((clickPosition.dx)-(isProperRatio ? driftX : 0))/scaleX; 
          double py = ((clickPosition.dy)-(!isProperRatio ? driftY : 0))/scaleY;
          final label = await showLabelInputDialog(context);
          if (label != null && label.isNotEmpty) {
            print('Entered Label: $label');
            _addPin(Offset(px, py), label,'sinhala$tindex','english$tindex');
          }
          
          tindex ++; 
        }
      },
      child: MouseRegion(
        onHover: (event) {
          final renderBox =
              containerKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            setState(() {
              mousePosition = renderBox.globalToLocal(event.position);
            });
          }
        },
        child: Stack(
          children: [
                                
            InteractiveViewer(
              minScale: 1,
              maxScale: 8.0,
              child: Container(
                key: containerKey,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 10, 12, 13),
                ),
                width: widget.screenWidth,
                height: widget.screenHeight,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/map_image.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: isProperRatio ? BoxFit.fitHeight : BoxFit.fitWidth,
                    ),
                    for (var pin in pins)
                      if (pin.isVisible)
                        Positioned(
                          left: (pin.position.dx * scaleX) +
                              (isProperRatio ? driftX : 0) -
                              pin.width / 2,
                          top: pin.position.dy * scaleY +
                              (!isProperRatio ? driftY : 0) -
                              pin.height +
                              2, 
                          child: Container(
                            key: pin.key,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 21, 23, 28), 
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  child: 
                                    Text(
                                      ((widget.selectedLanguage == "Tamil" ? pin.labelT: widget.selectedLanguage == "Sinhala" ? pin.labelS : pin.labelE)),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 4, 
                                      ),
                                  ),
                                ), 
                                Icon(Icons.location_pin,
                                    color: Colors.red, size: 6),
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
      ),
    );
  }

  void _addPin(Offset position, String labelT,String labelS,String labelE) {
    String pinId = DateTime.now().millisecondsSinceEpoch.toString();
    GlobalKey pinKey = GlobalKey();
    Pin newPin = Pin(
      id: pinId,
      key: pinKey,
      position: position,
      labelT: labelT,
      labelS: labelS,
      labelE: labelE,
      width: 0.0,
      height: 0.0,
      isVisible: true,
    );

    setState(() {
      pins.add(newPin);
    });

    widget.onPinsUpdated(pins);
    _savePinToFirestore(newPin);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePinDimensions(pinKey);
    });
  }

  Future<void> _savePinToFirestore(Pin pin) async {
    try {
      await firestore.collection('pins').add(pin.toMap());
    } catch (e) {
      print('Error saving pin: $e');
    }
  }

  void _loadPinsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('pins').get();
      setState(() {
        pins = querySnapshot.docs.map((doc) => Pin.fromFirestore(doc)).toList();
      });
      widget.onPinsUpdated(pins);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var pin in pins) {
          _updatePinDimensions(pin.key);
        }/////////////////////////////////////////////////////////////////////////////
      });
    } catch (e) {
      print('Error loading pins: $e');
    }
  }

  void _updatePinDimensions(GlobalKey pinKey) {
    final renderBox = pinKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      setState(() {
        final pin = pins.firstWhere((pin) => pin.key == pinKey);
        pin.width = size.width;
        pin.height = size.height;
      });
    }
  }
}