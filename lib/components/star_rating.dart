import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';

class StarRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;
  final IconData filledStar;
  final IconData unfilledStar;
  final double size;

  const StarRating({
    Key key,
    @required this.onChanged,
    this.value = 1,
    this.size = 36.00,
    this.filledStar,
    this.unfilledStar,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = kPrimaryColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return SizedBox(
          width: size,
          child: IconButton(
            onPressed: onChanged != null
                ? () {
                    onChanged(index + 1);
                  }
                : null,
            color: index < value ? color : null,
            iconSize: size,
            icon: Icon(
              index < value
                  ? filledStar ?? Icons.star
                  : unfilledStar ?? Icons.star_border,
              color: kPrimaryColor,
            ),
            padding: EdgeInsets.zero,
            tooltip: "${index + 1} of 5",
          ),
        );
      }),
    );
  }
}
