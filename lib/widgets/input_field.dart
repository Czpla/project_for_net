import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final String hint;
  final IconData icon;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;
  final TextInputType inputType;

  InputField({this.hint, this.icon, this.obscure, this.stream, this.onChanged, this.inputType});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white,),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            icon: Icon(icon, color: Colors.white,),
            contentPadding: EdgeInsets.only(
              top: 30,
              right: 30,
              bottom: 30,
              left: 5
            ),
            errorText: snapshot.hasError ? snapshot.error : null,
          ),
          style: TextStyle(color: Colors.white),
          obscureText: obscure,
          keyboardType: inputType,
        );
      }
    );
  }
}
