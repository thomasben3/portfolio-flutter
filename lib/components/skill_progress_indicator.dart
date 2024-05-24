import 'package:flutter/material.dart';

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
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.7))]
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
                Text(label!),
              SizedBox(
                width: (width / 4) * 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: LinearProgressIndicator(
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