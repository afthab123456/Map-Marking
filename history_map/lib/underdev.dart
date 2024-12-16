import 'package:flutter/material.dart';

class UnderDevelopmentWidget extends StatelessWidget {
  const UnderDevelopmentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.construction_rounded,
        color: Color.fromARGB(255, 138, 151, 166),
        size: 100,
      ),
    );
  }
}
