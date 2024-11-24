import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        appBar: AppBar(title: Text('Zoomable & Pannable Container')),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              InteractiveContainer(),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class Pin {
  final String id;
  final GlobalKey key;
  final Offset position;
  String label;
  double width;
  double height;

  Pin({
    required this.id,
    required this.key,
    required this.position,
    required this.label,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'position': {'x': position.dx, 'y': position.dy},
      'timestamp': FieldValue.serverTimestamp(),
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
    );
  }
}

class InteractiveContainer extends StatefulWidget {
  @override
  _InteractiveContainerState createState() => _InteractiveContainerState();
}

class _InteractiveContainerState extends State<InteractiveContainer> {
  double pointerPercentage = 0.0;
  List<Pin> pins = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
            borderRadius: BorderRadius.circular(50),
          ),
          width: 320,
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
                Positioned(
                  left: pin.position.dx - pin.width / 2,
                  top: pin.position.dy - pin.height + 2,
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
                        Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 20,
                        ),
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Label"),
          ),
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
    );

    setState(() {
      pins.add(newPin);
    });

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

  @override
  void initState() {
    super.initState();
    _loadPinsFromFirestore();
  }
}
