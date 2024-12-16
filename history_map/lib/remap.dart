/*import 'package:cloud_firestore/cloud_firestore.dart';
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

class _GridOverlayState extends State<GridOverlay> {
  final List<int> tappedCells = [];
  List<Map<String, dynamic>> labeledCells = [];  // Use this to store labeled cells from Firebase
  bool isLabeling = false;
  String currentLabel = '';

  Offset? dragStart;
  Offset? dragEnd;

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

    if (!tappedCells.contains(tappedCellIndex)) {
      setState(() {
        tappedCells.add(tappedCellIndex);
      });
    }
  }

  void _startLabeling() {
    setState(() {
      isLabeling = true;
    });
  }

  void _endLabeling() async {
    setState(() {
      isLabeling = false;
    });

    if (currentLabel.isNotEmpty) {
      var labeledData = {
        'label': currentLabel,
        'cells': tappedCells,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save data to Firestore
      await FirebaseFirestore.instance.collection('labeledCells').add(labeledData);

      // Clear tapped cells after saving
      setState(() {
        tappedCells.clear();
      });

      // Reload labeled data to update UI
      _loadLabeledData();

      // Print to console
      print('Saved labeled cells to Firebase:');
      for (var label in labeledCells) {
        print('Label: ${label['label']}');
        print('Cells: ${label['cells']}');
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (dragStart == null) {
      dragStart = details.localPosition;
    }

    dragEnd = details.localPosition;

    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (dragStart != null && dragEnd != null) {
      double cellWidth = widget.gridWidth / widget.columns;
      double cellHeight = widget.gridHeight / widget.rows;

      int startX = (dragStart!.dx / cellWidth).floor();
      int startY = (dragStart!.dy / cellHeight).floor();
      int endX = (dragEnd!.dx / cellWidth).floor();
      int endY = (dragEnd!.dy / cellHeight).floor();

      List<int> selectedCells = [];
      for (int row = startY; row <= endY; row++) {
        for (int col = startX; col <= endX; col++) {
          selectedCells.add(row * widget.columns + col);
        }
      }

      setState(() {
        tappedCells.addAll(selectedCells);
      });
    }

    dragStart = null;
    dragEnd = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTapUp: (TapUpDetails details) {
            _handleTap(details.localPosition);
          },
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            size: Size(widget.gridWidth, widget.gridHeight),
            painter: GridPainter(
              widget.rows,
              widget.columns,
              widget.gridWidth,
              widget.gridHeight,
              tappedCells,
              labeledCells,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Column(
            children: [
              Row(children: [
                ElevatedButton(
                  onPressed: _startLabeling,
                  child: Text("Start Labeling"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _endLabeling,
                  child: Text("Save Label"),
                ),
              ]),
              SizedBox(height: 10),
              Container(
                width: 200,
                color: const Color.fromARGB(207, 255, 255, 255),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      currentLabel = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter label for selection',
                    labelText: 'Label',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class GridPainter extends CustomPainter {
  final int rows;
  final int columns;
  final double gridWidth;
  final double gridHeight;
  final List<int> tappedCells;
  final List<Map<String, dynamic>> labeledCells;

  GridPainter(this.rows, this.columns, this.gridWidth, this.gridHeight, this.tappedCells, this.labeledCells);

  @override
  void paint(Canvas canvas, Size size) {
    Paint gridPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    Paint tappedCellPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    Paint labelCellPaint = Paint()
      ..color = Colors.green.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    double cellWidth = gridWidth / columns;
    double cellHeight = gridHeight / rows;

    // Draw grid
    for (int i = 0; i <= rows; i++) {
      double y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(gridWidth, y), gridPaint);
    }

    for (int j = 0; j <= columns; j++) {
      double x = j * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, gridHeight), gridPaint);
    }

    // Highlight tapped cells
    for (int cellIndex in tappedCells) {
      int row = cellIndex ~/ columns;
      int col = cellIndex % columns;
      Rect cellRect = Rect.fromLTWH(
        col * cellWidth,
        row * cellHeight,
        cellWidth,
        cellHeight,
      );
      canvas.drawRect(cellRect, tappedCellPaint);
    }

    // Draw labeled cells
    for (var label in labeledCells) {
      for (int cellIndex in label['cells']) {
        int row = cellIndex ~/ columns;
        int col = cellIndex % columns;
        Rect cellRect = Rect.fromLTWH(
          col * cellWidth,
          row * cellHeight,
          cellWidth,
          cellHeight,
        );
        canvas.drawRect(cellRect, labelCellPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
*/