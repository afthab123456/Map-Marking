import 'dart:math';

import 'package:MapMarking/remap.dart';
import 'package:MapMarking/test11.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:MapMarking/main.dart';
import 'package:MapMarking/marking_popup.dart';
import 'package:MapMarking/widgets/riverPin.dart';


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
  runApp(RiversViewerApp()); 
}
 


class RiversViewerApp extends StatefulWidget {
  @override
  _RiversViewerAppState createState() => _RiversViewerAppState();
}

class _RiversViewerAppState extends State<RiversViewerApp> {
  List<Riverpin> riverPins = [];
  bool isMenu = false;
  bool isSettings = false;
  bool islanguageSelect = true;
 bool isSearch = false;
 bool isSearchR = true;
  String selectedLanguage = 'Tamil';
  
  void toggleVisibility(int index) {
    setState(() {
      riverPins[index].isVisible = !riverPins[index].isVisible;
    });
  }
  void hideAllriverPins(List<Riverpin> riverPins) {
  for (var riverPin in riverPins) {
    setState(() {
      riverPin.isVisible = false;
    });
  }
}
void showAllriverPins(List<Riverpin> riverPins) {
  for (var riverPin in riverPins) {
    setState(() {
      riverPin.isVisible = true; 
    });
  }
}

  void updateVisibilityAll(List<Riverpin> riverPins, bool isVisible) {
  for (var riverPin in riverPins) {
    riverPin.isVisible = isVisible;
  }
}
void showSpecificriverPin(List<Riverpin> riverPins, String riverPinId) {
  for (var riverPin in riverPins) {
    setState(() {
      riverPin.isVisible = riverPin.id == riverPinId; 
    });
  }
}

String searchQuery = '';
String LastSearch = '';

TextEditingController _controller = TextEditingController();
  @override  
  Widget build(BuildContext context) {
    List<Riverpin> filteredriverPins = riverPins.where((riverPin) {
      return riverPin.labelT.toLowerCase().contains(searchQuery.toLowerCase()) ||
          riverPin.labelS.toLowerCase().contains(searchQuery.toLowerCase()) ||
          riverPin.labelE.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Sort by the position of the query (front matches first).
    filteredriverPins.sort((a, b) {
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
                onriverPinsUpdated: (updatedriverPins) {
                  setState(() {
                    riverPins = updatedriverPins;
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
              showAllriverPins(riverPins); 
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
                && !filteredriverPins.isEmpty && isSearchR
                    ?  Center(child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color.fromARGB(255, 19, 21, 24)),
                        
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 300,
                            maxWidth: 300, 
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredriverPins.length,
                            itemBuilder: (context, index) {
                              final riverPin = filteredriverPins[index];
                              return   ListTile(onTap: () {
                                setState(() {
                                  isSearchR = false;
                                  LastSearch = searchQuery;
                                });
       showSpecificriverPin(riverPins,riverPin.id);
      },

      
                                
                                leading: Icon(Icons.location_pin, color: Colors.red,),  
                                title: Text(riverPin.labelE,style: TextStyle(color: Colors.white,fontSize: 16),),
                                subtitle: Text('${riverPin.labelT} | ${riverPin.labelS}',style: TextStyle(color: Colors.white,fontSize: 10),),
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
        for (var riverPin in riverPins) {
          _updateriverPinDimensions(riverPin.key);
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
            Text('riverPin Visibility', style: GoogleFonts.play( 
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
                  onPressed: () {showAllriverPins(riverPins);}, 
                  icon: Icon(Icons.visibility, size: 18, color: Colors.white),
                  label: Text('Show All', style: TextStyle(color: Colors.white, fontSize: 12)),
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 13, 15, 18)),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {hideAllriverPins(riverPins);},
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
      itemCount: riverPins.length,
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
                ((selectedLanguage == "Tamil" ? riverPins[index].labelT: selectedLanguage == "Sinhala" ? riverPins[index].labelS : riverPins[index].labelE)),
                
                style: TextStyle(fontSize: 13.0, color: Colors.white),
              ), 
              IconButton(
                icon: Icon(
                  riverPins[index].isVisible ? Icons.visibility : Icons.visibility_off,
                  color: riverPins[index].isVisible ? Colors.white : Colors.grey,
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
        for (var riverPin in riverPins) {
          _updateriverPinDimensions(riverPin.key);
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
  
  
  Future<void> _updateriverPinVisibilityInFirestore(Riverpin riverPin) async {
    try {
      await FirebaseFirestore.instance.collection('riverPins').doc(riverPin.id).update({'isVisible': riverPin.isVisible});
    } catch (e) {
      print('Error updating riverPin visibility: $e');
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
}

class InteractiveContainer extends StatefulWidget {
  final Function(List<Riverpin>) onriverPinsUpdated;  
  final double screenHeight;
  final double screenWidth;
  final String selectedLanguage;
  InteractiveContainer({required this.onriverPinsUpdated,required this.screenHeight,required this.screenWidth,required this.selectedLanguage});

  @override
  _InteractiveContainerState createState() => _InteractiveContainerState();
}
class _InteractiveContainerState extends State<InteractiveContainer> {
  Offset mousePosition = Offset.zero;
  Offset clickPosition = Offset.zero; // Position of the click
  final GlobalKey containerKey = GlobalKey(); // Key for the container
  List<Riverpin> riverPins = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //remove 
  int tindex = 0; 

  @override
  void initState() {
    super.initState();
    _loadriverPinsFromFirestore();
    
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
         final input = await showLabelInputAndAngleDialog(context);
if (input != null && input['label'] != null && input['label']!.isNotEmpty) {
  final label = input['label']!;
  final angle = int.tryParse(input['angle'] ?? '0') ?? 0; // Safely parse angle
  final isRiver = input['isRiver'] ?? false; // Get isRiver value
  print('Entered Label: $label');
  print('Entered Angle: $angle');
  print('Is River: $isRiver');
  _addriverPin(Offset(px, py), label, 'sinhala$tindex', 'english$tindex', angle, isRiver);
}
 
          
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
                      'assets/river_map.svg', 
                      width: double.infinity,
                      height: double.infinity,
                      fit: isProperRatio ? BoxFit.fitHeight : BoxFit.fitWidth,
                      color: Colors.white,
                    ), 
                    for (var riverPin in riverPins)  
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
                                      ((widget.selectedLanguage == "Tamil" ? riverPin.labelT: widget.selectedLanguage == "Sinhala" ? riverPin.labelS : riverPin.labelE)),
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
                  ], 
                ), 
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  void _addriverPin(Offset position, String labelT,String labelS,String labelE,int angel,bool isRiver) {
    String riverPinId = DateTime.now().millisecondsSinceEpoch.toString();
    GlobalKey riverPinKey = GlobalKey();
    Riverpin newriverPin = Riverpin(
      id: riverPinId,
      key: riverPinKey,
      position: position,
      labelT: labelT,
      labelS: labelS,
      labelE: labelE,
      width: 0.0,
      height: 0.0,
      isVisible: true,
      angel: angel,
      isRiver: isRiver,
      index: 0,
    );

    setState(() {
      riverPins.add(newriverPin);
    });

    widget.onriverPinsUpdated(riverPins);
    _saveriverPinToFirestore(newriverPin);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateriverPinDimensions(riverPinKey);
    });
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
        }/////////////////////////////////////////////////////////////////////////////
      });
    } catch (e) {
      print('Error loading riverPins: $e');
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
}