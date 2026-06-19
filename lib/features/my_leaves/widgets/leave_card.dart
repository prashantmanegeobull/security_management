import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/model/my_leave_model.dart';

class LeaveCard extends StatelessWidget {
  final MyLeaveModel leave;

  const LeaveCard({
    super.key,
    required this.leave,
  });

  Color get statusColor {
    switch (leave.status.toLowerCase()) {
      case 'approved':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'rejected':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            children: [
              Expanded(
                child: Text(
                  leave.leaveType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                leave.status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            DateFormat('dd MMM yyyy').format(leave.fromDate),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '${leave.toDate.difference(leave.fromDate).inDays + 1} Day${leave.toDate.difference(leave.fromDate).inDays == 0 ? '' : 's'}',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}