import 'package:flutter/material.dart';

class RounedFlatButton extends StatelessWidget {
  
  final Function onPress;
  final Widget child;
  final Color color;
  final double height;
  final double borderRadius;

  RounedFlatButton(
      {this.onPress, this.child, this.color, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(borderRadius)),
      height: height,
      child: FlatButton(
        onPressed: onPress,
        child: child,
      ),
    );
  }
}
