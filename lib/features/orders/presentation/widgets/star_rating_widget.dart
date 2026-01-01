import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({
    required this.onRatingChanged,
    this.initialRating = 0,
    this.starSize = 48,
    super.key,
  });

  final void Function(int rating) onRatingChanged;
  final int initialRating;
  final double starSize;

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _setRating(int rating) {
    setState(() {
      _currentRating = rating;
    });
    widget.onRatingChanged(rating);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isFilled = starNumber <= _currentRating;

        return GestureDetector(
          onTap: () => _setRating(starNumber),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: HugeIcon(
              icon: isFilled
                  ? HugeIcons.strokeRoundedStar
                  : HugeIcons.strokeRoundedStar,
              color: isFilled
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.2),
              size: widget.starSize,
            ),
          ),
        );
      }),
    );
  }
}
