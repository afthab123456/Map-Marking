import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history_map/game.dart';
import 'package:history_map/viewer.dart';
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

class MyApp extends StatelessWidget {
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
class MainPage extends StatelessWidget {
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
                      Expanded(
                        child: Container(color: screenWidth > 500 ? Color(0xFF2b3038) :Color(0xFF20242a)),
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
                          color: screenWidth > 500 ? Color(0xFF272c34) : const Color.fromARGB(255, 30, 53, 55),
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
                  
                  if (screenWidth < 1000)
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
                                  color: Color(0xff20242a),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft: Radius.circular(25))
                                ),
                                alignment: Alignment.center,
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
           Container(height: screenHeight,width: screenWidth,child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
               Text('this page is just a test one, this is not how the actuall website will look',textAlign: TextAlign.center,),
               
              SizedBox(height: 20,), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('View Map'),
                SizedBox(width: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewerApp()),
            );
                }, child: Text('View Map'))
              ],),
              SizedBox(height: 20,), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Play Game'),                
                SizedBox(width: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameApp()),
            );
                }, child: Text('Play Game'))
              ],)
            ],
           ),)
          ],
        ),
      ),
    );
  }
}
