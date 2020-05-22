import 'package:flutter/material.dart';

class FieldDecoration extends StatelessWidget {

  final String hint;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final Function(String) onChanged;
  final Stream<String> stream;
  final TextEditingController controller;

  FieldDecoration({this.hint, this.label, this.icon, this.onChanged, this.inputType, this.stream, this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          controller: controller,
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
            errorText: snapshot.hasError ? snapshot.error : null,
          ),
          keyboardType: inputType,
          textAlign: TextAlign.start,
        );
      }
    );
  }
}
