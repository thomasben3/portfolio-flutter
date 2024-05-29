import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';

class SkillProgressIndicator extends StatelessWidget {
  const SkillProgressIndicator({
    super.key,
    required this.label,
    required this.imageName,
    required this.value,
    required this.finalValue,
  });

  final String? label;
  final String  imageName;
  final double  value;
  final double  finalValue;

  static const double width = 200;
  static const double height = 80;
  static const double _progressIndicatorHeight = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.read<AppTheme>().color0,
        borderRadius: BorderRadius.circular(8),
      ),
      width: width,
      height: height,
      child: Row(
        children: [
          SizedBox(width: width / 4, child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/programming_languages/$imageName'),
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (label != null)
                Text(label!, style: TextStyle(color: context.read<AppTheme>().textColor0)),
              SizedBox(
                width: (width / 4) * 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: LinearProgressIndicator(
                    color: context.read<AppTheme>().color1,
                    backgroundColor: const Color.fromARGB(255, 185, 185, 185),
                    minHeight: _progressIndicatorHeight,
                    borderRadius: BorderRadius.circular(height + width),
                    value: value * finalValue,
                  ),
                )
              ),
              const SizedBox(height: (height / 2) - (_progressIndicatorHeight / 2))
            ]
          )
        ],
      )
    );
  }
}

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
    required this.value
  });

  final double value;

  static const double width = 250;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Container(
          height: 10,
          width: width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 185, 185, 185),
            borderRadius: BorderRadius.circular(50)
          ),
        ),
        Container(
          height: 10,
          width: clampDouble(width * value, 0, MediaQuery.of(context).size.width),
          decoration: BoxDecoration(
            color: context.read<AppTheme>().color1,
            borderRadius: BorderRadius.circular(50)
          ),
        ),
      ],
    );
  }
}
