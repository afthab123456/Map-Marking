import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Riverpin {
  final String id;
  final GlobalKey key;
  final Offset position;
  String labelT;
  String labelS;
  String labelE;
  double width;
  double height;
  bool isVisible;
  bool isRiver;
  int angel;
  int index;

  Riverpin({
    required this.id,
    required this.key,
    required this.position,
    required this.labelT,
    required this.labelS,
    required this.labelE,
    required this.width,
    required this.height,
    this.isVisible = true,
    required this.isRiver,
    required this.angel,
    required this.index,
  });

  Map<String, dynamic> toMap() {
    return {
      'labelT': labelT,
      'labelS': labelS,
      'labelE': labelE,
      'position': {'x': position.dx, 'y': position.dy},
      'timestamp': FieldValue.serverTimestamp(),
      'isVisible': isVisible,
      'isRiver' : isRiver,
      'angel' : angel,
      'index' : index
    };
  }

  factory Riverpin.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Riverpin(
      id: doc.id,
      key: GlobalKey(),
      position: Offset(
        data['position']['x']?.toDouble() ?? 0.0,
        data['position']['y']?.toDouble() ?? 0.0,
      ),
      labelT: data['labelT'] ?? '',
      labelS: data['labelS'] ?? '',
      labelE: data['labelE'] ?? '',
      width: 0.0,
      height: 0.0,
      isVisible: data['isVisible'] ?? true,
      isRiver: data['isRiver'] ?? true,
      angel: data['angel'] ?? 0,
      index: data['index'] ?? 0,
    );
  }
}
 