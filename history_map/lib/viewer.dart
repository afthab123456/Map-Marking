import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
 bool isSearch = false;
 bool isSearchR = true;
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
void showSpecificPin(List<Pin> pins, String pinId) {
  for (var pin in pins) {
    setState(() {
      pin.isVisible = pin.id == pinId; 
    });
  }
}

String searchQuery = '';
String LastSearch = '';

TextEditingController _controller = TextEditingController();
  @override  
  Widget build(BuildContext context) {
    List<Pin> filteredPins = pins.where((pin) {
      return pin.labelT.toLowerCase().contains(searchQuery.toLowerCase()) ||
          pin.labelS.toLowerCase().contains(searchQuery.toLowerCase()) ||
          pin.labelE.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Sort by the position of the query (front matches first).
    filteredPins.sort((a, b) {
      int getPriority(String label) {
        int index = label.toLowerCase().indexOf(searchQuery.toLowerCase());
        return index == -1 ? 999 : index; // Assign a high value if no match.
      }

      int compareT = getPriority(a.labelT).compareTo(getPriority(b.labelT));
      int compareS = getPriority(a.labelS).compareTo(getPriority(b.labelS));
      int compareE = getPriority(a.labelE).compareTo(getPriority(b.labelE));

      // Compare based on Tamil, Sinhala, then English.
      return compareT != 0 ? compareT : (compareS != 0 ? compareS : compareE);
    }); 
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;
      if (searchQuery != LastSearch){
        setState(() {
          isSearchR = true;
          
        });
      }
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
          isSearch?
        Column(
        children: [
          Center(child: Container(
            margin: EdgeInsets.all(20), 
            width: 300,child: 
        TextField(
          controller: _controller,
  decoration: InputDecoration(
    suffixIcon: searchQuery.isEmpty ?GestureDetector(onTap: () {       
              setState(() {
                isSearch = false; // Reset any search-related variables if needed
              });
      }, 
      child: Padding(
      padding: EdgeInsets.only(left: 10, right: 20), // Push the icon inward
      child: Icon(Icons.close_rounded, color: Colors.white,), 
   )):GestureDetector(
      onTap: () {
       _controller.clear(); // Clear the text in the TextField
              setState(() {
                searchQuery = ""; // Reset any search-related variables if needed
              });
              showAllPins(pins); 
      },
      child: Padding(
      padding: EdgeInsets.only(left: 10, right: 20), // Push the icon inward
      child: Icon(Icons.close_rounded, color: Colors.white,), 
    ),), 
    hintText: 'Search', 
    hintStyle: TextStyle(color: const Color.fromARGB(255, 209, 209, 209)),
    contentPadding: EdgeInsets.only(left: 20),
     
    filled: true,
    fillColor: Color.fromARGB(255, 19, 21, 24), // Black background
    
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50), // Border radius of 50
      borderSide: BorderSide(color: const Color.fromARGB(0, 47, 47, 47)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: const Color.fromARGB(0, 12, 12, 12)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: const Color.fromARGB(0, 17, 17, 17)),
    ),
  ),
  style: TextStyle(color: Colors.white),
  onChanged: (query) {
    setState(() {
      searchQuery = query;
    });
  },
  onTap: () {
    // When the field is tapped, the hint will disappear (optional setup)
  },
),
),  
          ),  !searchQuery.isEmpty
                && !filteredPins.isEmpty && isSearchR
                    ?  Center(child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color.fromARGB(255, 19, 21, 24)),
                        
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 300,
                            maxWidth: 300, 
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredPins.length,
                            itemBuilder: (context, index) {
                              final pin = filteredPins[index];
                              return   ListTile(onTap: () {
                                setState(() {
                                  isSearchR = false;
                                  LastSearch = searchQuery;
                                });
       showSpecificPin(pins,pin.id);
      },

      
                                
                                leading: Icon(Icons.location_pin, color: Colors.red,),  
                                title: Text(pin.labelE,style: TextStyle(color: Colors.white,fontSize: 16),),
                                subtitle: Text('${pin.labelT} | ${pin.labelS}',style: TextStyle(color: Colors.white,fontSize: 10),),
                              );   
                            },
                          ),
                        ),
                      ), ):SizedBox(),
           
        ],
      ):SizedBox(),   if (!isSettings&&!islanguageSelect&&!isSearch) 
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
            if(!isSettings&&!islanguageSelect&&!isSearch)
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
                                if(!isSettings&&!islanguageSelect&&!isSearch)
            Positioned(
                      top: 20,
                      right: 80, 
                      child: TextButton(
                        style: TextButton.styleFrom(
    iconColor: Colors.white, //  Text color
    backgroundColor: const Color.fromARGB(0, 33, 149, 243), // Button background color
  ),
                        onPressed:() {setState(() {
                                  isSearch = true;
                                  isSearchR = true;
                                });}, child: Icon(Icons.search_rounded ))),
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
              children: ['Tamil', 'Sinhala','English'].map((language) {
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
  child: IntrinsicHeight(child: 
  Container(   
    width: 200, 
    decoration: BoxDecoration(
      color:Color.fromARGB(255, 19, 21, 24),
      borderRadius: BorderRadius.circular(20) 
    ), 
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, 
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
              mainAxisAlignment: MainAxisAlignment.center,    
              children: ['Tamil', 'Sinhala','English' ].map((language) {
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
 ))
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
          //Uncomment this to add new places
          //final label = await showLabelInputDialog(context);
          //if (label != null && label.isNotEmpty) {
          //  print('Entered Label: $label');
          //  _addPin(Offset(px, py), label,'sinhala$tindex','english$tindex');
          //}
          
          //tindex ++; 
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
                    SvgPicture.asset(
                      'assets/test.svg', 
                      width: double.infinity,
                      height: double.infinity,
                      fit: isProperRatio ? BoxFit.fitHeight : BoxFit.fitWidth,
                      color: Colors.white,
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