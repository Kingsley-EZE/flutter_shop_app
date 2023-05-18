import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DottedDivider({
    this.thickness = 1.0,
    this.color = Colors.grey,
    this.dashWidth = 3.0,
    this.dashSpace = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: thickness,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
