import 'package:bluebits_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  const CustomTextField({
    super.key,

    required this.icon,
    required this.isPassword,
    required this.controller,
    required this.validator,
    required this.labelText,
    required this.hintText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var icons = Icons.visibility_off;
  bool hidepassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.isPassword ? hidepassword : false,
      style: TextStyle(color: ColorsManager.whiteText, fontSize: 12),
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        filled: true,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: ColorsManager.whiteText),
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: () {
                  hidepassword = !hidepassword;
                  hidepassword
                      ? icons = Icons.visibility_off
                      : icons = Icons.visibility;
                  setState(() {});
                },
                child: Icon(icons, color: ColorsManager.white),
              )
            : null,
        prefixIcon: Icon(
          widget.icon,
          color: ColorsManager.cyan,
        ), // Matching your teal accent
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.grey.withOpacity(0.5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.cyan, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.redaccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorsManager.redaccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
