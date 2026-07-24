import 'package:doso/doso.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/subscriptions_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/add_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/delete_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/get_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/schedule_subscription_notification_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/update_streaming_use_case.dart';

typedef StreamingManagementState = Do<Exception, List<StreamingEntity>>;

class StreamingManagementCubit extends Cubit<StreamingManagementState> {
  final AddStreamingUseCase addStreamingUseCase;
  final GetStreamingUseCase getStreamingUseCase;
  final UpdateStreamingUseCase updateStreamingUseCase;
  final DeleteStreamingUseCase deleteStreamingUseCase;
  final ScheduleSubscriptionNotificationUseCase
  scheduleSubscriptionNotificationUseCase;
  StreamingManagementCubit({
    required this.addStreamingUseCase,
    required this.getStreamingUseCase,
    required this.updateStreamingUseCase,
    required this.deleteStreamingUseCase,
    required this.scheduleSubscriptionNotificationUseCase,
  }) : super(const Do.initial());

  Future<void> getStreamings() async {
    try {
      emit(const Do.loading());
      getStreamingUseCase()
          .listen((streamings) {
            emit(Do.success(streamings));
          })
          .onError((error) {
            emit(Do.failure(Exception(error)));
          });
    } catch (e) {
      emit(Do.failure(Exception(e)));
      return;
    }
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
      await deleteStreamingUseCase.call(streamingId);

      getStreamings();
    } catch (e) {
      emit(Do.failure(Exception(e)));
      return;
    }
  }
}
