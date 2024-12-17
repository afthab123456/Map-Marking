import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:MapMarking/main.dart';
import 'package:MapMarking/gameSelection.dart';
import 'package:MapMarking/widgets/pin.dart';
import 'package:url_launcher/url_launcher.dart';


class Result{
  final String LabelT;
  final String LabelS;
  final String LabelE;
  final int distance;
  final bool good;
  Result({
    required this.LabelT,
    required this.LabelS,
    required this.LabelE,
    required this.distance,
    required this.good,
  });
  Map<String, dynamic> toMap() {
    return {
      'labelT': LabelT,
      'labelS': LabelS,
      'labelE': LabelE,
      'distance': distance,
      'good': good
    };
  }
}



class GameApp extends StatefulWidget {
  final String Language;
  final String Map;
  final String level;
  final int numOfPlaces;
  GameApp({required this.Language,required this.Map,required this.level,required this.numOfPlaces});
  @override
  _GameAppState createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  List<Pin> pins = [];
  List<Pin> userPins = [];
  bool isMenu = false;
  bool instruct = true;
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
                Language: widget.Language,
                numOfPlaces: widget.numOfPlaces,
                level: widget.level,
                Map: widget.Map,
                instruct: instruct,
        
        
          ),
          
            if(instruct) Center(
  child: Container(
    height: 410, 
    width: 300, 
    decoration: BoxDecoration(
      color:Color.fromARGB(255, 19, 21, 24),
      borderRadius: BorderRadius.circular(20) 
    ), 
    padding: EdgeInsets.all(20), 
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Text('Game Instructions', style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      height: 1.2,
                                    ),
                                  )),
                                  SizedBox(height: 20,), 
        Text(
  '1. Look at the place name displayed at the bottom of the screen.\n\n'
  '2. Double-tap the map where you think that place is located to drop a pin.\n\n'
  '3. Be careful! Once you place a pin, you can’t take it back.\n\n'
  '4. Place all the pins before the timer at the bottom runs out.\n\n'
  '5. Accuracy and speed are key. Good luck!',
  style: GoogleFonts.play(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color(0xFFc7e3da),
      height: 1.2,
    ),
  ),
),
SizedBox(height: 20,),
 ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                ), 
                                onPressed: () {                                  
                                  setState(() {
                                    instruct = false;
                                  });
                                }, 
                                child: Text('Proceed',style:  GoogleFonts.play(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color(0xFFc7e3da),
      height: 1.2,
    ),)),),
 
      ]
    ),
    ))
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

  bool isGameOver = false;
  bool isViewResult = false; 
  List<Result> results = [];
  int correctCount = 0;
  bool isRepeat = false;
  
class GameInteractiveContainer extends StatefulWidget { 
  final bool instruct;
  final String Language;
  final String Map;
  final String level;
  final int numOfPlaces;
  final Function(List<Pin>) onPinsUpdated;
  final Function(List<Pin>) onUserPinsUpdated;
  final double screenHeight;
  final double screenWidth;
  GameInteractiveContainer({required this.onPinsUpdated,required this.onUserPinsUpdated,required this.screenHeight,required this.screenWidth,required this.Language,required this.Map,required this.level,required this.numOfPlaces,required this.instruct});

  @override
  _GameInteractiveContainerState createState() => _GameInteractiveContainerState();
}
class _GameInteractiveContainerState extends State<GameInteractiveContainer> {
  int _start = 210; 
  late Timer _timer;
  Offset mousePosition = Offset.zero;
  Offset clickPosition = Offset.zero; // Position of the click
  final GlobalKey containerKey = GlobalKey(); // Key for the container
  List<Pin> pins = [];
  List<Pin> selectedPins = []; 
  List<Pin> userPins = [];
  int currentPinIndex = 0;
  bool isGameOver = false;
  List<Result> results = [];
  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      isViewResult = false;
      isRepeat = false;
    });
    _loadPinsFromFirestore();
    _start = widget.numOfPlaces * 
         (widget.level == "Easy" ? 15 : 
         (widget.level == "Medium" ? 10 : 
         (widget.level == "Hard" ? 5 : 1))); 
    
  }
 @override
  void didUpdateWidget(covariant GameInteractiveContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the bool changed to false
    if (!widget.instruct && oldWidget.instruct != widget.instruct) {
      startTimer(); 
    }
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
    double scaleY = isProperRatio ? widget.screenHeight / 600: (widget.screenWidth*2)/600;
    double scaleX = isProperRatio ? widget.screenHeight / 2 / 300 : (widget.screenWidth)/300;
    double driftX = (widget.screenWidth - (widget.screenHeight / 2)) / 2;
    double driftY = (widget.screenHeight - (widget.screenWidth * 2)) / 2; 
   
      
    return GestureDetector(
      onDoubleTapDown: (details) { 
        final renderBox =
            containerKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {clickPosition = renderBox.globalToLocal(details.globalPosition);
          double px = ((clickPosition.dx)-(isProperRatio ? driftX : 0))/scaleX; 
          double py = ((clickPosition.dy)-(!isProperRatio ? driftY : 0))/scaleY;
          if ((!(currentPinIndex >= selectedPins.length))&&!isGameOver){ 
             
            _addPin(Offset(px, py), selectedPins[currentPinIndex].labelT,selectedPins[currentPinIndex].labelS,selectedPins[currentPinIndex].labelE);
                      
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
                  color: Color.fromARGB(255, 10, 12, 13), 
                ),
                width: widget.screenWidth,
                height: widget.screenHeight,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/test.svg', 
                      width: double.infinity,
                      height: double.infinity,
                      fit: isProperRatio ? BoxFit.fitHeight : BoxFit.fitWidth,
                      color: Colors.white,
                    ), 
                    
                    if(isViewResult)
                    for (var pin in selectedPins)
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
                                      ((widget.Language == "Tamil" ? pin.labelT: widget.Language == "Sinhala" ? pin.labelS : pin.labelE)),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10, 
                                      ),
                                  ),
                                ), 
                                Icon(Icons.location_pin,
                                    color: Colors.red, size: 16),
                              ],
                            ),
                          ),
                        ),
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
                                 Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 21, 23, 28), 
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  child: 
                                    Text(
                                      ((widget.Language == "Tamil" ? pin.labelT: widget.Language == "Sinhala" ? pin.labelS : pin.labelE)),
                 
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                  ),
                                ),
                                Icon(Icons.location_pin,
                                    color: Color.fromARGB(255, 37, 92, 75), size: 16),
                                ],
                            ),
                          ),
                        ),
                        
                        ],  
                ),
              ),
            ),
            Positioned(child: (isGameOver&&!isViewResult)? 
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(213, 10, 12, 13) 
                            ),
                            child: Center( // Ensures all children are centered
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // Shrinks the Column to fit its children
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                  'Scores'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      fontStyle: FontStyle.italic,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                if (isRepeat)
                                Text('Repeated', textAlign: TextAlign.center,
                                  style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      fontStyle: FontStyle.italic,
                                      height: 1.2,
                                    ),
                                  ),), 
                                SizedBox(height: 15,), 
                                Text(
                                  '$correctCount/${selectedPins.length}'.toUpperCase(), 
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.play( 
                                    textStyle: TextStyle(
                                      fontSize: 25, 
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFc7e3da),
                                      fontStyle: FontStyle.italic,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                   
                                  SizedBox(height: 15,),
                                  SizedBox(
                                    height: results.length < 5 ? ((results.length)*46) + 10 : 240, // Adjust height to avoid infinite expansion
                                    child: ListView.builder(
                                     
                                      shrinkWrap: true, // Prevents ListView from expanding infinitely
                                      itemCount: results.length,
                                      itemBuilder: (context, index) {
                                        final result = results[index];
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(3),
                                              width: 220,
                                              height: 40, 
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(255, 23, 26, 32),
                                                borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: 
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(children: [
                                                  SizedBox(width: 10,),
                                                Icon(Icons.location_pin,color: Color.fromARGB(255, 50, 124, 101), size: 16 ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center, 
                                              children: [
                                                Text(
                                                  (widget.Language == "Tamil" ? result.LabelT : widget.Language == "Sinhala" ? result.LabelS : result.LabelE),
                                                  style: TextStyle(color: Colors.white,fontSize: 10),
                                                ),
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
                                  SizedBox(height: 15), 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [ 
                                    ElevatedButton(style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.black,
                                    ),onPressed: (){setState(() {
                                    isViewResult = true;
                                  });
                                   WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var pin in selectedPins) {
          _updatePinDimensions(pin.key); 
        }
      });  

                                  }, child: Text('   View in Map   ',style:  GoogleFonts.play(
    textStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Color(0xFFc7e3da),
      height: 1.2,
    ),)),),
                                  SizedBox(width: 10,),  ElevatedButton(
                                    style: ElevatedButton.styleFrom( 
                                      backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyApp()),
                                      );
                                    },
                                    child: Icon(Icons.home_rounded,size: 18,color: Color(0xffc7e3da),),
                                  ),  
                                  
                               
                                  ],), 
                                  SizedBox(height: 10,),
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
                                  setState(() {
                                    isRepeat = true;
                                    isViewResult = false;
                                    userPins = [];
                                    isGameOver = false;
                                    currentPinIndex = 0;
                                  });
                                  
                                  _start = widget.numOfPlaces * 
                                  (widget.level == "Easy" ? 15 : 
                                  (widget.level == "Medium" ? 10 : 
                                  (widget.level == "Hard" ? 5 : 1)));                             
                                },
                                
                                child: Text('Repeat',style:  GoogleFonts.play(
    textStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Color(0xFFc7e3da),
      height: 1.2,
    ),)),),
                                  SizedBox(width: 10,), 
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                ), 
                                onPressed: () {                                  
                                  Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => GameOptionsPage(selectedDifficulty: widget.level,selectedLanguage: widget.Language,selectedMap: widget.Map,selectedPlaces: widget.numOfPlaces.toString(),)), 
                                      ); 
                                },
                                child: Text('New Game',style:  GoogleFonts.play(
    textStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: Color(0xFFc7e3da),
      height: 1.2,
    ),))
                              ), 
                              
                                  ],)
                              
                            ],
                          ),
                        ),
                      ),
                    ):SizedBox()
                  ),                 
                  if(!isGameOver&&!widget.instruct) 
                  Positioned(
                    bottom: 10, 
                    left: (MediaQuery.of(context).size.width - 250)/2,
                    child: Container(
                      width: 250,
                      child: Column(children: [
                        Container(
                      width: 250,
                      height: 30,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(255, 6, 8, 10)),
                      child: Center(
                        child:Text(
                          style: TextStyle( fontSize: 15,color: Colors.white), 
                          (currentPinIndex >= 0 && currentPinIndex < selectedPins.length)
    ? (widget.Language == "Tamil"
        ? selectedPins[currentPinIndex].labelT
        : widget.Language == "Sinhala"
            ? selectedPins[currentPinIndex].labelS
            : selectedPins[currentPinIndex].labelE)
    : 'Loading...')

                      ),
                    ), 
                    SizedBox(height: 5,), 
                    Row(children: [
                      Expanded(
                         
                        child: Container(
                      
                      height: 30, 
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(255, 6, 8, 10)),
                      child: Center(
                        child:Text(
                          style: TextStyle(fontSize: 15,color: Colors.white),
                          "${userPins.length}/${selectedPins.length}")
                      ),
                    ),), 
                    SizedBox(width: 5,), 
                    Expanded(
                      flex: 2,  
                      child: Container(
                      
                      height: 30,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(255, 6, 8, 10)),
                      child: Center( 
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                              Icon(Icons.timer_sharp,size: 18,color: Colors.white,),  
                            ],) ,
                            SizedBox(width: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text(
                          style: TextStyle( fontSize: 15,color: Colors.white),
                          "${formatTime(_start)}")
                            ],)
                          ],
                        )
                      ),
                    ),)
                    ],)
                      ],),
                    )
                  ),
                  if(isViewResult)
                      Positioned(
        right: 40, 
        top: 20, 
        child: CloseButton(onPressed: (){setState(() {
          isViewResult = false; 
        });},color: Colors.white,),),
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
      labelE: labelE,
      labelS: labelS,
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
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        gameOver();
      } else {
        setState(() {
          _start--;
        });
      }
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
    
    bool good = distance < 10;  // Set 'good' based on distance condition
    
    print(distance);
    
    results.add(Result(
      LabelT: selectedPins[pinNum].labelT,
      LabelS: selectedPins[pinNum].labelS,
      LabelE: selectedPins[pinNum].labelE,
      distance: distance.toInt(),
      good: good
    ));    
  }
  correctCount = countGoodResults(results); 
  
}
int countGoodResults(List<Result> results) {
  int goodCount = 0;
  for (var result in results) {
    if (result.good) {
      goodCount++;
    }
  }
  return goodCount;
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
      
      
     randomPick(pins, selectedPins, widget.numOfPlaces);
      
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

