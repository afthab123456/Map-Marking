import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: Color(0xff0f1114), // Footer background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [ 
          // App name
          Text(
            'MapMarker',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width > 500 ? 18.0 : 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('© 2024 Map Marker. All rights reserved.',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width > 500 ? 15 : 8),),
          Text('Version 2.1',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width > 500 ? 15 : 8),)
          // Links section
         /*
          Row( 
            children: [ 
              IconButton(
                onPressed: () {}, // Replace with social media link
                icon: Icon(Icons.facebook, color: Colors.white),
              ),
              IconButton(
                onPressed: () {}, // Replace with social media link
                icon: Icon(Icons.circle, color: Colors.white),
              ),
              IconButton(
                onPressed: () {}, // Replace with social media link
                icon: Icon(Icons.circle, color: Colors.white),
              ),
            ], 
          ),*/
        ],
      ),
    );
  }
}
