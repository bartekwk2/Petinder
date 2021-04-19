import 'package:flutter/material.dart';

class CustomCheckbox2 extends StatefulWidget {
  final double size;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final bool isSelected;

  CustomCheckbox2(
      {this.size, this.iconSize, this.selectedColor, this.selectedIconColor,this.isSelected});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox2> {
 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.selectedColor ?? Colors.blue
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  )),
        width: widget.size ?? 30,
        height: widget.size ?? 30,
        child: widget.isSelected
            ? Icon(
                Icons.check,
                color: widget.selectedIconColor ?? Colors.white,
                size: widget.iconSize ?? 20,
              )
            :  Icon(
                Icons.close,
                color: widget.selectedIconColor ?? Colors.white,
                size: widget.iconSize ?? 20,
              ),
      ),
    );
  }

}
