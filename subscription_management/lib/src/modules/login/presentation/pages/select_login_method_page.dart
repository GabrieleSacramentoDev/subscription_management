import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/modules/shared/widgets/custom_button.dart';
import 'package:subscription_management/src/modules/shared/widgets/value_spent_information_card.dart';
import 'package:subscription_management/src/routes/router.dart';
import 'package:subscription_management/src/utils/app_strings.dart';

@RoutePage(name: 'SelectLoginMethodRoute')
class SelectLoginMethodPage extends StatelessWidget {
  final strings = SubscriptionsManagementStrings();
  SelectLoginMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(228, 228, 237, 1),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/subscription_management_logo.png',
                    fit: BoxFit.cover,
                    width: 127.h,
                    height: 127.h,
                  ),
                ),

                Text(
                  strings.manageYour,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(77, 77, 97, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  strings.subscriptions,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(111, 86, 221, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text(
                    strings.manageYourSubscriptionWhitoutComplications,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color.fromRGBO(77, 77, 97, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h),

                  child: const ValueSpentInformationCard(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.h, bottom: 32.h),
                  child: Image.asset(
                    'assets/images/banner.png',
                    fit: BoxFit.cover,
                  ),
                ),
                CustomButton(
                  textButton: strings.enter,
                  onPressed: () =>
                      context.pushRoute(LoginPageRoute(isFromSignUp: false)),
                  isLarge: true,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 32.h),
                  child: GestureDetector(
                    onTap: () =>
                        context.pushRoute(LoginPageRoute(isFromSignUp: true)),
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromRGBO(111, 86, 221, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
