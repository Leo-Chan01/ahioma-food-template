import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/core/utils/strings/orders_strings.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/entities/track_order_entity.dart';
import 'package:ahioma_food_template/features/orders/domain/repository/orders_repository.dart';
import 'package:ahioma_food_template/features/orders/presentation/widgets/order_status_timeline_widget.dart';
import 'package:ahioma_food_template/injection_container.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({required this.order, super.key});

  static const String path = '/track-order';
  static const String name = 'track-order';

  final OrderEntity order;

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  final OrdersRepository _ordersRepository = sl<OrdersRepository>();
  TrackOrderEntity? _trackedOrder;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrackOrder();
  }

  Future<void> _loadTrackOrder() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check if orderNumber is available - API requires orderNumber, not id
      if (widget.order.orderNumber == null ||
          widget.order.orderNumber!.isEmpty) {
        if (mounted) {
          setState(() {
            _error = 'Order number is not available. Cannot track this order.';
            _isLoading = false;
          });
        }
        return;
      }

      final trackedOrder = await _ordersRepository.getTrackOrder(
        widget.order.orderNumber!,
      );

      if (mounted) {
        setState(() {
          _trackedOrder = trackedOrder;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Failed to load order tracking';

        // Parse DioException to extract user-friendly error message
        if (e is DioException) {
          final response = e.response;
          if (response != null) {
            final data = response.data;

            // Extract error message from response
            String? apiMessage;
            if (data is Map<String, dynamic>) {
              apiMessage =
                  data['message'] as String? ?? data['error'] as String?;
            } else if (data is String) {
              apiMessage = data;
            }

            // Handle specific status codes with user-friendly messages
            if (response.statusCode == 404) {
              errorMessage =
                  apiMessage ??
                  'Order not found. Please verify the order number and try again.';
            } else if (response.statusCode == 401) {
              errorMessage = apiMessage ?? 'Please log in to track your order.';
            } else if (response.statusCode == 403) {
              errorMessage =
                  apiMessage ??
                  'You do not have permission to track this order.';
            } else if (response.statusCode != null) {
              // Use API message if available, otherwise generic error
              errorMessage =
                  apiMessage ??
                  'An error occurred while tracking your order. Please try again.';
            }
          } else {
            // Network or connection error (no response)
            if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.sendTimeout) {
              errorMessage =
                  'Connection timeout. Please check your internet connection and try again.';
            } else if (e.type == DioExceptionType.connectionError) {
              errorMessage =
                  'Unable to connect to the server. Please check your internet connection and try again.';
            } else {
              errorMessage =
                  'Network error. Please check your internet connection and try again.';
            }
          }
        } else {
          // Generic exception - use a user-friendly message
          final errorString = e.toString();
          if (errorString.contains('Order not found') ||
              errorString.contains('404')) {
            errorMessage =
                'Order not found. Please verify the order number and try again.';
          } else {
            errorMessage = 'An unexpected error occurred. Please try again.';
          }
        }

        setState(() {
          _error = errorMessage;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          OrdersStrings.trackOrder,
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
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load order tracking',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _loadTrackOrder,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        spacing: 16,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: widget.order.productImage,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.image_outlined, size: 40),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.productName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedCircle,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                      size: 10,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.order.color,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                      child: VerticalDivider(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.3),
                                        thickness: 1,
                                        width: 16,
                                      ),
                                    ),
                                    Text(
                                      '${OrdersStrings.size} = ${widget.order.size}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                      child: VerticalDivider(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.3),
                                        thickness: 1,
                                        width: 16,
                                      ),
                                    ),
                                    Text(
                                      '${OrdersStrings.qty} = ${widget.order.quantity}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.order.price.toNGN(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tracking Status Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTrackingIcon(
                        context,
                        HugeIcons.strokeRoundedPackage,
                        widget.order.statusDetails.isNotEmpty &&
                            widget.order.statusDetails[0].isCompleted,
                      ),
                      _buildTrackingIcon(
                        context,
                        HugeIcons.strokeRoundedDeliveryTruck02,
                        widget.order.statusDetails.length > 1 &&
                            widget.order.statusDetails[1].isCompleted,
                      ),
                      _buildTrackingIcon(
                        context,
                        HugeIcons.strokeRoundedInboxCheck,
                        widget.order.statusDetails.length > 2 &&
                            widget.order.statusDetails[2].isCompleted,
                      ),
                      _buildTrackingIcon(
                        context,
                        HugeIcons.strokeRoundedCheckmarkBadge02,
                        widget.order.status == OrderStatus.completed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Current Status Text
                  Center(
                    child: Text(
                      _trackedOrder?.status ??
                          widget.order.currentTrackingStatus,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Order Number (if available)
                  if (_trackedOrder?.orderNumber != null) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Order #${_trackedOrder!.orderNumber}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  // Order Status Details Header
                  Text(
                    OrdersStrings.orderStatusDetails,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Timeline
                  OrderStatusTimelineWidget(
                    statusDetails: widget.order.statusDetails,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTrackingIcon(
    BuildContext context,
    List<List<dynamic>> iconData,
    bool isCompleted,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isCompleted
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: HugeIcon(
              icon: iconData,
              color: isCompleted
                  ? theme.colorScheme.surface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isCompleted
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
