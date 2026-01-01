import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/wallet_strings.dart';
import 'package:ahioma_food_template/features/fund_management/domain/entities/transaction_entity.dart';
import 'package:ahioma_food_template/features/fund_management/presentation/widgets/transaction_item_widget.dart';

class TransactionHistoryWidget extends StatelessWidget {
  const TransactionHistoryWidget({
    required this.transactions,
    this.onSeeAllPressed,
    super.key,
  });

  final List<TransactionEntity> transactions;
  final VoidCallback? onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                WalletStrings.transactionHistory,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onSeeAllPressed != null)
                TextButton(
                  onPressed: onSeeAllPressed,
                  child: Text(
                    WalletStrings.seeAll,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Transactions list
        if (transactions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  AppIcons.wallet(
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    WalletStrings.noTransactionsYet,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return TransactionItemWidget(
                transaction: transactions[index],
              );
            },
          ),
      ],
    );
  }
}
