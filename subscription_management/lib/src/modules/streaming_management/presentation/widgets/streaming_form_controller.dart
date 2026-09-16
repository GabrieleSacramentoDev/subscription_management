import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscription_management/src/modules/home/domain/enums/payment_method.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/enums/subscription_periodicity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/utils/formatters.dart';

class StreamingFormController {
  static const _dateFormat = 'dd/MM/yyyy';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController startsAtController = TextEditingController();
  final TextEditingController renewalDateController = TextEditingController();

  final ValueNotifier<bool> isSavingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isDeletingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isFormValidNotifier = ValueNotifier<bool>(false);

  PaymentMethod? selectedPaymentMethod;
  SubscriptionPeriodicity selectedPeriodicity =
      SubscriptionPeriodicity.monthly;

  void initializeFields(StreamingEntity streaming, bool isNewStreaming) {
    nameController.text = streaming.streamingName;

    if (!isNewStreaming) {
      _initializeEditFields(streaming);
    }
  }

  void _initializeEditFields(StreamingEntity streaming) {
    if (streaming.streamingValue != null) {
      valueController.text = CurrencyFormatter.format(
        streaming.streamingValue!,
      );
    }

    if (streaming.startsAt != null) {
      startsAtController.text = DateFormat(
        _dateFormat,
      ).format(streaming.startsAt!);
    }

    if (streaming.renewalDate != null) {
      renewalDateController.text = DateFormat(
        _dateFormat,
      ).format(streaming.renewalDate!);
    }

    selectedPaymentMethod = streaming.paymentMethod;
    selectedPeriodicity = streaming.periodicity;
  }

  void setupFormValidation() {
    nameController.addListener(validateForm);
    valueController.addListener(validateForm);
    startsAtController.addListener(validateForm);
    renewalDateController.addListener(validateForm);
    validateForm();
  }

  void validateForm() {
    final isNameValid = nameController.text.trim().isNotEmpty;
    final isValueValid = valueController.text.trim().isNotEmpty;
    final isStartsAtValid = startsAtController.text.trim().isNotEmpty;
    final isRenewalDateValid = renewalDateController.text.trim().isNotEmpty;
    final isPaymentMethodValid = selectedPaymentMethod != null;

    final isFormValid =
        isNameValid &&
        isValueValid &&
        isStartsAtValid &&
        isRenewalDateValid &&
        isPaymentMethodValid;

    isFormValidNotifier.value = isFormValid;
  }

  void formatCurrency(String value) {
    final formattedValue = CurrencyFormatter.formatInput(value);
    if (formattedValue.isNotEmpty) {
      valueController.value = TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(
          offset: formattedValue.length.clamp(0, formattedValue.length),
        ),
      );
    }
  }

  void updatePaymentMethod(String? value) {
    if (value != null) {
      selectedPaymentMethod = PaymentMethod.getPaymentMethodFromString(value);
      validateForm();
    }
  }

  void updatePeriodicity(String? value) {
    final periodicity = SubscriptionPeriodicity.fromLabel(value);
    if (periodicity != null) {
      selectedPeriodicity = periodicity;
      validateForm();
    }
  }

  StreamingEntity buildStreamingEntity(
    StreamingEntity originalStreaming,
    bool isNewStreaming,
  ) {
    return StreamingEntity(
      streamingId: isNewStreaming ? null : originalStreaming.streamingId,
      streamingName: nameController.text,
      streamingValue: CurrencyFormatter.parse(valueController.text),
      startsAt:
          _parseDate(startsAtController.text) ??
          (isNewStreaming ? null : originalStreaming.startsAt),
      renewalDate:
          _parseDate(renewalDateController.text) ??
          (isNewStreaming ? null : originalStreaming.renewalDate),
      paymentMethod: selectedPaymentMethod ?? originalStreaming.paymentMethod,
      periodicity: selectedPeriodicity,
    );
  }

  DateTime? _parseDate(String dateText) {
    if (dateText.isEmpty) return null;
    try {
      return DateFormat(_dateFormat).parse(dateText);
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    nameController.dispose();
    valueController.dispose();
    startsAtController.dispose();
    renewalDateController.dispose();
    isSavingNotifier.dispose();
    isDeletingNotifier.dispose();
    isFormValidNotifier.dispose();
  }
}
