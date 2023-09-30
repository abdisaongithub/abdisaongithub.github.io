import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../src/theme/theme.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final bool obscureText;
  final bool isPhone;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final Function(String? value)? onChanged;
  final Function()? onPressedForPassword;
  final String? Function(String? val)? validator;
  final AutovalidateMode autoValidate;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int? maxLength;
  final Function(String? value)? onFieldSubmitted;

  const CustomTextField({
    Key? key,
    this.title,
    this.imageUrl,
    this.obscureText = false,
    required this.controller,
    this.onTap,
    this.onChanged,
    this.validator,
    this.isPhone = false,
    this.onPressedForPassword,
    this.autoValidate = AutovalidateMode.onUserInteraction,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 4,
        bottom: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7FC),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xff02041817).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: obscureText,
        controller: controller,
        onTap: onTap,
        validator: validator,
        autovalidateMode: autoValidate,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: maxLength != null
            ? [
                LengthLimitingTextInputFormatter(maxLength),
              ]
            : null,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: isPhone
              ? Text(
                  "+251",
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).custom.textColor.withOpacity(0.3),
                  ),
                )
              : const SizedBox(),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          hintText: title,
          hintStyle: TextStyle(
            color: Theme.of(context).custom.textColor.withOpacity(0.3),
          ),
          suffixIcon: GestureDetector(
            onTap: onPressedForPassword,
            child: SizedBox(
              height: 20,
              width: 20,
              child: imageUrl != null
                  ? SvgPicture.asset(
                      imageUrl!,
                    )
                  : Container(),
            ),
          ),
          suffixIconColor: const Color(0xff7E7E7E),
          suffixIconConstraints: const BoxConstraints(
            maxHeight: 24,
            minHeight: 10,
            maxWidth: 30,
          ),
        ),
      ),
    );
  }
}
