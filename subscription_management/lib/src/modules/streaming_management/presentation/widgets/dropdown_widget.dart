import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/utils/app_strings.dart';

class DropdownWidget extends StatefulWidget {
  final bool isPaymentMethod;
  final List<String> options;
  final Function(String?)? onChanged;
  final String? selectedValue;

  const DropdownWidget({
    super.key,
    required this.options,
    this.isPaymentMethod = false,
    this.onChanged,
    this.selectedValue,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  final strings = SubscriptionsManagementStrings();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(37, 41, 84, 0.15),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            widget.isPaymentMethod
                ? "${strings.paymentMethod}:"
                : "${strings.renewAt}:",
            style: TextStyle(fontSize: 14.h, color: Colors.grey[600]),
          ),
          value: widget.selectedValue,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color.fromRGBO(111, 86, 221, 1),
          ),
          elevation: 16,
          style: TextStyle(
            color: const Color.fromRGBO(37, 41, 84, 1),
            fontSize: 14.h,
          ),
          onChanged: (String? newValue) {
            widget.onChanged?.call(newValue);
          },
          selectedItemBuilder: (BuildContext context) {
            return widget.options.map<Widget>((String value) {
              return Row(
                children: [
                  Text(
                    widget.isPaymentMethod
                        ? "${strings.paymentMethod}:"
                        : "${strings.renewAt}:",
                    style: TextStyle(fontSize: 14.h, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14.h,
                        color: const Color.fromRGBO(111, 86, 221, 1),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: widget.options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }
}
