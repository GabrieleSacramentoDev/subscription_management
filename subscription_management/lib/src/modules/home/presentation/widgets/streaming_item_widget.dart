import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/my_subscription_info_widget.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/routes/router.dart';
import 'package:subscription_management/src/utils/get_days_until_renewal.dart';

class StreamingItemWidget extends StatelessWidget {
  final StreamingEntity streaming;

  const StreamingItemWidget({super.key, required this.streaming});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: MySubscriptionInfoWidget(
        onTap: () {
          context.pushRoute(
            StreamingManagementPageRoute(
              streaming: streaming,
              newStreaming: false,
            ),
          );
        },
        streamingServiceName: streaming.streamingName,
        renewalDate: streaming.renewalDate != null
            ? formatRenewalDate(
                streaming.renewalDate!,
                periodicity: streaming.periodicity,
              )
            : 'Data não definida',
        subscriptionPrice: streaming.streamingValue,
        seeDetails: true,
        renewalColor: streaming.renewalDate != null
            ? getRenewalColor(
                streaming.renewalDate!,
                periodicity: streaming.periodicity,
              )
            : Colors.grey,
      ),
    );
  }
}
