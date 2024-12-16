import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class GridOverlay extends StatefulWidget {
  final int rows;
  final int columns;
  final double gridWidth;
  final double gridHeight;

  GridOverlay({
    required this.rows,
    required this.columns,
    required this.gridWidth,
    required this.gridHeight,
  });

  @override
  _GridOverlayState createState() => _GridOverlayState();
}
String tappedLabel = '';
class _GridOverlayState extends State<GridOverlay> {
  List<Map<String, dynamic>> labeledCells = [];  // Store labeled cells fetched from Firebase
   

  @override
  void initState() {
    super.initState();
    _loadLabeledData();
  }

  // Fetch labeled data from Firebase
  Future<void> _loadLabeledData() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('labeledCells')
          .get();

      List<Map<String, dynamic>> fetchedLabels = snapshot.docs.map((doc) {
        return {
          'label': doc['label'],
          'cells': List<int>.from(doc['cells']),
        };
      }).toList();

      setState(() {
        labeledCells = fetchedLabels;
      });
    } catch (e) {
      print('Error fetching labeled data: $e');
    }
  }

  void _handleTap(Offset position) {
    double cellWidth = widget.gridWidth / widget.columns;
    double cellHeight = widget.gridHeight / widget.rows;

    int tappedColumn = (position.dx / cellWidth).floor();
    int tappedRow = (position.dy / cellHeight).floor();

    int tappedCellIndex = tappedRow * widget.columns + tappedColumn;

    // Check if tapped cell is labeled
    String label = '0';
    for (var labelData in labeledCells) {
      if (labelData['cells'].contains(tappedCellIndex)) {
        label = labelData['label'];
        break;
      }
    }

    setState(() {
      tappedLabel = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onDoubleTapDown: (TapDownDetails details) {
            _handleTap(details.localPosition); 
          },
          child: CustomPaint(
            size: Size(widget.gridWidth, widget.gridHeight),
            painter: GridPainter(),
          ),
        ),         
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // No grid lines, no highlighted cells
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 
