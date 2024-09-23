import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? align;

  const CustomText(
      {Key? key,
      required this.text,
      this.size,
      this.color,
      this.weight,
      this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: align ?? TextAlign.center,
      text,
      style: TextStyle(
          fontSize: size ?? 14,
          color: color ?? Colors.white,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}
