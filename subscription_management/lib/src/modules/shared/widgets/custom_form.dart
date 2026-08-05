// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomForm extends StatelessWidget {
  ValueNotifier<bool> activeBorder = ValueNotifier<bool>(true);
  final TextEditingController? controller;
  final void Function(String text)? onChanged;
  final String? Function(String? text)? validator;
  final String? hintText;
  final Widget? suffixIcon;
  final String? label;
  bool isMandatory;
  final bool? obscurePassword;
  final bool isDatePicker;
  final Function()? onTap;
  final bool isPrefixHint;
  final TextInputType? keyboardType;
  final String? semanticLabel;

  CustomForm({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    this.hintText,
    this.suffixIcon,
    this.obscurePassword = false,
    this.label,
    this.isMandatory = false,
    this.isDatePicker = false,
    this.isPrefixHint = false,
    this.keyboardType,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label ?? '',
              style: TextStyle(
                color: const Color.fromRGBO(111, 86, 221, 1),
                fontWeight: FontWeight.w400,
                fontSize: 14.h,
                fontStyle: FontStyle.normal,
              ),
            ),
            Text(
              isMandatory ? ' *' : '',
              style: TextStyle(
                color: const Color.fromRGBO(111, 86, 221, 1),
                fontWeight: FontWeight.w400,
                fontSize: 14.h,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
        Semantics(
          label: semanticLabel,
          child: TextFormField(
            keyboardType: isDatePicker ? TextInputType.none : keyboardType,
            inputFormatters: [
              if (keyboardType == TextInputType.number)
                FilteringTextInputFormatter.digitsOnly,
            ],
            obscureText: obscurePassword ?? false,
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            readOnly: isDatePicker,
            onTap: onTap,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: isPrefixHint ? null : hintText,
              prefixIcon: isPrefixHint && hintText != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 15.h, right: 8.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$hintText: ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.h,
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(horizontal: 15.h),
              suffixIcon: suffixIcon,
              suffixIconColor: const Color.fromRGBO(111, 86, 221, 1),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 1.w,
                  color: const Color.fromRGBO(111, 86, 221, 1),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(width: 1.w, color: Colors.redAccent),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.w,
                  color: const Color.fromRGBO(37, 41, 84, 0.15),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(
                fontSize: 16.h,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            style: const TextStyle(
              color: Color.fromRGBO(111, 86, 221, 1), // Cor roxa para datas
            ),
          ),
        ),
      ],
    );
  }
}
