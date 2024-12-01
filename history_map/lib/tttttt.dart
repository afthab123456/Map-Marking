import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', message = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 20,right: 20), 
        height: 320,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xff0f1114),  // Background color for the form
          borderRadius: BorderRadius.circular(8), // Optional: rounded corners
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(79, 18, 44, 36),
              blurRadius: 50,
              offset: Offset(4, 4), // Shadow position
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 500), // Set max width for the form
                child: TextFormField(
                  style: TextStyle(color: Color(0xFFc7e3da)),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 126, 173, 158)), // Match label color to border
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFc7e3da)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF20242a)), // Red color for non-selected border
                    ),
                  ),
                  validator: (value) { 
                    if (value!.isEmpty) return 'Please enter your name';
                    return null;
                  }, 
                  onSaved: (value) => name = value!,
                ),
              ),
              SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: TextFormField(
                    style: TextStyle(color: Color(0xFFc7e3da)), 
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFFc7e3da)), // Match label color to border
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFc7e3da)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF20242a)), // Red color for non-selected border
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                  onSaved: (value) => email = value!,
                ),
              ),
              SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: TextFormField(
                  style: TextStyle(color: Color(0xFFc7e3da)),

                  decoration: InputDecoration(
                    labelText: 'Message',
                    labelStyle: TextStyle(color: Color(0xFFc7e3da)), // Match label color to border
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFc7e3da)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF20242a)), // Red color for non-selected border
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your message';
                    return null;
                  },
                  onSaved: (value) => message = value!,
                  maxLines: 4,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 29, 34, 40),
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                  minimumSize: MediaQuery.of(context).size.width < 500 ? Size(75, 30) : Size(150, 40),
                                ),
              ),
            ], 
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Send data to Firestore
      try {
        await _firestore.collection('contacts').add({
          'name': name,
          'email': email,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message sent!')));
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send message')));
      }
    }
  }
}
