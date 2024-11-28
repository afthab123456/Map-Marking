import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:history_map/main.dart';
import 'package:history_map/widgets/pin.dart';



class ViewerApp extends StatefulWidget {
  @override
  _ViewerAppState createState() => _ViewerAppState();
}

class _ViewerAppState extends State<ViewerApp> {
  List<Pin> pins = [];
  bool isMenu = false;
  bool isSettings = true;
  void toggleVisibility(int index) {
    setState(() {
      pins[index].isVisible = !pins[index].isVisible;
    });
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
            
        
        
          ), 
          if (!isSettings)
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
            if(!isSettings)
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
              isSettings ? Center(child: 
            Stack(children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), 
                    child: Container(
                      width: 550,                       
                      height: screenHeight - 50,
                      padding: screenWidth > 355 ? EdgeInsets.all(50) : EdgeInsets.all(25),
                      margin: EdgeInsets.only(left: 20,right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        crossAxisAlignment: CrossAxisAlignment.start,  
                        children: [
                          
                          Text("Map Settings",style: TextStyle(color: Colors.white,fontSize: 20,)),
                          SizedBox(height: 30,),
                          Text('Language',style: TextStyle(color: Colors.white,fontSize: 15,)),
                          SizedBox(height: 15,),
                          Wrap(children: [                            
                            OutlinedButton(onPressed: (){}, child: Text('Tamil',style: TextStyle(color: Colors.white,fontSize: 12,))),
                            SizedBox(width: 10,), 
                            OutlinedButton(onPressed: (){}, child: Text('Sinhala',style: TextStyle(color: Colors.white,fontSize: 12,))),
                            SizedBox(width: 10,), 
                            OutlinedButton(onPressed: (){}, child: Text('English',style: TextStyle(color: Colors.white,fontSize: 12,))),
                          ],), 
                          SizedBox(height: 20,),
                          Text('Pin Visibility',style: TextStyle(color: Colors.white,fontSize: 15,)),
                          SizedBox(height: 15,), 
                          Row(children: [                            
                            OutlinedButton(onPressed: (){}, child: Row(children: [Text('Show All',style: TextStyle(color: Colors.white,fontSize: 12,)),SizedBox(width: 10,) ,Icon(Icons.visibility,size: 18,color: Colors.white,) ],)
                            ),
                            SizedBox(width: 10,), 
                            OutlinedButton(onPressed: (){}, child: Row(children: [Text('Hide All',style: TextStyle(color: Colors.white,fontSize: 12,)),SizedBox(width: 10,) ,Icon(Icons.visibility_off,size: 18,color: Colors.white,) ],)
                            ), 
                          ],),
                          SizedBox(height: 10,), 
                          Expanded(child: 
                          Container(
            // Fixed height for the scrollable list
          
          
          child: ListView.builder(
            itemCount: pins.length, // Use the pins list for the length
            itemBuilder: (context, index) {
              return Container(
  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 2.0),
  decoration: BoxDecoration( 
    borderRadius: BorderRadius.circular(25), 
    border: Border.all(color: const Color.fromARGB(143, 220, 158, 254),width: 1)
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        pins[index].label,
        style: TextStyle(fontSize: 13.0,color: Colors.white),
      ),
      IconButton(
        icon: Icon(
          pins[index].isVisible ? Icons.visibility : Icons.visibility_off,
          color: pins[index].isVisible ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 196, 196, 196),
        ),
        onPressed: () => toggleVisibility(index), // Toggle visibility
      ),
    ],
  ),
);
 
            },
          ))) 
                        ],
                      ) 
                    ),
                  ),
                ),
          Positioned(
                            right: 50,
                            top: 25,

                            child: GestureDetector(
                              onTap: () {
                                print('object'); 
                                setState(() {
                                  isSettings = false;
                                });
                              },
                              child: Icon(Icons.close_rounded,color: Colors.white,),
                            )),
  ])):SizedBox()                
             ],)
        )  
              
      ); 
    
  }

  Future<void> _updatePinVisibilityInFirestore(Pin pin) async {
    try {
      await FirebaseFirestore.instance.collection('pins').doc(pin.id).update({'isVisible': pin.isVisible});
    } catch (e) {
      print('Error updating pin visibility: $e');
    }
  }
}

class InteractiveContainer extends StatefulWidget {
  final Function(List<Pin>) onPinsUpdated;  
  final double screenHeight;
  final double screenWidth;
  InteractiveContainer({required this.onPinsUpdated,required this.screenHeight,required this.screenWidth});

  @override
  _InteractiveContainerState createState() => _InteractiveContainerState();
}
class _InteractiveContainerState extends State<InteractiveContainer> {
  Offset mousePosition = Offset.zero;
  Offset clickPosition = Offset.zero; // Position of the click
  final GlobalKey containerKey = GlobalKey(); // Key for the container
  List<Pin> pins = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
          //_addPin(Offset(px, py), 'teeees');
          
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
                                    color: Color.fromARGB(255, 47, 52, 61),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  padding: EdgeInsets.only(left: 5,right: 5),
                                  child: 
                                    Text(
                                      pin.label,
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
                  ],
                ),
              ),
            ),
            
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
        }
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