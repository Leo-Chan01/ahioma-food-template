import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/wallet_strings.dart';
import 'package:ahioma_food_template/features/fund_management/data/data_sources/local/wallet_local_source.dart';
import 'package:ahioma_food_template/features/fund_management/data/models/transaction_model.dart';
import 'package:ahioma_food_template/features/fund_management/presentation/widgets/transaction_history_widget.dart';
import 'package:ahioma_food_template/features/fund_management/presentation/widgets/wallet_card_widget.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_mode_entity.dart';
import 'package:ahioma_food_template/features/search/presentation/screens/search_screen.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  static const String path = '/wallet';
  static const String name = 'wallet';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletLocalSource _walletSource = WalletLocalSource();
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await _walletSource.getTransactions();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleTopUp() {
    // TODO: Navigate to top up screen or show bottom sheet
    GlobalSnackBar.showInfo(WalletStrings.topUpComingSoon);
  }

  void _handleSeeAll() {
    // TODO: Navigate to full transaction history screen
    GlobalSnackBar.showInfo(WalletStrings.transactionHistoryComingSoon);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AppIcons.wallet(
              color: theme.colorScheme.onSurface,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              WalletStrings.myEWallet,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: AppIcons.search(
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              context.push(
                SearchScreen.getRoutePath(SearchMode.wallet),
              );
            },
          ),
          IconButton(
            icon: AppIcons.moreVertical(
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _loadTransactions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Card
              WalletCardWidget(
                cardholderName: _walletSource.cardholderName,
                cardNumber: _walletSource.cardNumber,
                balance: _walletSource.balance,
                onTopUpPressed: _handleTopUp,
                loading: _isLoading,
              ),
              // Transaction History
              if (!_isLoading)
                TransactionHistoryWidget(
                  transactions: _transactions,
                  onSeeAllPressed: _handleSeeAll,
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
