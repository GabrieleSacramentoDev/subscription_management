import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/resolve_streaming_lifecycle_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/update_streaming_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/utils/subscription_lifecycle.dart';

class ResolveStreamingLifecycleUseCaseImpl
    implements ResolveStreamingLifecycleUseCase {
  ResolveStreamingLifecycleUseCaseImpl({
    required this.updateStreamingUseCase,
  });

  final UpdateStreamingUseCase updateStreamingUseCase;

  @override
  Future<List<StreamingEntity>> call(List<StreamingEntity> streamings) async {
    final resolved = <StreamingEntity>[];

    for (final streaming in streamings) {
      resolved.add(await _resolveStreaming(streaming));
    }

    return resolved;
  }

  Future<StreamingEntity> _resolveStreaming(StreamingEntity streaming) async {
    final renewalDate = streaming.renewalDate;
    if (renewalDate == null) {
      return streaming;
    }

    final lifecycle = calculateSubscriptionLifecycle(
      storedDueDate: renewalDate,
      periodicity: streaming.periodicity,
    );

    if (!lifecycle.shouldAdvanceStoredDueDate ||
        lifecycle.advancedStoredDueDate == null) {
      return streaming;
    }

    final updated = streaming.copyWith(
      renewalDate: lifecycle.advancedStoredDueDate,
    );

    await updateStreamingUseCase.call(updated);
    return updated;
  }
}
