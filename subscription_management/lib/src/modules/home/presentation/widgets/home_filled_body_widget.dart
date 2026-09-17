import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/streaming_list_widget.dart';
import 'package:subscription_management/src/modules/home/presentation/widgets/total_spent_section.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/presentation/cubit/streaming_management_cubit.dart';
import 'package:subscription_management/src/utils/app_strings.dart';

class HomeFilledBodyWidget extends StatefulWidget {
  final StreamingEntity? streamingEntity;

  const HomeFilledBodyWidget({super.key, this.streamingEntity});

  @override
  State<HomeFilledBodyWidget> createState() => _HomeFilledBodyWidgetState();
}

class _HomeFilledBodyWidgetState extends State<HomeFilledBodyWidget>
    with WidgetsBindingObserver {
  final strings = SubscriptionsManagementStrings();
  final _getStreamingCubit = GetIt.I.get<StreamingManagementCubit>();
  final _homeReloadTick = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _homeReloadTick.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }
    unawaited(_getStreamingCubit.refreshStreamings());
    _homeReloadTick.value++;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getStreamingCubit..getStreamings(),
      child: ValueListenableBuilder<int>(
        valueListenable: _homeReloadTick,
        builder: (context, _, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                BlocBuilder<StreamingManagementCubit, StreamingManagementState>(
                  builder: (context, state) =>
                      TotalSpentSectionWidget(state: state),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    strings.mySubscriptions,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(111, 86, 221, 1),
                    ),
                  ),
                ),
                BlocBuilder<StreamingManagementCubit, StreamingManagementState>(
                  builder: (context, state) =>
                      StreamingListWidget(state: state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
