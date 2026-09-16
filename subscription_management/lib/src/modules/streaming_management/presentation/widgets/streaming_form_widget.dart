import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscription_management/src/modules/home/domain/enums/payment_method.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/enums/subscription_periodicity.dart';
import 'package:subscription_management/src/modules/shared/widgets/custom_form.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/widgets/dropdown_widget.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/widgets/streaming_form_controller.dart';
import 'package:subscription_management/src/utils/app_strings.dart';

class StreamingFormWidget extends StatelessWidget {
  final StreamingFormController controller;
  final Function(TextEditingController) onSelectDate;
  final VoidCallback onPaymentMethodChanged;

  const StreamingFormWidget({
    super.key,
    required this.controller,
    required this.onSelectDate,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final strings = SubscriptionsManagementStrings();

    return Column(
      children: [
        CustomForm(
          semanticLabel: strings.name,
          hintText: strings.name,
          isPrefixHint: true,
          controller: controller.nameController,
        ),
        CustomForm(
          semanticLabel: strings.value,
          hintText: strings.value,
          isPrefixHint: true,
          controller: controller.valueController,
          onChanged: controller.formatCurrency,
          keyboardType: TextInputType.number,
        ),
        CustomForm(
          semanticLabel: strings.startsAt,
          hintText: strings.startsAt,
          isPrefixHint: true,
          suffixIcon: const Icon(Icons.calendar_month),
          controller: controller.startsAtController,
          isDatePicker: true,
          onTap: () => onSelectDate(controller.startsAtController),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: CustomForm(
            semanticLabel: strings.renewAt,
            hintText: strings.renewAt,
            isPrefixHint: true,
            suffixIcon: const Icon(Icons.calendar_month),
            controller: controller.renewalDateController,
            isDatePicker: true,
            onTap: () => onSelectDate(controller.renewalDateController),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: DropdownWidget(
            isPaymentMethod: true,
            options: [strings.debitCard, strings.creditCard, strings.pix],
            onChanged: (value) {
              controller.updatePaymentMethod(value);
              onPaymentMethodChanged();
            },
            selectedValue: PaymentMethod.getStringFromPaymentMethod(
              controller.selectedPaymentMethod,
            ),
          ),
        ),
        DropdownWidget(
          isPaymentMethod: false,
          fieldLabel: strings.periodicity,
          options: [
            SubscriptionPeriodicity.label(SubscriptionPeriodicity.monthly),
            SubscriptionPeriodicity.label(SubscriptionPeriodicity.annual),
          ],
          onChanged: (value) {
            controller.updatePeriodicity(value);
            onPaymentMethodChanged();
          },
          selectedValue: SubscriptionPeriodicity.label(
            controller.selectedPeriodicity,
          ),
        ),
      ],
    );
  }
}
