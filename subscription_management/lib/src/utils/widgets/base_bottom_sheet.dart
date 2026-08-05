import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseBottomSheet extends StatelessWidget {
  const BaseBottomSheet({super.key});

  static Future<T?> showBottomSheet<T>({
    required Widget child,
    required BuildContext context,
    String? title,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool showCloseButton = true,
    String? closeButtonSemantics,
    IconData? closeButtonIcon,
    VoidCallback? onPop,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return showCloseButton
            ? PopScope(
                child: SafeArea(
                  child: Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: crossAxisAlignment,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 20.h,
                                    left: 16.w,
                                  ),
                                  child: Text(
                                    title ?? '',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                        15,
                                        17,
                                        19,
                                        1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 20.h,
                                  right: 16.w,
                                ),
                                child: Semantics(
                                  button: true,
                                  hint: closeButtonSemantics,
                                  child: GestureDetector(
                                    onTap: () {
                                      onPop?.call();
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      closeButtonIcon ?? Icons.close,
                                      color: Colors.black,
                                      size: 16.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child,
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : SafeArea(child: child);
      },
      backgroundColor: Colors.white,
      barrierColor: Colors.black,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
