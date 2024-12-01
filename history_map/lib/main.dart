import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:MapMarking/footer.dart';
import 'package:MapMarking/game.dart';
import 'package:MapMarking/test.dart';
import 'package:MapMarking/contactform.dart';
import 'package:MapMarking/underdev.dart';
import 'package:MapMarking/viewer.dart';
import 'package:MapMarking/visitor_count.dart';
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
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
   
   return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(color: Color(0xFF20242a)),
                      ),
                      
                    ],
                  ),
                  Positioned(
                    left: screenWidth > 500 ? screenWidth / 2 : 0,
                    top: 30,
                    child: Text(
                      'Map\nMarking'.toUpperCase(),
                      style: GoogleFonts.archivoBlack(
                        textStyle: TextStyle(
                          color: screenWidth > 500 ? Color.fromARGB(255, 38, 44, 51) : const Color.fromARGB(255, 30, 53, 55),
                          fontSize: screenWidth > 500 ? 100 : 80, 
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      "assets/landing_map.png",
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  if (screenWidth > 500)
                  Positioned(
                    top: -180,
                    right: -180, 
                    child: Image.asset('assets/green_circle.png',height: 380,),
                  ),
                  
                  
                  Container(width: screenWidth,height: screenHeight,color: const Color.fromARGB(165, 0, 0, 0),),
                  if (screenWidth > 500) 
                  Positioned(
                    top: 50,
                    left: screenWidth > 500 ? 50 : 30,
                    child: Icon(Icons.location_pin, size: 50, color: Color.fromARGB(255, 204, 20, 20)),
                  ),
                  
                  if (screenWidth < 500)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_pin, size: 50, color: Color.fromARGB(255, 204, 20, 20)),
                          Text(
                            'Map\nMarking'.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(                               
                              textStyle: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFc7e3da),
                                fontStyle: FontStyle.italic,
                                height: 1.2,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:() { 
                              _launchURL;
                            },
                            child: Container(
                              width:  250,
                              height: 40,     
                              margin: EdgeInsets.only(top: 20),                        
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(204, 18, 44, 36),
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Text('Developed by @Afthab Ahamed'.toUpperCase(),style:TextStyle(fontSize: 13,color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ), 
                   
                  if (screenWidth > 500)
                  Positioned(
                    top: 100,
                    left:  60, 
                    child: Text(
                      'Map\nMarking'.toUpperCase(),
                      style: GoogleFonts.poppins( 
                        textStyle: TextStyle(
                          fontSize: screenWidth > 500 ? 55 : 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFc7e3da),
                          fontStyle: FontStyle.italic,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  if (screenWidth > 500)
                  Positioned( 
                    bottom: 180,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              Container( 
                                width: screenWidth > 1000 ? 200 : 150,
                                height: screenWidth > 1000 ? 130 : 100,                               
                                decoration: BoxDecoration(
                                  color: Color(0xff2b3038),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25))
                                ),
                                alignment: Alignment.center,
                              ),
                              Container(
                                width:  screenWidth > 1000 ? 200 : 150,
                                height: screenWidth > 1000 ? 130 : 100, 
                                
                                decoration: BoxDecoration(
                                                        color: const Color.fromARGB(165, 0, 0, 0),
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25))
                                                      ),
                              ),
                              Positioned(
                                right: screenWidth > 1000 ? -100 : -50,
                                child: Text(
                                  'making your\nol exams easy'.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: screenWidth > 1000 ? 25 : 18, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: screenWidth > 1000 ? 280 : 180,
                                height: screenWidth > 1000 ? 130 : 100,                                
                                decoration: BoxDecoration(
                                  color: Color(0xff2b3038),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft: Radius.circular(25))
                                ),
                                alignment: Alignment.center,
                              ),
                              Container(
                                width:  screenWidth > 1000 ? 280 : 180,
                                height: screenWidth > 1000 ? 130 : 100,  
                                
                                decoration: BoxDecoration(
                                                        color: const Color.fromARGB(165, 0, 0, 0),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft: Radius.circular(25))
                                                      ),   
                              ),
                              Positioned(
                                left: screenWidth > 1000 ? -80 : -40, 
                                child: Text(
                                  'Start Your\nLearning Journey'.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: screenWidth > 1000 ? 25 : 18, color: Colors.white)),
                                ),
                              ),
                              Positioned(
                                right: screenWidth > 1000 ? 30 : 15, 
                                child: Icon(Icons.arrow_downward_rounded,color: Color(0xff38876f),size: screenWidth > 1000 ? 50 : 25,)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (screenWidth > 500)
                  Positioned(
                    bottom: 50,
                    child:  Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width:  200,
                                height: 40,                             
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xff38876f),
                                  borderRadius: BorderRadius.only(topRight:Radius.circular(25),bottomRight: Radius.circular(25))
                                ),
                              ),
                              Positioned(
                                 right: 1,
                                child: Text(
                                  'Developed by  '.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15, color: Colors.white)),
                                ),
                              ),
                              Positioned(
                                left: 205,
                                child:  Text('@Afthab Ahamed',style:TextStyle(fontSize: 16,color: Colors.white),)
                              ),   
                             
                            ],
                          ),
                         ),
                         Positioned(
                          bottom: 50,
                          child: GestureDetector(onTap: () {
                           print('object');
                         }, child: Container(width: 350,height: 40,color: const Color.fromARGB(0, 255, 255, 255),),))
                        
                                                
                ],
              ), 
            ),
           
         
           
            Container(
  color: Color(0xFF20242a),
  width: screenWidth,
  height: screenHeight,  // Make sure the container takes up full height if needed
  child: Stack(
    children: [
      Positioned(
        top: -60,
        right: -60,
        child: Image.asset("assets/dots.png"), 
        width:  200,
      ),
      Positioned(
        bottom: -60,
        left: -60,
        child: Image.asset("assets/dots.png"), 
        width: 200,
      ),
      
        Container(
          width: screenWidth,
          height: screenHeight, 
          color: const Color.fromARGB(165, 0, 0, 0),
        ),
      Container(
        padding: EdgeInsets.all(30),
        child: 
        Center(  // Use Center to align the Column horizontally and vertically
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centers vertically
          crossAxisAlignment: CrossAxisAlignment.center,  // Centers horizontally
          children: [
            SizedBox(height: 40),
            Text(
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
            SizedBox(height: 16),
            Container(
              width: 800,
              child: Text(                
                "MapMarking is an innovative platform designed to help GCE Ordinary Level students excel in map marking. Recognizing the lack of resources in this area of the history syllabus, we've created a fun, interactive space where students can explore marked maps and learn through engaging games. Our platform transforms map marking into a game-like experience, making studying both enjoyable and effective. Whether you're preparing for exams or just practicing, our site makes learning history more interactive and exciting.", 
                style: TextStyle(
                  fontSize: screenWidth > 500 ? 16 : 13,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
              Container(
          height: 4,
          width: screenWidth > 500 ? 200 : 80, 
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 38, 91, 75), 
            borderRadius: BorderRadius.circular(20)
          ),// Line color
        ), // Space between line and dot
        SizedBox(width: 10,), 
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 38, 91, 75), // Dot color
            shape: BoxShape.circle,
          ),
        ), 
            ],), 
            SizedBox(height: 15), 
          ],
        ),
      ),
      
      )],
  ),
), 
           Container(
  color: Color(0xFF20242a),
  width: screenWidth,
  height: screenHeight,  // Make sure the container takes up full height if needed
  child: Stack(
    children: [
      Positioned(
        top: 0, 
        right: 0, 
        child: Image.asset("assets/dot_map.png",height: screenWidth > 500 ? screenHeight: screenWidth *2  ,),   
         
      ),
      
      
        Container(
          width: screenWidth,
          height: screenHeight, 
          color: const Color.fromARGB(165, 0, 0, 0),
        ),
      Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        Container(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
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
              textAlign: TextAlign.left, 
              
            ), 
            SizedBox(height: 20,), 
            Container(
              width: 800,
              child: Text(
                "Dive into the heart of the Sri Lanka map! This section highlights key locations and landmarks that are essential for the GCE Ordinary Level history syllabus. Use our interactive map to practice marking important sites and test your knowledge through fun games. Whether you’re revising or just getting started, this tool is designed to help you master Sri Lanka’s map with ease.",
                style: TextStyle(
                  fontSize: screenWidth > 500 ? 16 : 13,
                  color: Colors.white70, 
                ),
                textAlign: TextAlign.left, 
              ),
            ),
            SizedBox(height: 20,), 
             Row(children: [
              ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewerApp()),
            );
              },
               
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 38, 91, 75),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: screenWidth < 500 ? Size(75, 30) : Size(150, 40),
              ), 
              child: Text(
                "View Map",
                style: TextStyle(fontSize: screenWidth < 500 ? 12 : 16),
              ),
            ),
            SizedBox(width: 15,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameOptionsPage()), 
            );
              },
              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                  minimumSize: screenWidth < 500 ? Size(75, 30) : Size(150, 40),
                                ),
              child: Text(
                "Play Game",
                style: TextStyle(fontSize: screenWidth < 500 ? 12 : 16),
              ),
            ),
             ],)
             ],),
        ),
        
      ],)
      
       ],
  ),
), 
           Container(
  color: Color(0xFF20242a),
  width: screenWidth,
  height: screenHeight,  // Make sure the container takes up full height if needed
  child: Stack(
    children: [
      Positioned(
        top: 0, 
        left: 0, 
        child: Image.asset("assets/dot_mapW.png",height: screenHeight ,),   
         
      ), 
      
      
        /*Container(
          width: screenWidth,
          height: screenHeight, 
          color: const Color.fromARGB(165, 0, 0, 0),
        ),*/  
     Center(
        child:Container(
          child: 
           Row(
          mainAxisAlignment: screenWidth > 900 ? MainAxisAlignment.end:MainAxisAlignment.start,  
          children: [
          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        Container(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
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
              textAlign: TextAlign.left, 
              
            ), 
            SizedBox(height: 20,), 
            Container(
              width: screenWidth > 900 ? 800 : screenWidth-100,  
              child: Text(
                "Journey through the world map! This section focuses on key countries, regions, and historical landmarks crucial for the GCE Ordinary Level history syllabus. Use our interactive map to practice marking important locations and challenge yourself with fun games. Whether you're revising or learning something new, this tool is designed to help you master world geography with ease.", 
                style: TextStyle(
                  fontSize: screenWidth > 500 ? 16 : 13,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.left, 
                
              ),
            ),
            SizedBox(height: 20,), 
             Row(children: [
              ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewerApp()),
            );
              },
               
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 38, 91, 75),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: screenWidth < 500 ? Size(75, 30) : Size(150, 40),
              ), 
              child: Text(
                "View Map",
                style: TextStyle(fontSize: screenWidth < 500 ? 12 : 16),
              ),
            ),
            SizedBox(width: 15,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameOptionsPage()), 
            );
              },
              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                  minimumSize: screenWidth < 500 ? Size(75, 30) : Size(150, 40),
                                ),
              child: Text(
                "Play Game",
                style: TextStyle(fontSize: screenWidth < 500 ? 12 : 16),
              ),
            ),
             ],)
             ],),
        ),
        
      ],)
      
        
        ],),
        )) ,
        Container(
          width: screenWidth,
          height: screenHeight, 
          color: const Color.fromARGB(165, 0, 0, 0),
        ),
        UnderDevelopmentWidget(), 
        ],
  
  ),
), Container(
  width: screenWidth,
  height: screenHeight,
  color: Color(0xFF20242a),
  child:Stack(
    children: [
      Positioned(
        bottom: 0,
        left: 0, 
        child: Image.asset("assets/dot_wave.png",),  
        width: screenWidth > 500 ? screenWidth : screenHeight,  
      ),
      
      Container(
          width: screenWidth,
          height: screenHeight, 
          color: const Color.fromARGB(165, 0, 0, 0),
        ),
      Center(child:  Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Text(
              'Page Visits', 
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: screenWidth > 500 ? 35 : 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFc7e3da),
                  fontStyle: FontStyle.italic,
                  height: 1.2,
                ),
              ),
              textAlign: TextAlign.left, 
              
            ), 
           
          VisitorCounterWidget(screenWidth: screenWidth,),],
      ))
    ],
  ) ),
  Container(
  width: screenWidth, 
  height: 600,  
  color: Color(0xFF20242a),
  child:Stack(
    children: [ 
      
      Container(
          width: screenWidth,
          height: 600,  
          color: const Color.fromARGB(165, 0, 0, 0),
        ),
        Column(children: [
          SizedBox(height: 20,), 
          Text(
              'Contact Us', 
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
            SizedBox(height: 20,),  
          ContactForm(), 
          SizedBox(height: 20,),  
        ],)
    ])) ,
    Container(
  width: screenWidth,
  height: screenWidth > 500 ? 60 : 50, 
  color: Color(0xFF20242a),
  child:Stack(
    children: [ 
      
      Container(
          width: screenWidth,
          height: screenWidth > 500 ? 60 : 50,  
          color: const Color.fromARGB(165, 0, 0, 0),
        ),
       Footer()
    ])) 
            
          ],
        ),
      ),
    ); 
  }
  
} 
