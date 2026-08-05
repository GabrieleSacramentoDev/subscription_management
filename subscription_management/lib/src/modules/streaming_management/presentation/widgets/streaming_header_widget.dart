import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/utils/formatters.dart';

class StreamingHeaderWidget extends StatelessWidget {
  final StreamingEntity streaming;
  final bool isNewStreaming;
  static const _primaryColor = Color.fromRGBO(111, 86, 221, 1);
  static const _dateFormat = 'dd/MM/yyyy';

  const StreamingHeaderWidget({
    super.key,
    required this.streaming,
    required this.isNewStreaming,
  });

  @override
  Widget build(BuildContext context) {
    if (isNewStreaming) {
      return _buildNewStreamingHeader();
    } else {
      return _buildEditStreamingHeader();
    }
  }

  Widget _buildNewStreamingHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: streaming.streamingImage?.isNotEmpty == true
          ? Image.asset(
              streaming.streamingImage!,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildEditStreamingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildStreamingName(), _buildStreamingInfo()],
    );
  }

  Widget _buildStreamingName() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        streaming.streamingName,
        style: TextStyle(
          fontSize: 24.sp,
          color: _primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStreamingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (streaming.streamingValue != null)
          Text(
            CurrencyFormatter.format(streaming.streamingValue!),
            style: TextStyle(
              fontSize: 24.sp,
              color: _primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (streaming.renewalDate != null)
          Text(
            DateFormat(_dateFormat).format(streaming.renewalDate!),
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color.fromRGBO(77, 77, 97, 1),
            ),
          ),
      ],
    );
  }
}
