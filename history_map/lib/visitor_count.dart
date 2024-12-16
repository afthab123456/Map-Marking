import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 bool _hasIncremented = true; //keep this true for testing so it does not update and remove before the main release
class VisitorCounterWidget extends StatefulWidget {
  final double screenWidth;
 
  const VisitorCounterWidget({Key? key,required this.screenWidth}) : super(key: key);

  @override 
  _VisitorCounterWidgetState createState() => _VisitorCounterWidgetState();
}

class _VisitorCounterWidgetState extends State<VisitorCounterWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _visitorStream;
  int _visitorCount = 0;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _visitorStream = _firestore.collection('counters').doc('visitorCount').snapshots();
    _incrementVisitorCountOnce(); // Ensure count is incremented only once
  }

  Future<void> _incrementVisitorCountOnce() async {
    if (_hasIncremented) return; // Prevent multiple increments

    final DocumentReference counterRef = _firestore.collection('counters').doc('visitorCount');

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(counterRef);
        int newCount = 1;

        if (snapshot.exists) {
          newCount = snapshot['count'] + 1;
        }

        transaction.set(counterRef, {'count': newCount});
      });

     setState(() {
        _hasIncremented = true; // Mark as incremented 
     });
    } catch (e) {
      print('Error incrementing visitor count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _visitorStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.data?.exists ?? false) {
          _visitorCount = snapshot.data!.data()?['count'] ?? 0;
        }

        String formattedCount = _visitorCount.toString().padLeft(6, '0');
        String previousFormattedCount = _previousCount.toString().padLeft(6, '0');

        List<Widget> digitContainers = [];
        for (int i = 0; i < formattedCount.length; i++) {
          digitContainers.add(_buildDigitContainer(previousFormattedCount[i], formattedCount[i]));
        }

        if (_visitorCount != _previousCount) {
          _previousCount = _visitorCount;
        }

        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 68, 137, 255),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: digitContainers,
          ),
        );
      },
    );
  }

  Widget _buildDigitContainer(String oldDigit, String newDigit) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: oldDigit == newDigit
          ? Container(
              key: ValueKey(newDigit),
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: widget.screenWidth > 500
                  ? EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                  : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(206, 8, 10, 11),
                borderRadius: BorderRadius.circular(8),
                //border: Border.all(color: Color(0xFFc7e3da), width: 2),
              ),
              child: Text(
                newDigit,
                style: TextStyle(
                  fontSize: widget.screenWidth > 500 ? 40 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            )
          : Container(
              key: ValueKey(newDigit),
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: widget.screenWidth > 500
                  ? EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                  : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(206, 8, 10, 11),
                borderRadius: BorderRadius.circular(8),
                //border: Border.all(color: Color(0xFFc7e3da), width: 2),
              ),
              child: Text( 
                newDigit,
                style: TextStyle(
                  fontSize: widget.screenWidth > 500 ? 40 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
    );
  }
}
