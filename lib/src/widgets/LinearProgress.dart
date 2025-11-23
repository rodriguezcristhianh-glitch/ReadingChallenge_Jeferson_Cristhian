import 'package:flutter/material.dart';

class LinearProgres extends StatelessWidget 
{
  final double value;
  final double min;
  final Color backgroundColor;
  final Color color;
  final double width;
  final int heightBar;

  const LinearProgres
  ({
    super.key, required this.value, required this.min, 
    this.backgroundColor = Colors.grey, 
    this.color = Colors.blue, this.width = 110, this.heightBar = 1
  });

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox(
      width: width,
      child:
      LinearProgressIndicator
      (
        value: value,
        minHeight: min,
        backgroundColor: backgroundColor,
        color: color,
      )
    );
  }
}