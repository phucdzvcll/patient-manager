import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.hint,
    required this.label,
    this.errorMess,
    required this.prefixIcon,
    required this.controller,
    this.enable = true,
    this.isRequire = false,
  }) : super(key: key);
  final String hint;
  final String label;
  final String? errorMess;
  final Widget prefixIcon;
  final bool isRequire;
  final TextEditingController controller;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.black),
            ),
            const SizedBox(
              width: 4,
            ),
            Visibility(
              visible: isRequire,
              child: Text(
                "*",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          textInputAction: TextInputAction.go,
          validator: (value) {
            if ((value ?? "").isEmpty && isRequire) {
              return errorMess;
            } else {
              return null;
            }
          },
          enabled: enable,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorMaxLines: 1,
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            fillColor: Colors.grey,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: hint,
            prefixIcon: prefixIcon,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
