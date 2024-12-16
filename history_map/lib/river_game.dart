import 'dart:async';
import 'dart:math';

import 'package:MapMarking/test11.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:MapMarking/main.dart';
import 'package:MapMarking/gameSelection.dart';
import 'package:MapMarking/widgets/riverPin.dart';
import 'package:url_launcher/url_launcher.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( 
    options: FirebaseOptions(
      apiKey: "AIzaSyB_TbwLrkbVfS4dvrlWLAwZTmdtZEBa4ko",
      authDomain: "historymap-f4e49.firebaseapp.com",
      projectId: "historymap-f4e49",
      storageBucket: "historymap-f4e49.firebasestorage.app",
      messagingSenderId: "520243215533",
      appId: "1:520243215533:web:78965dedfe72246d445a24",
      measurementId: "G-ELRTJMMGKN",
    ),
  );
  runApp(RiverGameApp(Language: 'Tamil',Map: 'sl',numOfPlaces: 5,level: 'Easy',)); 
}
 

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



class RiverGameApp extends StatefulWidget {
  final String Language;
  final String Map;
  final String level;
  final int numOfPlaces;
  RiverGameApp({required this.Language,required this.Map,required this.level,required this.numOfPlaces});
  @override
  _RiverGameAppState createState() => _RiverGameAppState();
}

class _RiverGameAppState extends State<RiverGameApp> {
  List<Riverpin> riverPins = [];
  List<Riverpin> userriverPins = [];
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
                onriverPinsUpdated: (updatedriverPins) {
                  setState(() {
                    riverPins = updatedriverPins;
                  });
                },
                onUserriverPinsUpdated: (updatedUserriverPins) {
                  setState(() {
                    userriverPins = updatedUserriverPins;
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
    height: 465, 
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
  '2. Double-tap the map where you think that place is located to drop a Pin.\n\n'
  '3. You can zoom in to see the map in more detail.\n\n'
  '4. Be careful! Once you place a Pin, you can’t take it back.\n\n'
  '5. Place all the Pins before the timer at the bottom runs out.\n\n'
  '6. Accuracy and speed are key. Good luck!',
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

  Future<void> _updateriverPinVisibilityInFirestore(Riverpin riverPin) async {
    try {
      await FirebaseFirestore.instance.collection('riverPins').doc(riverPin.id).update({'isVisible': riverPin.isVisible});
    } catch (e) {
      print('Error updating riverPin visibility: $e');
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
  final Function(List<Riverpin>) onriverPinsUpdated;
  final Function(List<Riverpin>) onUserriverPinsUpdated;
  final double screenHeight;
  final double screenWidth;
  GameInteractiveContainer({required this.onriverPinsUpdated,required this.onUserriverPinsUpdated,required this.screenHeight,required this.screenWidth,required this.Language,required this.Map,required this.level,required this.numOfPlaces,required this.instruct});

  @override
  _GameInteractiveContainerState createState() => _GameInteractiveContainerState();
}
class _GameInteractiveContainerState extends State<GameInteractiveContainer> {
  int _start = 210; 
  late Timer _timer;
  Offset mousePosition = Offset.zero;
  Offset clickPosition = Offset.zero; // Position of the click
  final GlobalKey containerKey = GlobalKey(); // Key for the container
  List<Riverpin> riverPins = [];
  List<Riverpin> selectedriverPins = []; 
  List<Riverpin> userriverPins = [];
  int currentriverPinIndex = 0;
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
    _loadriverPinsFromFirestore();
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
    if(currentriverPinIndex >= selectedriverPins.length && currentriverPinIndex != 0 && isGameOver == false){      
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
          if ((!(currentriverPinIndex >= selectedriverPins.length))&&!isGameOver){ 
             
            _addriverPin(Offset(px, py), selectedriverPins[currentriverPinIndex].labelT,selectedriverPins[currentriverPinIndex].labelS,selectedriverPins[currentriverPinIndex].labelE,selectedriverPins[currentriverPinIndex].isRiver,int.parse(tappedLabel));
                      
            currentriverPinIndex++;
              
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
                      'assets/river_map.svg', 
                      width: double.infinity,
                      height: double.infinity,
                      fit: isProperRatio ? BoxFit.fitHeight : BoxFit.fitWidth,
                      color: Colors.white,
                    ),                      
                    Center(child: GridOverlay(rows: 200, columns: 100, gridWidth: 300*scaleX, gridHeight: 600*scaleY), ),
                    if(isViewResult)
                    for (var riverPin in selectedriverPins)
                      if (riverPin.isVisible)
                        Positioned(
                          left: (riverPin.position.dx * scaleX) +
                              (isProperRatio ? driftX : 0) - (!riverPin.isRiver ? riverPin.width / 2 : 0),
                          top: riverPin.position.dy * scaleY +
                              (!isProperRatio ? driftY : 0) -
                              riverPin.height +
                              2,
                          child: Container(
                            key: riverPin.key,
                            child: Column( 
                              children: [
                                Transform.rotate(angle: riverPin.angel * pi / 180,alignment: Alignment.centerLeft,child: Container(
                                  decoration: BoxDecoration(
                                    color: riverPin.isRiver ? Color.fromARGB(255, 25, 34, 49) : Color.fromARGB(255, 29, 63, 58),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  child: 
                                    Text(
                                      ((widget.Language == "Tamil" ? riverPin.labelT: widget.Language == "Sinhala" ? riverPin.labelS : riverPin.labelE)),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 4, 
                                      ),
                                  ),
                                ), ), 
                                if (!riverPin.isRiver)
                                Icon(Icons.location_pin,
                                    color: const Color.fromARGB(255, 29, 63, 58), size: 6), 
                                 
                              ],
                            ),
                          ),
                        ), 
                  
                        for (var riverPin in userriverPins)
                      if (riverPin.isVisible) 
                        Positioned(
                          left: (riverPin.position.dx * scaleX) +
                              (isProperRatio ? driftX : 0) -
                              riverPin.width / 2,
                          top: riverPin.position.dy * scaleY +
                              (!isProperRatio ? driftY : 0) -
                              riverPin.height +
                              2,
                          child: Container(
                            key: riverPin.key,
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
                                      ((widget.Language == "Tamil" ? riverPin.labelT: widget.Language == "Sinhala" ? riverPin.labelS : riverPin.labelE)),
                 
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 4
                                      ),
                                  ),
                                ),
                                if (!riverPin.isRiver)
                                Icon(Icons.location_pin,
                                    color: const Color.fromARGB(255, 29, 63, 58), size: 6),
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
                                  '$correctCount/${selectedriverPins.length}'.toUpperCase(), 
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
        for (var riverPin in selectedriverPins) {
          _updateriverPinDimensions(riverPin.key); 
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
                                        MaterialPageRoute(builder: (context) => MainPage()),
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
                                    userriverPins = [];
                                    isGameOver = false;
                                    currentriverPinIndex = 0;
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
                                        MaterialPageRoute(builder: (context) => GameOptionsPage(selectedDifficulty: widget.level,selectedLanguage: widget.Language,selectedMap: widget.Map,selectedPlaces: widget.numOfPlaces.toString() ,)), 
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
                          (currentriverPinIndex >= 0 && currentriverPinIndex < selectedriverPins.length)
    ? (widget.Language == "Tamil"
        ? selectedriverPins[currentriverPinIndex].labelT
        : widget.Language == "Sinhala"
            ? selectedriverPins[currentriverPinIndex].labelS
            : selectedriverPins[currentriverPinIndex].labelE)
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
                          "${userriverPins.length}/${selectedriverPins.length}")
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

  void _addriverPin(Offset position, String labelT,String labelS,String labelE,bool isRiver,int index){
    String riverPinId = DateTime.now().millisecondsSinceEpoch.toString();
    GlobalKey riverPinKey = GlobalKey();
    Riverpin newriverPin = Riverpin(
      id: riverPinId,
      key: riverPinKey,
      position: position,
      labelT: labelT,
      labelE: labelE,
      labelS: labelS, 
      width: 0.0,
      height: 0.0,
      isVisible: true,
      angel: 0,
      isRiver: isRiver,
      index: index
    );

    setState(() {
      userriverPins.add(newriverPin);
    });
 
    widget.onUserriverPinsUpdated(userriverPins);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateUserriverPinDimensions(riverPinKey); 
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
  
  for (int riverPinNum = 0; riverPinNum < userriverPins.length; riverPinNum++) {
    double userX = userriverPins[riverPinNum].position.dx;
    double userY = userriverPins[riverPinNum].position.dy;
    double correctX = selectedriverPins[riverPinNum].position.dx;
    double correctY = selectedriverPins[riverPinNum].position.dy;
    double distance = sqrt(pow(userX - correctX, 2) + pow(userY - correctY, 2));
    int index = selectedriverPins[riverPinNum].index;
    int indexUser = userriverPins[riverPinNum].index;
    bool good = selectedriverPins[riverPinNum].isRiver ? index == indexUser : distance < 10; 
    
    print(distance);
    
    results.add(Result(
      LabelT: selectedriverPins[riverPinNum].labelT,
      LabelS: selectedriverPins[riverPinNum].labelS,
      LabelE: selectedriverPins[riverPinNum].labelE,
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
 

  Future<void> _saveriverPinToFirestore(Riverpin riverPin) async {
    try {
      await firestore.collection('riverPins').add(riverPin.toMap());
    } catch (e) {
      print('Error saving riverPin: $e');
    }
  }

  void _loadriverPinsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('riverPins').get();
      setState(() {
        riverPins = querySnapshot.docs.map((doc) => Riverpin.fromFirestore(doc)).toList();
      });
      widget.onriverPinsUpdated(riverPins);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var riverPin in riverPins) {
          _updateriverPinDimensions(riverPin.key);
        }
        
      });
      
      
     randomPick(riverPins, selectedriverPins, widget.numOfPlaces);
      
    } catch (e) {
      print('Error loading riverPins: $e');
    }
  }

  void randomPick(List<Riverpin> source, List<Riverpin> target, int count) {
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

  void _updateriverPinDimensions(GlobalKey riverPinKey) {
    final renderBox = riverPinKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      setState(() {
        final riverPin = riverPins.firstWhere((riverPin) => riverPin.key == riverPinKey);
        riverPin.width = size.width;
        riverPin.height = size.height;
      });
    }
  }
  void _updateUserriverPinDimensions(GlobalKey riverPinKey) {
    final renderBox = riverPinKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      setState(() {
        final riverPin = userriverPins.firstWhere((riverPin) => riverPin.key == riverPinKey);
        riverPin.width = size.width;
        riverPin.height = size.height;
      });
    }
  }
}

