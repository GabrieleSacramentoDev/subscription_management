import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/modules/shared/widgets/value_spent_information_card.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/cubit/streaming_management_cubit.dart';
import 'package:subscription_management/src/utils/calculator_service.dart';

class TotalSpentSectionWidget extends StatelessWidget {
  final StreamingManagementState state;

  const TotalSpentSectionWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalSpent = state.when(
      onLoading: () => 0.0,
      onFailure: (error) => 0.0,
      onSuccess: (streamings) =>
          CalculatorService.calculateTotalSpent(streamings),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Row(
        children: [
          Expanded(child: ValueSpentInformationCard(totalSpent: totalSpent)),
        ],
      ),
    );
  }
}
