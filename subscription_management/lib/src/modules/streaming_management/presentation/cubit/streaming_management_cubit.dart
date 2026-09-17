import 'dart:async';

import 'package:doso/doso.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/subscriptions_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/add_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/delete_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/get_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/cancel_subscription_notification_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/schedule_subscription_notification_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/sync_subscription_notifications_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/resolve_streaming_lifecycle_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/update_streaming_use_case.dart';

typedef StreamingManagementState = Do<Exception, List<StreamingEntity>>;

class StreamingManagementCubit extends Cubit<StreamingManagementState> {
  final AddStreamingUseCase addStreamingUseCase;
  final GetStreamingUseCase getStreamingUseCase;
  final UpdateStreamingUseCase updateStreamingUseCase;
  final DeleteStreamingUseCase deleteStreamingUseCase;
  final ScheduleSubscriptionNotificationUseCase
  scheduleSubscriptionNotificationUseCase;
  final CancelSubscriptionNotificationUseCase
  cancelSubscriptionNotificationUseCase;
  final SyncSubscriptionNotificationsUseCase
  syncSubscriptionNotificationsUseCase;
  final ResolveStreamingLifecycleUseCase resolveStreamingLifecycleUseCase;

  StreamSubscription<List<StreamingEntity>>? _streamingsSubscription;

  StreamingManagementCubit({
    required this.addStreamingUseCase,
    required this.getStreamingUseCase,
    required this.updateStreamingUseCase,
    required this.deleteStreamingUseCase,
    required this.scheduleSubscriptionNotificationUseCase,
    required this.cancelSubscriptionNotificationUseCase,
    required this.syncSubscriptionNotificationsUseCase,
    required this.resolveStreamingLifecycleUseCase,
  }) : super(const Do.initial());

  Future<void> getStreamings({bool showLoading = true}) async {
    try {
      if (showLoading) {
        emit(const Do.loading());
      }
      await _streamingsSubscription?.cancel();
      _streamingsSubscription = getStreamingUseCase().listen(
        (streamings) async {
          try {
            final resolved = await resolveStreamingLifecycleUseCase.call(
              streamings,
            );
            if (isClosed) {
              return;
            }
            emit(Do.success(resolved));
            unawaited(syncSubscriptionNotificationsUseCase.call(resolved));
          } catch (error) {
            if (isClosed) {
              return;
            }
            emit(Do.failure(Exception(error)));
          }
        },
        onError: (error) {
          if (isClosed) {
            return;
          }
          emit(Do.failure(Exception(error)));
        },
      );
    } catch (e) {
      emit(Do.failure(Exception(e)));
    }
  }

  Future<void> refreshStreamings() {
    return getStreamings(showLoading: false);
  }

  @override
  Future<void> close() async {
    await _streamingsSubscription?.cancel();
    return super.close();
  }

  Future<void> addStreaming(
    StreamingEntity streaming,
    SubscriptionEntity subscription,
  ) async {
    try {
      emit(const Do.loading());
      await addStreamingUseCase.addStreaming(streaming);
      await scheduleSubscriptionNotificationUseCase.call(subscription);
      emit(Do.success([streaming]));
    } catch (e) {
      emit(Do.failure(Exception(e)));
      return;
    }
  }

  Future<void> updateStreaming(
    StreamingEntity streaming,
    SubscriptionEntity subscription,
  ) async {
    try {
      emit(const Do.loading());
      await updateStreamingUseCase.call(streaming);
      await scheduleSubscriptionNotificationUseCase.call(subscription);
      emit(Do.success([streaming]));
    } catch (e) {
      emit(Do.failure(Exception(e)));
      return;
    }
  }

  Future<void> deleteStreaming(String streamingId) async {
    try {
      emit(const Do.loading());
      await cancelSubscriptionNotificationUseCase.call(streamingId);
      await deleteStreamingUseCase.call(streamingId);

      getStreamings();
    } catch (e) {
      emit(Do.failure(Exception(e)));
      return;
    }
  }
}
