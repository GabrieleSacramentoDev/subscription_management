import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:subscription_management/src/modules/shared/widgets/loading_button.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/subscriptions_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/cubit/streaming_management_cubit.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/widgets/cancel_subscription_modal_content.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/widgets/streaming_form_controller.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/widgets/streaming_form_widget.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/widgets/streaming_header_widget.dart';
import 'package:subscription_management/src/modules/shared/widgets/custom_button.dart';
import 'package:subscription_management/src/routes/router.dart';
import 'package:subscription_management/src/utils/app_strings.dart';
import 'package:subscription_management/src/utils/widgets/custom_snack_bar_widget.dart';

@RoutePage(name: 'StreamingManagementPageRoute')
class StreamingManagementPage extends StatefulWidget {
  final StreamingEntity streaming;
  final bool newStreaming;

  const StreamingManagementPage({
    super.key,
    required this.newStreaming,
    required this.streaming,
  });

  @override
  State<StreamingManagementPage> createState() =>
      _StreamingManagementPageState();
}

class _StreamingManagementPageState extends State<StreamingManagementPage> {
  static const _backgroundColor = Color.fromRGBO(243, 243, 243, 1);
  static const _primaryColor = Color.fromRGBO(111, 86, 221, 1);
  static const _deleteColor = Color.fromRGBO(221, 86, 86, 1);
  static const _dateFormat = 'dd/MM/yyyy';

  final strings = SubscriptionsManagementStrings();
  final _streamingCubit = GetIt.I.get<StreamingManagementCubit>();
  final _formController = StreamingFormController();

  @override
  void initState() {
    super.initState();
    _formController.initializeFields(widget.streaming, widget.newStreaming);
    _formController.setupFormValidation();
  }

  @override
  void dispose() {
    _formController.dispose();
    _streamingCubit.close();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) => _buildDatePickerTheme(child!),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat(_dateFormat).format(picked);
      });
      _formController.validateForm();
    }
  }

  Future<void> _onSavePressed() async {
    _formController.isSavingNotifier.value = true;
    final entity = _formController.buildStreamingEntity(
      widget.streaming,
      widget.newStreaming,
    );

    final subscriptionEntity = SubscriptionEntity(
      id: entity.streamingId ?? '',
      name: entity.streamingName,
      price: entity.streamingValue,
      dueDate: entity.renewalDate ?? DateTime.now(),
    );

    if (widget.newStreaming) {
      await _streamingCubit.addStreaming(entity, subscriptionEntity);
    } else {
      await _streamingCubit.updateStreaming(entity, subscriptionEntity);
    }
  }

  Future<void> _onDeletePressed() async {
    _formController.isDeletingNotifier.value = true;
    await _streamingCubit.deleteStreaming(widget.streaming.streamingId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: _backgroundColor,
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: const Icon(Icons.arrow_back_ios_new, color: _primaryColor),
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Text(
          widget.newStreaming
              ? strings.addSubscription
              : strings.editSubscription,
          style: TextStyle(
            fontSize: 20.sp,
            color: _primaryColor,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      backgroundColor: _backgroundColor,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (context) => _streamingCubit,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  StreamingHeaderWidget(
                    streaming: widget.streaming,
                    isNewStreaming: widget.newStreaming,
                  ),
                  StreamingFormWidget(
                    controller: _formController,
                    onSelectDate: _selectDate,
                    onPaymentMethodChanged: () => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocConsumer<StreamingManagementCubit, StreamingManagementState>(
          listener: _handleBlocState,
          builder:
              (context, state) => Column(
                children: [
                  _buildSaveButton(),
                  if (!widget.newStreaming) _buildDeleteButton(),
                ],
              ),
        ),
      ],
    );
  }

  void _handleBlocState(BuildContext context, StreamingManagementState state) {
    if (state.isFailure) {
      final wasDeleting = _formController.isDeletingNotifier.value;
      _formController.isSavingNotifier.value = false;
      _formController.isDeletingNotifier.value = false;

      String errorMessage;
      if (wasDeleting) {
        errorMessage = strings.errorToCancelSubscription;
      } else if (widget.newStreaming) {
        errorMessage = strings.errorToCreateSubscription;
      } else {
        errorMessage = strings.errorToUpdateSubscription;
      }
      CustomSnackBar.showError(context, message: errorMessage);
    }

    if (state.isSuccess) {
      final wasDeleting = _formController.isDeletingNotifier.value;
      _formController.isSavingNotifier.value = false;
      _formController.isDeletingNotifier.value = false;

      String successMessage;
      if (wasDeleting) {
        successMessage = strings.subscriptionCanceled;
      } else if (widget.newStreaming) {
        successMessage = strings.subscriptionCreated;
      } else {
        successMessage = strings.subscriptionUpdated;
      }
      CustomSnackBar.showSuccess(context, message: successMessage);
      context.pushRoute(const HomePageRoute());
    }
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.h,
        right: 24.h,
        bottom: widget.newStreaming ? 32.h : 16.h,
        top: 32.h,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _formController.isSavingNotifier,
        builder: (context, isSaving, child) {
          if (isSaving) return const LoadingButton(isLarge: true);

          return ValueListenableBuilder<bool>(
            valueListenable: _formController.isFormValidNotifier,
            builder: (context, isFormValid, child) {
              return CustomButton(
                isLarge: true,
                textButton:
                    widget.newStreaming
                        ? strings.addSubscription
                        : strings.save,
                onPressed: () {
                  isFormValid ? _onSavePressed() : null;
                },
                buttonColor: isFormValid ? _primaryColor : Colors.grey.shade400,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 32.h),
      child: ValueListenableBuilder<bool>(
        valueListenable: _formController.isDeletingNotifier,
        builder: (context, isDeleting, child) {
          return isDeleting
              ? const LoadingButton(isLarge: true, buttonColor: _deleteColor)
              : CustomButton(
                isLarge: true,
                textButton: strings.cancelSubscription,
                onPressed: () {
                  CancelSubscriptionModalContent.show(
                    context,
                    streamingName: widget.streaming.streamingName,
                    onConfirm: () => _onDeletePressed(),
                  );
                },
                buttonColor: _deleteColor,
              );
        },
      ),
    );
  }

  Widget _buildDatePickerTheme(Widget child) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: _primaryColor,
        colorScheme: const ColorScheme.light(primary: _primaryColor),
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: child,
    );
  }
}
