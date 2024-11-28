import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:history_map/main.dart';
import 'package:history_map/widgets/pin.dart';
import 'package:url_launcher/url_launcher.dart';


class Result{
  final String Label;
  final int distance;
  final bool good;
  Result({
    required this.Label,
    required this.distance,
    required this.good,
  });
  Map<String, dynamic> toMap() {
    return {
      'label': Label,
      'distance': distance,
      'good': good
    };
  }
}



class GameApp extends StatefulWidget {
  @override
  _GameAppState createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  List<Pin> pins = [];
  List<Pin> userPins = [];
  bool isMenu = false;
  @override  
  Widget build(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        body:
              
              Stack(children: [
                GameInteractiveContainer(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onPinsUpdated: (updatedPins) {
                  setState(() {
                    pins = updatedPins;
                  });
                },
                onUserPinsUpdated: (updatedUserPins) {
                  setState(() {
                    userPins = updatedUserPins;
                  });
                },
            
        
        
          ),
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
            );}, child: Icon(Icons.arrow_back_ios_new_rounded))),
              ],)
      )); 
    
  }

  Future<void> _updatePinVisibilityInFirestore(Pin pin) async {
    try {
      await FirebaseFirestore.instance.collection('pins').doc(pin.id).update({'isVisible': pin.isVisible});
    } catch (e) {
      print('Error updating pin visibility: $e');
    }
  }
}

class GameInteractiveContainer extends StatefulWidget {
  final Function(List<Pin>) onPinsUpdated;
  final Function(List<Pin>) onUserPinsUpdated; 
  final double screenHeight;
  final double screenWidth;
  GameInteractiveContainer({required this.onPinsUpdated,required this.onUserPinsUpdated,required this.screenHeight,required this.screenWidth});

  @override
  _GameInteractiveContainerState createState() => _GameInteractiveContainerState();
}
class _GameInteractiveContainerState extends State<GameInteractiveContainer> {
  Offset mousePosition = Offset.zero;
  Offset clickPosition = Offset.zero; // Position of the click
  final GlobalKey containerKey = GlobalKey(); // Key for the container
  List<Pin> pins = [];
  List<Pin> selectedPins = [];
  List<Pin> userPins = [];
  int currentPinIndex = 0;
  bool isGameOver = false;
  List<Result> results = [];
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadPinsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    if(currentPinIndex >= selectedPins.length && currentPinIndex != 0 && isGameOver == false){      
      gameOver();
    }    

    bool isProperRatio = true;
    if (widget.screenHeight / 2 > widget.screenWidth) {
      isProperRatio = false;
    }
    double scaleY = widget.screenHeight / 600;
    double scaleX = widget.screenHeight / 2 / 300;
    double driftX = (widget.screenWidth - (widget.screenHeight / 2)) / 2;
    double driftY = (widget.screenHeight - (widget.screenWidth * 2)) / 2;
   
      
    return GestureDetector(
      onTapDown: (details) {
        final renderBox =
            containerKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {clickPosition = renderBox.globalToLocal(details.globalPosition);
          double px = ((clickPosition.dx)-(isProperRatio ? driftX : 0))/scaleX; 
          double py = ((clickPosition.dy)-(!isProperRatio ? driftY : 0))/scaleY;
          if (!(currentPinIndex >= selectedPins.length)){ 
             
            _addPin(Offset(px, py), selectedPins[currentPinIndex].label);
                      
            currentPinIndex++;
              
          }   
          
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
              maxScale: 5.0,
              child: Container(
                key: containerKey,
                decoration: BoxDecoration(
                  color: Color(0xFF20242a),
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
                    /*for (var pin in pins)
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
                                Text(
                                  pin.label,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    backgroundColor: Colors.black54,
                                  ),
                                ),
                                Icon(Icons.location_pin,
                                    color: Colors.red, size: 20),
                              ],
                            ),
                          ),
                        ),*/
                        for (var pin in userPins)
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
                                Text(
                                  pin.label,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    backgroundColor: Color(0xFF20242a), 
                                  ),
                                ),
                                Icon(Icons.location_pin,
                                    color: const Color.fromARGB(255, 55, 130, 160), size: 20),
                              ],
                            ),
                          ),
                        ),
                        
                        isGameOver? 
                        Center(
  child: Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      color: const Color.fromARGB(225, 33, 33, 33),
    ),
    child: Center( // Ensures all children are centered
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrinks the Column to fit its children
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Scores',style: TextStyle(color: Colors.white,fontSize: 20)),
          SizedBox(
            height: 200, // Adjust height to avoid infinite expansion
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true, // Prevents ListView from expanding infinitely
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(3),
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(236, 51, 51, 51),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          SizedBox(width: 10,),
                        Icon(Icons.location_pin,color: const Color.fromARGB(255, 55, 130, 160)),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Text(result.Label,style: TextStyle(color: Colors.white,fontSize: 10),),
                        SizedBox(height: 5,),
                        Text("Distance : ${result.distance.toString()}",style: TextStyle(color: const Color.fromARGB(255, 207, 232, 255),fontSize: 8),)
                      ],
                      
                    ),
                        ],),
                   Row(children: [
                     Icon(result.good ? Icons.check_rounded : Icons.close_rounded,color:result.good? const Color.fromARGB(255, 12, 104, 75): const Color.fromARGB(255, 197, 46, 33),), 
                     SizedBox(width: 10,)
                   ],)
                      ],
                    ),)
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  },
  
  child: Text('Back to Home'),
),
SizedBox(height: 20,),
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameApp()),
    );
  },
   
  child: Text('Play Again'),
)

        ],
      ),
    ),
  ),
)
:SizedBox()
                  ],  
                ),
              ),
            ),
            Positioned(
                          bottom: 10,
                          left: (MediaQuery.of(context).size.width - 250)/2,
                          child: Container(width: 250,height: 40,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: const Color.fromARGB(255, 22, 30, 35)),child: Center(child:Text(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),(currentPinIndex >= 0 && currentPinIndex < selectedPins.length)?selectedPins[currentPinIndex].label: '')),),), 
          ],
        ),
      ),
    );
  }

  void _addPin(Offset position, String label) {
    String pinId = DateTime.now().millisecondsSinceEpoch.toString();
    GlobalKey pinKey = GlobalKey();
    Pin newPin = Pin(
      id: pinId,
      key: pinKey,
      position: position,
      label: label,
      width: 0.0,
      height: 0.0,
      isVisible: true,
    );

    setState(() {
      userPins.add(newPin);
    });
 
    widget.onUserPinsUpdated(userPins);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateUserPinDimensions(pinKey); 
    });
  }
Future<void> gameOver() async {
  await Future.delayed(Duration(milliseconds: 50));
  setState(() {
    isGameOver = true;
  });
  results.clear();
  
  for (int pinNum = 0; pinNum < userPins.length; pinNum++) {
    double userX = userPins[pinNum].position.dx;
    double userY = userPins[pinNum].position.dy;
    double correctX = selectedPins[pinNum].position.dx;
    double correctY = selectedPins[pinNum].position.dy;
    double distance = sqrt(pow(userX - correctX, 2) + pow(userY - correctY, 2));
    
    bool good = distance < 30;  // Set 'good' based on distance condition
    
    print(distance);
    
    results.add(Result(
      Label: selectedPins[pinNum].label,
      distance: distance.toInt(),
      good: good
    ));
  }
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
        }
        
      });
      
      
     randomPick(pins, selectedPins, 3); 
      
    } catch (e) {
      print('Error loading pins: $e');
    }
  }

  void randomPick(List<Pin> source, List<Pin> target, int count) {
  Random random = Random();
  Set<int> pickedIndices = {}; // To store already picked indices

  while (pickedIndices.length < count) {
    int index = random.nextInt(source.length);

    if (!pickedIndices.contains(index)) {
      target.add(source[index]);
      pickedIndices.add(index); // Mark this index as picked
    }
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
  void _updateUserPinDimensions(GlobalKey pinKey) {
    final renderBox = pinKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      setState(() {
        final pin = userPins.firstWhere((pin) => pin.key == pinKey);
        pin.width = size.width;
        pin.height = size.height;
      });
    }
  }
}

