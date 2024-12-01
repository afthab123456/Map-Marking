import 'package:flutter/material.dart';


class UnderDevelopmentWidget extends StatefulWidget {
  const UnderDevelopmentWidget({Key? key}) : super(key: key);

  @override
  _UnderDevelopmentWidgetState createState() =>
      _UnderDevelopmentWidgetState();
}

class _UnderDevelopmentWidgetState extends State<UnderDevelopmentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Icon(
            Icons.construction_rounded, 
            color: Color.fromARGB(255, 138, 151, 166),  
            size: 100,
        ),
      ),
    );
  }
}

