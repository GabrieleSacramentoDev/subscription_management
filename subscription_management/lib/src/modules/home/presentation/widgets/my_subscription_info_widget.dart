import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySubscriptionInfoWidget extends StatelessWidget {
  final String streamingServiceName;
  final Widget? streamingServiceImage;

  final String? renewalDate;
  final num? subscriptionPrice;
  final bool seeDetails;
  final Function() onTap;
  final Color? renewalColor;
  const MySubscriptionInfoWidget({
    super.key,
    required this.streamingServiceName,
    this.renewalDate,
    this.subscriptionPrice,
    this.seeDetails = false,
    required this.onTap,
    this.streamingServiceImage,
    this.renewalColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 16.h),
        width: double.infinity,
        height: 55.h,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, .06),
          border: Border.all(
            width: 1.w,
            color: const Color.fromRGBO(111, 86, 221, 1),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Visibility(
                  visible: streamingServiceImage != null,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 0, 0, .06),
                        border: Border.all(
                          width: 1.w,
                          color: const Color.fromRGBO(111, 86, 221, 1),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      width: 32.w,
                      height: 32.h,
                      child: streamingServiceImage,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: renewalDate != null
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: renewalDate != null
                          ? EdgeInsets.only(left: 12.w, top: 12.h)
                          : EdgeInsets.only(left: 12.w),
                      child: Text(
                        streamingServiceName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color.fromRGBO(111, 86, 221, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (renewalDate != null)
                      Padding(
                        padding: EdgeInsets.only(left: 12.w, top: 4.h),
                        child: Text(
                          renewalDate!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: renewalColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Text(
                    subscriptionPrice != null
                        ? 'R\$ ${subscriptionPrice!.toStringAsFixed(2)}'
                        : '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: const Color.fromRGBO(111, 86, 221, 1),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                if (seeDetails)
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: const Color.fromRGBO(111, 86, 221, 1),
                      size: 20.sp,
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Icon(
                      Icons.add_circle,
                      color: const Color.fromRGBO(111, 86, 221, 1),
                      size: 32.sp,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
