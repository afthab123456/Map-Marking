import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:MapMarking/widgets/pin.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
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
  runApp(App());
}



void _launchURL() async {
  const url = 'https://github.com/afthab123456'; // Replace with your GitHub URL
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<Pin> pins = [];
  bool isMenu = false;
  String Language = "Tamil";
  @override  
  Widget build(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        body:SingleChildScrollView(child:  Center(
          child: screenWidth >1000 ?
          Column(
            children: [
              SizedBox(height: 50,),
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:screenWidth > 1170 ? 400 : 320,
                height: 600,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.map_rounded, size: 50, color: const Color.fromARGB(255, 5, 55, 116)),
                          SizedBox(height: 20),
                          Text(
                            "HistoryMap",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 5, 55, 116)),
                          ),
                          SizedBox(height: 40),
                          Text(
                            "Explore and learn about key historical locations with an interactive map for the OL examinations. Discover the places that shaped our world.\nWe're constantly working to improve the app's coverage.",
                            style: TextStyle(fontSize: 16, color: const Color.fromARGB(221, 252, 252, 252)),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Have any feedback? Let us know if you find any inaccuracies or missing historical places! Your input is invaluable to improving the app.",
                            style: TextStyle(fontSize: 14, color: const Color.fromARGB(137, 255, 255, 255)),
                          ),
                          SizedBox(height: 20),
                          
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Version 1.0", style: TextStyle(fontSize: 14, color: const Color.fromARGB(137, 255, 255, 255))),
                          TextButton(
                            onPressed: _launchURL,
                            child: Text("Developed by Afthab Ahamed", style: TextStyle(color: const Color.fromARGB(255, 5, 55, 116), fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              InteractiveContainer(
                onPinsUpdated: (updatedPins) {
                  setState(() {
                    pins = updatedPins;
                  });
                },
              ),
              SizedBox(width: 20),
              Container(
                width:screenWidth > 1170 ? 400 : 300,
                height: 600,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          "Places",
                          style: TextStyle(fontSize: 30, color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var pin in pins)
                        Container(
                          padding: EdgeInsets.only(top: 1, bottom: 1, left: 10, right: 10),
                          child: Container(
                            decoration: BoxDecoration(color: const Color.fromARGB(255, 10, 10, 10), borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(pin.labelT, style: TextStyle(color: Colors.white)),
                                IconButton(
                                  icon: Icon(
                                    pin.isVisible ? Icons.visibility : Icons.visibility_off,
                                    color: pin.isVisible ? Color.fromARGB(255, 214, 214, 214) : Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pin.isVisible = !pin.isVisible;
                                    });
                                    _updatePinVisibilityInFirestore(pin);
                                  },
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
          )],
          ): Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                width: 320,
                height: 600,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.map_rounded, size: 50, color: const Color.fromARGB(255, 5, 55, 116)),
                          SizedBox(height: 20),
                          Text(
                            "HistoryMap",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 5, 55, 116)),
                          ),
                          SizedBox(height: 40),
                          Text(
                            "Explore and learn about key historical locations with an interactive map for the OL examinations. Discover the places that shaped our world.\nWe're constantly working to improve the app's coverage.",
                            style: TextStyle(fontSize: 16, color: const Color.fromARGB(221, 252, 252, 252)),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Have any feedback? Let us know if you find any inaccuracies or missing historical places! Your input is invaluable to improving the app.",
                            style: TextStyle(fontSize: 14, color: const Color.fromARGB(137, 255, 255, 255)),
                          ),
                          SizedBox(height: 20),
                          
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Version 1.0", style: TextStyle(fontSize: 14, color: const Color.fromARGB(137, 255, 255, 255))),
                          TextButton(
                            onPressed: _launchURL,
                            child: Text("Developed by Afthab Ahamed", style: TextStyle(color: const Color.fromARGB(255, 5, 55, 116), fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  InteractiveContainer(
                onPinsUpdated: (updatedPins) {
                  setState(() {
                    pins = updatedPins;
                  });
                },
              ), 
              isMenu?
              Container( ///This should be hidden unless a button is pressed add the button
                width: 320,
                height: 600,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(201, 0, 0, 0),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: SingleChildScrollView( 
                  child: Stack(
                    children: [
                      Positioned(child: GestureDetector(onTap: (){setState(() {
                        isMenu = false;
                      });},child: Icon(Icons.close_rounded,color: Colors.white,)),left: 280,top: 20),
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          "Places",
                          style: TextStyle(fontSize: 30, color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var pin in pins) 
                        Container(
                          padding: EdgeInsets.only(top: 1, bottom: 1, left: 10, right: 10),
                          child: Container(
                            decoration: BoxDecoration(color: const Color.fromARGB(255, 10, 10, 10), borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(pin.labelT, style: TextStyle(color: Colors.white)),
                                IconButton(
                                  icon: Icon(
                                    pin.isVisible ? Icons.visibility : Icons.visibility_off,
                                    color: pin.isVisible ? Color.fromARGB(255, 214, 214, 214) : Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pin.isVisible = !pin.isVisible;
                                    });
                                    _updatePinVisibilityInFirestore(pin);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                    ],
                  ),
                
                  ],)),
              ): Positioned(child: GestureDetector(onTap: (){setState(() {
                        isMenu = true;
                      });},child: Icon(Icons.menu_rounded,color: Colors.white,)),left: 280,top: 20), 
            ]),
              SizedBox(height: 20),
              
            ],
          ),
        
        
          ),
      )),
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

  InteractiveContainer({required this.onPinsUpdated});

  @override
  _InteractiveContainerState createState() => _InteractiveContainerState();
}

class _InteractiveContainerState extends State<InteractiveContainer> {
  double pointerPercentage = 0.0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Pin> pins = [];

  @override
  void initState() {
    super.initState();
    _loadPinsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 5.0,
      child: Listener(
        onPointerMove: (details) {
          setState(() {
            double containerHeight = 600.0;
            double positionY = details.localPosition.dy;
            pointerPercentage = (positionY / containerHeight) * 100;
            pointerPercentage = pointerPercentage.clamp(0.0, 100.0);
          });
        },
        onPointerDown: (details) async {
          String? label = await _getLabelFromUser(context);
          if (label != null && label.isNotEmpty) {
            _addPin(details.localPosition, label);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(18),
          ),
          width: 300,
          height: 600,
          child: Stack(
            children: [
              Image.asset(
                'assets/map_image.png', 
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fitHeight, 
              ),
              for (var pin in pins)
                if (pin.isVisible)
                  Positioned(
                    left: pin.position.dx - pin.width / 2,
                    top: pin.position.dy - pin.height + 2,
                    child: Container(
                      key: pin.key,
                      child: Column(
                        children: [
                          Text(
                            pin.labelT,
                            style: TextStyle(color: Colors.white, fontSize: 12, backgroundColor: Colors.black54),
                          ),
                          Icon(Icons.location_pin, color: Colors.red, size: 20),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _getLabelFromUser(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Pin Label"),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addPin(Offset position, String label) {
    String pinId = DateTime.now().millisecondsSinceEpoch.toString();
    GlobalKey pinKey = GlobalKey();
    Pin newPin = Pin(
      id: pinId,
      key: pinKey,
      position: position,
      labelT: label,
      labelE: label,
      labelS: label,
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
