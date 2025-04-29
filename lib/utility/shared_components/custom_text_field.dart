import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final String? prefixText;
  final prefixIcon;
  final IconButton? suffixIcon;
  final bool isObscure;
  final double? corner;
  final double? fontSize;
  final Color? color;
  final Function(String)? onChange;
  final List<String>? autofillHints;
  final Iterable<String>? autofillHintsIterable;
  final Function()? onTap;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  const CustomTextField(
      {super.key,
        this.controller,
        required this.hintText,
        required this.prefixIcon,
        this.suffixIcon,
        this.keyboardType,
        required this.isObscure,
        this.onChange, this.onTap, this.readOnly, this.corner, this.focusNode, this.color, this.fontSize, this.prefixText, this.autofillHints, this.autofillHintsIterable,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      onChanged: onChange,
      focusNode: focusNode,
      keyboardType: keyboardType ?? TextInputType.text,
      autofillHints: autofillHints ?? autofillHintsIterable,
      onTap: onTap,
      cursorColor: Colors.grey,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(corner ?? 10),
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(corner ?? 10),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(corner ?? 10),
              borderSide: const BorderSide(color: Colors.transparent)),
          fillColor: color ?? Colors.grey.withOpacity(0.08),
          filled: true,
          hintText: hintText,
          prefixText: prefixText,
          prefixStyle: TextStyle(
            fontSize: 16
          ),
          hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize ?? 13, fontWeight: FontWeight.w400),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.only(left: 15, right: 5)
      ),
    );
  }
}
