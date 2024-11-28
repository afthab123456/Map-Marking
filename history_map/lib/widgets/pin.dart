import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Pin {
  final String id;
  final GlobalKey key;
  final Offset position;
  String label;
  double width;
  double height;
  bool isVisible;

  Pin({
    required this.id,
    required this.key,
    required this.position,
    required this.label,
    required this.width,
    required this.height,
    this.isVisible = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'position': {'x': position.dx, 'y': position.dy},
      'timestamp': FieldValue.serverTimestamp(),
      'isVisible': isVisible,
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
      isVisible: data['isVisible'] ?? true,
    );
  }
}
 