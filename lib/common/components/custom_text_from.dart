import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String? customHintText;
  final String? customErrorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  // final Function customValidator;
  const CustomTextForm({
    super.key,
    required this.onChanged,
    this.customHintText,
    this.customErrorText,
    this.obscureText = false,
    this.autofocus = true,
    //  this.customValidator,
  });
  //  : customValidator = customValidator ?? (){};

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      // borderSide는 실제 테두리를 의미합니다. 여기서 색상과 너비를 지정할 수 있습니다.
      borderSide: BorderSide(
        color: Color(0xFFF3F2F2),
        width: 1.0,
      ),
    );

    return TextFormField(
      onChanged: onChanged,
      cursorColor: Colors.black,
      obscureText: obscureText,
      autofocus: autofocus,
      // validator: customValidator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        hintText: customHintText ?? '값을 입력해주세요.',
        hintStyle: const TextStyle(
          color: Color(0xFF868686),
          fontSize: 14.0,
        ),
        errorText: customErrorText,
        filled: true,
        fillColor: const Color(0xFFFBFBFB),
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
