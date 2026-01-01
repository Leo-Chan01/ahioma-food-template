import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ahioma_food_template/core/utils/strings/orders_strings.dart';
import 'package:ahioma_food_template/features/orders/presentation/provider/orders_provider.dart';
import 'package:ahioma_food_template/features/orders/presentation/screens/leave_review_screen.dart';
import 'package:ahioma_food_template/features/orders/presentation/screens/track_order_screen.dart';
import 'package:ahioma_food_template/features/orders/presentation/widgets/empty_orders_widget.dart';
import 'package:ahioma_food_template/features/orders/presentation/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  static const String path = '/my-orders';
  static const String name = 'my-orders';

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChange);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _loadOrders();
    }
  }

  Future<void> _loadOrders() async {
    final ordersProvider = context.read<OrdersProvider>();
    if (_tabController.index == 0) {
      await ordersProvider.loadOngoingOrders();
    } else {
      await ordersProvider.loadCompletedOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          OrdersStrings.myOrders,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedMoreVertical,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.onSurface,
          indicatorWeight: 3,
          labelColor: theme.colorScheme.onSurface,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.5,
          ),
          labelStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: theme.textTheme.titleMedium,
          tabs: const [
            Tab(text: OrdersStrings.ongoing),
            Tab(text: OrdersStrings.completed),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOngoingOrders(),
          _buildCompletedOrders(),
        ],
      ),
    );
  }

  Widget _buildOngoingOrders() {
    return Consumer<OrdersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (provider.ongoingOrders.isEmpty) {
          return const EmptyOrdersWidget(
            title: OrdersStrings.emptyOngoingTitle,
            message: OrdersStrings.emptyOngoingMessage,
          );
        }

        return RefreshIndicator.adaptive(
          onRefresh: () => provider.loadOngoingOrders(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.ongoingOrders.length,
            itemBuilder: (context, index) {
              final order = provider.ongoingOrders[index];
              return OrderItemWidget(
                order: order,
                actionLabel: OrdersStrings.trackOrderButton,
                onActionPressed: () {
                  context.push(
                    TrackOrderScreen.path,
                    extra: order,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCompletedOrders() {
    return Consumer<OrdersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (provider.completedOrders.isEmpty) {
          return const EmptyOrdersWidget(
            title: OrdersStrings.emptyCompletedTitle,
            message: OrdersStrings.emptyCompletedMessage,
          );
        }

        return RefreshIndicator.adaptive(
          onRefresh: () => provider.loadCompletedOrders(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.completedOrders.length,
            itemBuilder: (context, index) {
              final order = provider.completedOrders[index];
              return OrderItemWidget(
                order: order,
                actionLabel: OrdersStrings.leaveReviewButton,
                onActionPressed: () {
                  context.push(
                    LeaveReviewScreen.path,
                    extra: order,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
