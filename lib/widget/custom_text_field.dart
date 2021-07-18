import 'package:flutter/material.dart';
import 'package:teach2educate/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key, required this.controller, required this.hintText})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      margin: EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 2, color: Colors.indigo.shade800)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo.shade800)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kNavy.withOpacity(0.6),
            ),
          ),
        ),
        validator: (s) {
          if (s == null) {
            return "This field can't be empty";
          } else {
            if (s.isEmpty) {
              return "This field can't be empty";
            }
          }
          return null;
        },
      ),
    );
  }
}
