import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/home_empty_body_widget.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/streaming_item_widget.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/utils/subscription_lifecycle.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/cubit/streaming_management_cubit.dart';
import 'package:subscription_management/src/utils/app_strings.dart';

class StreamingListWidget extends StatelessWidget {
  final StreamingManagementState state;

  const StreamingListWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return state.when(
      onLoading: () => const StreamingsLoadingWidget(),
      onFailure: (error) => StreamingsErrorWidget(),
      onSuccess: (streamings) {
        if (streamings.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: HomeEmptyBodyWidget(),
          );
        }

        final strings = SubscriptionsManagementStrings();
        final hasGraceSubscription = streamings.any((streaming) {
          final renewalDate = streaming.renewalDate;
          if (renewalDate == null) {
            return false;
          }
          final lifecycle = calculateSubscriptionLifecycle(
            storedDueDate: renewalDate,
            periodicity: streaming.periodicity,
          );
          return lifecycle.status == SubscriptionBillingStatus.grace;
        });

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 8.h, bottom: 72.h),
          itemCount: streamings.length + (hasGraceSubscription ? 1 : 0),
          itemBuilder: (context, index) {
            if (hasGraceSubscription && index == 0) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Material(
                  color: const Color.fromARGB(255, 255, 243, 224),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color.fromARGB(255, 199, 124, 10),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            strings.subscriptionGracePeriodBanner,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color.fromARGB(255, 120, 74, 6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final streamingIndex =
                hasGraceSubscription ? index - 1 : index;
            return StreamingItemWidget(
              streaming: streamings[streamingIndex],
            );
          },
        );
      },
    );
  }
}

class StreamingsLoadingWidget extends StatelessWidget {
  const StreamingsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(
          color: Color.fromRGBO(111, 86, 221, 1),
        ),
      ),
    );
  }
}

class StreamingsErrorWidget extends StatelessWidget {
  final strings = SubscriptionsManagementStrings();

  StreamingsErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        strings.unfortunatelySomethingWrongHappend,
        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
      ),
    );
  }
}
