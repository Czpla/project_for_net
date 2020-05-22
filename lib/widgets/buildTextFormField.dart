import 'package:flutter/material.dart';

class BuildTextFormField extends StatelessWidget {

  final String hint;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController textController;

  BuildTextFormField({this.hint, this.label, this.icon, this.inputType, this.textController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.blueAccent),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: hint,
        labelText: label,
        prefixIcon: Icon (icon, color: Colors.blueAccent,),
      ),
      keyboardType: inputType,
      textAlign: TextAlign.start,
    );
  }
}
