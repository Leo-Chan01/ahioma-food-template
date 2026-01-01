import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_status_detail_entity.dart';

class OrderStatusTimelineWidget extends StatelessWidget {
  const OrderStatusTimelineWidget({
    required this.statusDetails,
    super.key,
  });

  final List<OrderStatusDetailEntity> statusDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statusDetails.length,
      itemBuilder: (context, index) {
        final status = statusDetails[index];
        final isLast = index == statusDetails.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: status.isCompleted
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: status.isCompleted
                            ? HugeIcons.strokeRoundedTick02
                            : HugeIcons.strokeRoundedCircle,
                        color: status.isCompleted
                            ? theme.colorScheme.surface
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                        size: status.isCompleted ? 24 : 12,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              if (status.isCompleted)
                                theme.colorScheme.onSurface
                              else
                                theme.colorScheme.onSurface.withValues(
                                  alpha: 0.2,
                                ),
                              if (statusDetails[index + 1].isCompleted)
                                theme.colorScheme.onSurface
                              else
                                theme.colorScheme.onSurface.withValues(
                                  alpha: 0.1,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Status details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              status.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: status.isCompleted
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                              ),
                            ),
                          ),
                          Text(
                            status.time,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
