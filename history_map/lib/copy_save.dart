import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

class Pin {
  final String id;
  final GlobalKey key;
  final Offset position;
  String label;
  double width;
  double height;
  bool isVisible;

  Pin({
    required this.id,
    required this.key,
    required this.position,
    required this.label,
    required this.width,
    required this.height,
    this.isVisible = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'position': {'x': position.dx, 'y': position.dy},
      'timestamp': FieldValue.serverTimestamp(),
      'isVisible': isVisible,
    };
  }

  factory Pin.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Pin(
      id: doc.id,
      key: GlobalKey(),
      position: Offset(
        data['position']['x']?.toDouble() ?? 0.0,
        data['position']['y']?.toDouble() ?? 0.0,
      ),
      label: data['label'] ?? '',
      width: 0.0,
      height: 0.0,
      isVisible: data['isVisible'] ?? true,
    );
  }
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
  @override  
  Widget build(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        body:
              
              InteractiveContainer(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onPinsUpdated: (updatedPins) {
                  setState(() {
                    pins = updatedPins;
                  });
                },
            
        
        
          ),
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

class InteractiveContainer extends StatefulWidget {
  final Function(List<Pin>) onPinsUpdated;  
  final double screenHeight;
  final double screenWidth;
  InteractiveContainer({required this.onPinsUpdated,required this.screenHeight,required this.screenWidth});

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
    bool isProperRatio = true;
    if (widget.screenHeight/2 > widget.screenWidth){
      setState(() {
        isProperRatio = false;
      });
    }
    double scaleY = widget.screenHeight / 600;
    double scaleX = widget.screenHeight / 2 / 300;
    double driftX = (widget.screenWidth - (widget.screenHeight / 2))/2;

    double driftY = (widget.screenHeight - (widget.screenWidth*2))/2;
    
    return InteractiveViewer(
      minScale: 1,
      maxScale: 5.0,
      
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(18),
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
                    left: (pin.position.dx * scaleX) + (isProperRatio ? driftX : 0) - pin.width / 2,
                    top: pin.position.dy * scaleY + (!isProperRatio ? driftY: 0)- pin.height + 2,
                    child: Container(
                      key: pin.key,
                      child: Column(
                        children: [
                          Text(
                            pin.label,
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
