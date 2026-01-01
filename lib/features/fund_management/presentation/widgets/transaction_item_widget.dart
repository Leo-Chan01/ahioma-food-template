import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/wallet_strings.dart';
import 'package:ahioma_food_template/features/fund_management/domain/entities/transaction_entity.dart';

class TransactionItemWidget extends StatelessWidget {
  const TransactionItemWidget({
    required this.transaction,
    super.key,
  });

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTopUp = transaction.type == TransactionType.topUp;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Transaction icon/image
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isTopUp
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(28),
            ),
            child: isTopUp
                ? Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AppIcons.wallet(
                          color: theme.colorScheme.onSurface,
                          size: 24,
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: AppIcons.arrowDown(
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: transaction.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: transaction.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_outlined,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.image_outlined,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                  ),
          ),
          const SizedBox(width: 16),
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.date} | ${transaction.time}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          // Amount and type
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isTopUp ? WalletStrings.topUpType : WalletStrings.orders,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isTopUp
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (isTopUp)
                    AppIcons.arrowDown(
                      color: theme.colorScheme.primary,
                      size: 14,
                    )
                  else
                    AppIcons.arrowUp(
                      color: theme.colorScheme.error,
                      size: 14,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
