import 'package:MapMarking/contactform.dart';
import 'package:MapMarking/visitor_count.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  runApp(MyApp());
}
 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff0b0d0f), 
        body: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLineVisible = false;  
  bool isAboutVisible = false;
  bool isContainer1Visible = false;
  bool isContainer1TextVisible = false; 
  bool isContainer2Visible = false;
  bool isContainer2TextVisible = false;
  bool isContainer3Visible = false;
  bool isContainer3TextVisible = false; 
  bool isVisitVisible = false;
  bool isContactVisible = false;
  bool isFooterVisible = false;
  bool isFooterTextVisible = false;
  bool isConstruction = false; 
  final ScrollController _scrollController = ScrollController();
  @override
  void initState()  {
      super.initState();
      
      _scrollController.addListener(() async {    
        if ((_scrollController.offset > (MediaQuery.of(context).size.height) - 200) && !isLineVisible) {
          setState(() {
            isAboutVisible = true;
          }); 
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            isLineVisible = true;
          });
        }
        if ((_scrollController.offset > (MediaQuery.of(context).size.height * 1.5 )) && !isContainer1Visible) {
          setState(() {
            isContainer1Visible = true;
          }); 
          await Future.delayed(Duration(milliseconds: 800));
          setState(() {
            isContainer1TextVisible = true;
          });
        }
        if ((_scrollController.offset > (MediaQuery.of(context).size.height * 2.4 )) && !isContainer2Visible) {
          setState(() {
            isContainer2Visible = true;
          });
          await Future.delayed(Duration(milliseconds: 800)); 
          setState(() {
            isContainer2TextVisible = true;
          });
        }
        if ((_scrollController.offset > (MediaQuery.of(context).size.height * 3.2 )) && !isContainer3Visible) {
          setState(() {
            isContainer3Visible = true;
          }); 
          await Future.delayed(Duration(milliseconds: 800)); 
          setState(() {
            isContainer3TextVisible = true;
          });
        }
        if ((_scrollController.offset > (MediaQuery.of(context).size.height * 4.8)) && !isVisitVisible) {
          setState(() { 
            isVisitVisible = true;
          });       
        }
        if ((_scrollController.offset > (MediaQuery.of(context).size.height * 5.8)) && !isContactVisible) {
          setState(() {
            isContactVisible = true; 
          });       
        }
        if ((_scrollController.offset > (MediaQuery.of(context).size.height * 6.3)) && !isFooterVisible) {
            setState(() {
              isFooterVisible = true;
            }
          );       
        }
      }
    );
  }

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Container(
            height: screenHeight * 2,
            width: screenWidth,
            child: Stack(
              children: [                
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_pin,color: Colors.red,size: screenWidth > 700 ? 80 : 50,), 
                      Padding(padding: EdgeInsets.all(20),child:  Text(
                            'Map Marking'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(                               
                              textStyle: TextStyle(
                                fontSize:screenWidth > 700 ? 80 : 50,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFc7e3da),
                                height: 1.2,
                              ),
                            ), 
                          ),),
                      TextButton(
                        style: TextButton.styleFrom(
                        side: BorderSide(color: Color(0xFFc7e3da)),
                        padding: EdgeInsets.symmetric(vertical:screenWidth > 700 ? 12 : 0, horizontal:screenWidth > 700 ? 24 : 14), // Adjust padding as needed
                        foregroundColor: Colors.white,
                        overlayColor: Colors.transparent,), 
                        onPressed: () {},  
                        child:  Text(
                          'Developed by @ Afthab Ahamed'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(                               
                            textStyle: TextStyle( 
                              fontSize:screenWidth > 700 ? 12 : 10, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFc7e3da),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ) 
                    ],
                  ),
                ), 
                Positioned(
                  top: screenHeight,
                  child:Container(
                    height: screenHeight,
                    width: screenWidth,
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, 
                          children: [
                            SizedBox(height: 40),
                            AnimatedOpacity(
                              opacity: isAboutVisible ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              child: Text(
                                'About This Website',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: screenWidth > 500 ? 35 : 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFc7e3da),
                                    fontStyle: FontStyle.italic,
                                    height: 1.2,                  
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ), 
                            ), 
                            SizedBox(height: 16),
                            AnimatedOpacity(
                              opacity: isAboutVisible ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              child: Container(
                                width: 800,
                                child: Text(                
                                  "MapMarking is an innovative platform designed to help GCE Ordinary Level students excel in MapMarking. Recognizing the lack of resources in this area of the history syllabus, we've created a fun, interactive space where students can explore marked maps and learn through engaging games. Our platform transforms MapMarking into a game-like experience, making studying both enjoyable and effective. Whether you're preparing for exams or just practicing, our site makes learning history more interactive and exciting.", 
                                  style: TextStyle(
                                    fontSize: screenWidth > 500 ? 16 : 13,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(height: 20), 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [               
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  height: isLineVisible ? 4 : 0,
                                  width: isLineVisible ? (screenWidth > 500 ? 200 : 80) : 0,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 38, 91, 75),
                                    borderRadius: BorderRadius.circular(20), 
                                  ),
                                ), 
                                SizedBox(width: 10,), 
                                AnimatedOpacity(
                                  opacity: isLineVisible ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  child: Container(
                                    width: 4,
                                    height: 4, 
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 38, 91, 75),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              ],
                            ), 
                            SizedBox(height: 15), 
                          ],
                        ),
                      ),      
                    ),
                  ),
                ),
                Positioned(
                  top: -80,  
                  left: -80,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width:screenWidth > 600 ? 200 : 100,
                    height: screenWidth > 600 ? 200 : 100,
                    decoration: BoxDecoration( 
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:  Color(0xff265b4b).withOpacity(0.9),
                          blurRadius: 400,
                          spreadRadius: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight - 200,
                  right: -100,
                  child: Container(
                    width: screenWidth > 600 ? 200 : 100,
                    height: screenWidth > 600 ? 200 : 100,
                    decoration: BoxDecoration(  
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff265b4b).withOpacity(0.9),
                          blurRadius: 400,
                          spreadRadius: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight,
            width: screenWidth, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [              
                Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: isContainer1TextVisible ? 1.0 : 0.0, // Fully visible or fully transparent
                        duration: Duration(milliseconds: 300), // Animation duration
                        curve: Curves.easeInOut, // Animation curve
                        child: 
                        Container(
                          width: screenWidth * .9,
                          height: screenHeight*.65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/dot_mapSL.png',
                              fit: BoxFit.fitHeight,
                            ),
                          )
                       ), 
                      ), 
                    ),  
                    AnimatedContainer( 
                      duration: Duration(milliseconds: 800),
                      curve: Curves.ease,  
                      width:isContainer1Visible ? screenWidth * .9 : 0,
                      height: screenHeight * .8,
                      decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight:Radius.circular(20), topRight: Radius.circular(20)),color: Color.fromARGB(206, 8, 10, 11),), 
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [  
                          Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.center,  
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: screenWidth * .9,
                                        height: screenHeight * .8,
                                        padding: EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            AnimatedOpacity(
                                              opacity: isContainer1TextVisible ? 1.0 : 0.0, // Fully visible or fully transparent
                                              duration: Duration(milliseconds: 300), // Animation duration
                                              curve: Curves.easeInOut, // Animation curve
                                              child: Container(
                                                padding: EdgeInsets.all(50),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Map of Sri Lanka',
                                                      style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          fontSize: screenWidth > 500 ? 35 : 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFFc7e3da),
                                                          fontStyle: FontStyle.italic,
                                                          height: 1.2,
                                                        ),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    SizedBox(height: 20),
                                                    Container(
                                                      width: 800,
                                                      child: Text(
                                                        "Dive into the heart of the Sri Lanka map! This section highlights key locations and landmarks that are essential for the GCE Ordinary Level history syllabus. Use our interactive map to practice marking important sites and test your knowledge through fun games. Whether you’re revising or just getting started, this tool is designed to help you master Sri Lanka’s map with ease.",
                                                        style: TextStyle(
                                                          fontSize: screenWidth > 500 ? 16 : 13,
                                                          color: Colors.white70,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    screenWidth > 500
                                                        ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Navigate to ViewerApp
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Color.fromARGB(255, 38, 91, 75),
                                                                  foregroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  minimumSize: Size(150, 40),
                                                                ),
                                                                child: Text(
                                                                  "View Map",
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                              ),
                                                              SizedBox(width: 15),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Navigate to GameOptionsPage
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                                                  foregroundColor: Colors.white,
                                                                  shadowColor: Colors.black,
                                                                  minimumSize: Size(150, 40),
                                                                ),
                                                                child: Text(
                                                                  "Play Game",
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Navigate to ViewerApp
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Color.fromARGB(255, 38, 91, 75),
                                                                  foregroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  minimumSize: Size(55, 30),
                                                                ),
                                                                child: Text(
                                                                  "View Map",
                                                                  style: TextStyle(fontSize: 14),
                                                                ),
                                                              ),
                                                              SizedBox(height: 15),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Navigate to GameOptionsPage
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                                                  foregroundColor: Colors.white,
                                                                  shadowColor: Colors.black,
                                                                  minimumSize: Size(55, 30),
                                                                ),
                                                                child: Text(
                                                                  "Play Game",
                                                                  style: TextStyle(fontSize: 14),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),          
          ),          
          Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: isContainer2TextVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Positioned(
                        bottom: 0,
                        child: Container(
                          width: screenWidth * .5,
                          height: screenHeight * .8,
                          child: Image.asset('assets/dot_mapR.png', fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.ease,
                      width: screenWidth * .9,
                      height: isContainer2Visible ? screenHeight * .8 : 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                        color: Color.fromARGB(206, 8, 10, 11),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AnimatedOpacity(
                                        opacity: isContainer2TextVisible ? 1.0 : 0.0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        child: Container(
                                          width: screenWidth * .9,
                                          height: screenHeight * .8,
                                          padding: EdgeInsets.all(0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Water Bodies of Srilanka',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: screenWidth > 500 ? 35 : 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFc7e3da),
                                                    fontStyle: FontStyle.italic,
                                                    height: 1.2,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                width: screenWidth > 900 ? 800 : screenWidth - 100,
                                                child: Text(
                                                  "This section highlights the important waterbodies of Sri Lanka, essential for the GCE Ordinary Level history syllabus. Explore our interactive map to identify and mark lakes, reservoirs, and other key waterbodies while testing your knowledge through fun and engaging games. Whether revising or beginning anew, this tool is here to help you navigate Sri Lanka's aquatic geography with ease!",
                                                  style: TextStyle(
                                                    fontSize: screenWidth > 500 ? 16 : 13,
                                                    color: Colors.white70,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              screenWidth > 500
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            // Navigate to ViewerApp
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Color.fromARGB(255, 38, 91, 75),
                                                            foregroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            minimumSize: Size(150, 40),
                                                          ),
                                                          child: Text(
                                                            "View Map",
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                        SizedBox(width: 15),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            // Navigate to GameOptionsPage
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                                            foregroundColor: Colors.white,
                                                            shadowColor: Colors.black,
                                                            minimumSize: Size(150, 40),
                                                          ),
                                                          child: Text(
                                                            "Play Game",
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            // Navigate to ViewerApp
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Color.fromARGB(255, 38, 91, 75),
                                                            foregroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            minimumSize: Size(55, 30),
                                                          ),
                                                          child: Text(
                                                            "View Map",
                                                            style: TextStyle(fontSize: 14),
                                                          ),
                                                        ),
                                                        SizedBox(height: 15),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            // Navigate to GameOptionsPage
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                                            foregroundColor: Colors.white,
                                                            shadowColor: Colors.black,
                                                            minimumSize: Size(55, 30),
                                                          ),
                                                          child: Text(
                                                            "Play Game",
                                                            style: TextStyle(fontSize: 14),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: isContainer3TextVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: screenWidth * .9,
                        height: screenHeight * .8,
                        child: Image.asset(
                          'assets/dot_mapWl.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.ease,
                      width: isContainer3Visible ? screenWidth * .9 : 0,
                      height: screenHeight * .8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: screenWidth * .9,
                                        height: screenHeight * .8,
                                        padding: EdgeInsets.all(0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            AnimatedOpacity(
                                              opacity: isContainer3TextVisible ? 1.0 : 0.0,
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              child: Container(
                                                padding: EdgeInsets.all(50),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Map of the World',
                                                      style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          fontSize: screenWidth > 500 ? 35 : 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFFc7e3da),
                                                          fontStyle: FontStyle.italic,
                                                          height: 1.2,
                                                        ),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    SizedBox(height: 20),
                                                    Container(
                                                      width: 800,
                                                      child: Text(
                                                        "Journey through the world map! This section focuses on key countries, regions, and historical landmarks crucial for the GCE Ordinary Level history syllabus. Use our interactive map to practice marking important locations and challenge yourself with fun games. Whether you're revising or learning something new, this tool is designed to help you master world geography with ease.",
                                                        style: TextStyle(
                                                          fontSize: screenWidth > 500 ? 16 : 13,
                                                          color: Colors.white70,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    screenWidth > 500
                                                        ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {},
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Color.fromARGB(255, 38, 91, 75),
                                                                  foregroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(20),
                                                                  ),
                                                                  minimumSize: Size(150, 40),
                                                                ),
                                                                child: Text(
                                                                  "View Map",
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                              ),
                                                              SizedBox(width: 15),
                                                              ElevatedButton(
                                                                onPressed: () {},
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Color.fromARGB(255, 29, 34, 40),
                                                                  foregroundColor: Colors.white,
                                                                  shadowColor: Colors.black,
                                                                  minimumSize: Size(150, 40),
                                                                ),
                                                                child: Text(
                                                                  "Play Game",
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {},
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Color.fromARGB(255, 38, 91, 75),
                                                                  foregroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(20),
                                                                  ),
                                                                  minimumSize: Size(55, 30),
                                                                ),
                                                                child: Text(
                                                                  "View Map",
                                                                  style: TextStyle(fontSize: 14),
                                                                ),
                                                              ),
                                                              SizedBox(height: 15),
                                                              ElevatedButton(
                                                                onPressed: () {},
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Color.fromARGB(255, 29, 34, 40),
                                                                  foregroundColor: Colors.white,
                                                                  shadowColor: Colors.black,
                                                                  minimumSize: Size(55, 30),
                                                                ),
                                                                child: Text(
                                                                  "Play Game",
                                                                  style: TextStyle(fontSize: 14),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.ease,
                      height: screenHeight,
                      width: isContainer3Visible ? screenWidth * .9 : 0,
                      onEnd: () {
                        setState(() {
                          isConstruction = true;
                        });
                      },
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Color.fromARGB(206, 8, 10, 11),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: isConstruction ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: screenWidth * .9,
                        height: screenHeight * .8,
                        child: Center(
                          child: Icon(
                            Icons.construction_rounded,
                            size: 100,
                            color: Color(0xFFc7e3da),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]
      ), 
    );
  }
}
