import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/add_promo_screen.dart';
import 'package:ahioma_food_template/features/orders/domain/repository/orders_repository.dart';
import 'package:ahioma_food_template/injection_container.dart';

class PromoCodeValidationResult {
  const PromoCodeValidationResult({
    required this.code,
    required this.isValid,
    this.discountAmount,
    this.discountType,
  });

  final String code;
  final bool isValid;
  final int? discountAmount;
  final String? discountType;
}

class CheckoutPromoCodeWidget extends StatefulWidget {
  const CheckoutPromoCodeWidget({
    this.selectedPromoCode,
    this.onPromoCodeChanged,
    required this.cartTotal,
    super.key,
  });

  final String? selectedPromoCode;
  final ValueChanged<PromoCodeValidationResult>? onPromoCodeChanged;
  final double cartTotal;

  @override
  State<CheckoutPromoCodeWidget> createState() =>
      _CheckoutPromoCodeWidgetState();
}

class _CheckoutPromoCodeWidgetState extends State<CheckoutPromoCodeWidget> {
  late final TextEditingController _controller;
  final OrdersRepository _ordersRepository = sl<OrdersRepository>();
  Timer? _debounceTimer;
  bool _isValidating = false;
  bool? _isValid;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedPromoCode ?? '');
    if (widget.selectedPromoCode != null &&
        widget.selectedPromoCode!.isNotEmpty) {
      _validatePromoCode(widget.selectedPromoCode!);
    }
  }

  @override
  void didUpdateWidget(CheckoutPromoCodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPromoCode != widget.selectedPromoCode) {
      _controller.text = widget.selectedPromoCode ?? '';
      if (widget.selectedPromoCode != null &&
          widget.selectedPromoCode!.isNotEmpty) {
        _validatePromoCode(widget.selectedPromoCode!);
      } else {
        setState(() {
          _isValid = null;
          _errorMessage = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _validatePromoCode(String code) async {
    if (code.isEmpty) {
      setState(() {
        _isValid = null;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isValidating = true;
      _isValid = null;
      _errorMessage = null;
    });

    try {
      // Convert cart total to integer (rounded to nearest whole number)
      final cartTotalInt = widget.cartTotal.round();
      final result = await _ordersRepository.validatePromoCode(
        promoCode: code,
        cartTotal: cartTotalInt.toString(),
      );

      if (mounted) {
        setState(() {
          _isValidating = false;
          _isValid = result.isValid ?? false;
          if (!(_isValid ?? false)) {
            _errorMessage = 'Invalid promo code. Please check and try again.';
          }
        });

        // Always notify parent about validation result (valid or invalid)
        if (widget.onPromoCodeChanged != null) {
          if (_isValid ?? false) {
            // Valid code - pass discount information
            widget.onPromoCodeChanged!(
              PromoCodeValidationResult(
                code: code,
                isValid: true,
                discountAmount: result.discount?.amount,
                discountType: result.discount?.type,
              ),
            );
          } else {
            // Invalid code - clear discount
            widget.onPromoCodeChanged!(
              PromoCodeValidationResult(code: code, isValid: false),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isValidating = false;
          _isValid = false;
          _errorMessage = 'Failed to validate promo code. Please try again.';
        });

        // Notify parent that validation failed - clear discount
        if (widget.onPromoCodeChanged != null) {
          widget.onPromoCodeChanged!(
            PromoCodeValidationResult(code: code, isValid: false),
          );
        }
      }
    }
  }

  void _onTextChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (value.isNotEmpty) {
        _validatePromoCode(value);
      } else {
        setState(() {
          _isValid = null;
          _errorMessage = null;
        });
        // Notify that promo code was cleared
        if (widget.onPromoCodeChanged != null) {
          widget.onPromoCodeChanged!(
            PromoCodeValidationResult(code: '', isValid: false),
          );
        }
      }
    });
  }

  Future<void> _handlePromoSelection() async {
    final result = await context.push<String?>(AddPromoScreen.path);
    if (result != null) {
      _controller.text = result;
      _validatePromoCode(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CheckoutStrings.promoCode,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _onTextChanged,
                decoration: InputDecoration(
                  hintText: CheckoutStrings.enterPromoCode,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _isValid == false
                          ? theme.colorScheme.error
                          : theme.colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _isValid == false
                          ? theme.colorScheme.error
                          : theme.colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _isValid == false
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  suffixIcon: _isValidating
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : _isValid == true
                      ? Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                        )
                      : _isValid == false
                      ? Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: AppIcons.arrowForward(color: Colors.white),
                onPressed: _handlePromoSelection,
              ),
            ),
          ],
        ),
        // Warning tooltip for invalid promo code
        if (_isValid == false && _errorMessage != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: theme.colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
