import 'package:flutter/material.dart';

class CustomInputLabelForm extends StatefulWidget {
  String label, hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  bool isPassword;

  CustomInputLabelForm({
    super.key,
    required this.hintText,
    required this.label,
    required this.validator,
    required this.controller,
    required this.isPassword,
  });

  @override
  State<CustomInputLabelForm> createState() => _CustomInputLabelFormState();
}

class _CustomInputLabelFormState extends State<CustomInputLabelForm> {
  // final TextEditingController _inputController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: widget.controller,

            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.transparent),

                // borderSide: BorderSide.none,
              ),
              hintText: widget.hintText,
              errorStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 186, 40, 29),
                letterSpacing: 2,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),

                borderSide: BorderSide(
                  color: Color.fromARGB(255, 187, 39, 29),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),

                borderSide: BorderSide(
                  color: Color.fromARGB(255, 187, 39, 29),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),

                borderSide: BorderSide(color: Colors.transparent, width: 0),
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
                letterSpacing: 0.5,
                fontSize: 18,
              ),
              suffixIcon:
                  widget.isPassword
                      ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      )
                      : null,
            ),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
