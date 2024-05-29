import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';
import 'package:thbensem_portfolio/utils/animation_value.dart';
import 'package:thbensem_portfolio/utils/url_launcher.dart';

class AnimatedProject extends StatelessWidget {
  const AnimatedProject({
    super.key,
    required this.title,
    required this.imagePath,
    this.imageWidth,
    required this.description,
    this.url,
    required this.scrollOffset,
    this.reverse = false
  });

  final String  title;
  final String  imagePath;
  final double? imageWidth;
  final String  description;
  final String? url;
  final double  scrollOffset;
  final bool    reverse;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (bContext) {
        return Project(
          title: title,
          imagePath: imagePath,
          imageWidth: imageWidth,
          description: description,
          reverse: reverse,
          url: url
        ).animate(
          effects: const [FadeEffect(), ScaleEffect()],
          autoPlay: false,
          value: calculateAnimationValue(bContext, scrollOffset)
        );
      }
    );
  }
}

class Project extends StatelessWidget {
  const Project({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    this.url,
    this.reverse = false,
    double? imageWidth
  }) : _imageWidth = imageWidth ?? 170;

  final String  title;
  final String  imagePath;
  final String  description;
  final String? url;
  final bool    reverse;

  final double  _imageWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: context.read<AppTheme>().color2,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: context.read<AppTheme>().textColor1, fontSize: 20)),
          Container(width: 80, height: 1, color: context.read<AppTheme>().textColor1),
          const SizedBox(height: 15),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, width: _imageWidth),
              const SizedBox(width: 20),
              ConstrainedBox(
                /* Here the last max() constraints is to keep the same total width as the default size even when _imageWidth change (default is 170) */
                constraints: BoxConstraints(maxWidth: min(MediaQuery.of(context).size.width - (_imageWidth + 20 + 32), 200 + max(0, 170 - _imageWidth))),
                child: Text(description, style: TextStyle(color: context.read<AppTheme>().textColor1, fontSize: 17))
              )
            ]..sort((a, b) => reverse ? -1 : 1),
          ),
          if (url != null) ...[
            const SizedBox(height: 10),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => launch(url!),
                child: Icon(MdiIcons.github, color: context.read<AppTheme>().textColor1, size: 30)
              ),
            )
          ]
        ],
      ),
    );
  }
}

class ProjectListHeader extends StatelessWidget {
  const ProjectListHeader({
    super.key,
    required this.imagePath,
    required this.description,
    this.mainAxisAlignment = MainAxisAlignment.end
  });

  final String            imagePath;
  final String            description;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
                child: FittedBox(child: Image.asset(imagePath)),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: min(MediaQuery.of(context).size.width * 0.8, 500)),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.read<AppTheme>().textColor1, fontFamily: 'VictorianBritania', fontSize: 20)
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}