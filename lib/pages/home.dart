import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:thbensem_portfolio/components/introduction_slider.dart';
import 'package:thbensem_portfolio/components/skill_progress_indicator.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';
import 'package:thbensem_portfolio/utils/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final GlobalKey                 _wrapKey = GlobalKey();
  final GlobalKey                 _secondPhaseKey = GlobalKey();

  bool  _mounted = false;

  double? get _wrapHeight => _mounted ? (_wrapKey.currentContext?.findRenderObject() as RenderBox?)?.size.height : 0;

  double get  _firstContainerHeight => max(MediaQuery.of(context).size.height / 2 - (_wrapHeight ?? 0) / 2, 80);
  double? get _secondPhaseHeight => _mounted ? (_secondPhaseKey.currentContext?.findRenderObject() as RenderBox?)?.size.height : 0;
  bool get    _isSmallWindow => MediaQuery.of(context).size.width < 600;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _mounted = true);
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() {});
      });
    });
  }

  double _calculateAnimationValue(final BuildContext context, final double scrollOffset, {final bool hasMax = true}) {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null) return 0;
  
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
    final RevealedOffset revealedOffset = viewport.getOffsetToReveal(renderObject, 0.0);
    final double verticalPosition = revealedOffset.offset;
  
    final double screenHeight = MediaQuery.of(context).size.height;
    final double adjustedDy = verticalPosition - (screenHeight * 1.5);  // Adjusting dy to be relative to the low-center of the screen
  
    final double value = (scrollOffset - adjustedDy) / screenHeight;  // Calculate value based on adjustedDy
  
    if (hasMax) {
      return clampDouble(value, 0, 1);
    }
    return max(0, value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.read<AppTheme>().color2,
      body: ScrollTransformView(
        children: [
          ScrollTransformItem(
            key: _secondPhaseKey,
            builder: (scrollOffset) => Ink(
              color: context.read<AppTheme>().color1,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: _firstContainerHeight,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: context.read<AppTheme>().color2,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                        bottomRight: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                      )
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: _TypewriterTitle("Compétences"),
                    )
                  ),
                  _SkillsWrap(wrapKey: _wrapKey, value: min(1, scrollOffset / MediaQuery.of(context).size.height)),
                  _ContinuousLearning(calculacteAnimationValue: _calculateAnimationValue, isSmallWindow: _isSmallWindow, scrollOffset: scrollOffset)
                ],
              ),
            ),
            offsetBuilder: (scrollOffset) => Offset(0, min(scrollOffset, MediaQuery.of(context).size.height)),
          ),
          ScrollTransformItem(
            builder: (scrollOffset) => const IntroductionSlider(),
            offsetBuilder: (scrollOffset) => Offset(0, -(_secondPhaseHeight ?? 0)),
          ),
          ScrollTransformItem(
            builder: (scrollOffset) => Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: context.read<AppTheme>().color3,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                  topRight: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                )
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: _TypewriterTitle('Projets'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            padding: const EdgeInsets.only(top: 15, bottom: 15, right: 15, left: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                            ),
                            child: FittedBox(child: Image.asset('assets/images/42.png')),
                          ),
                          const SizedBox(height: 20),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: min(MediaQuery.of(context).size.width, 500)),
                            child: Text(
                              "A l'école 42, située à Paris, j'ai réalisé des projets variés",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: context.read<AppTheme>().textColor1, fontFamily: 'VictorianBritania', fontSize: 20)
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Builder(
                    builder: (bContext) => Project(
                      title: 'Cub3d',
                      imagePath: 'assets/images/cub3d.gif',
                      description: "Ce projet réalisé en 2022 est un moteur de ray-casting entièrement réalisé en C.",
                      url: "https://github.com/thomasben3/cub3d"
                    ).animate(
                      effects: const [FadeEffect(), ScaleEffect()],
                      autoPlay: false,
                      value: _calculateAnimationValue(bContext, scrollOffset)
                    )
                  ),
                  const SizedBox(height: 50),
                  Builder(
                    builder: (bContext) => Project(
                      reverse: true,
                      title: 'ft_transcendance',
                      imagePath: 'assets/images/pong.png',
                      description: "Projet final du tronc commun de 42. Effectué en groupe, il s'agit d'une application web de jeu pong en ligne",
                      url: "https://github.com/thomasben3/ft_transcendence"
                    ).animate(
                      effects: const [FadeEffect(), ScaleEffect()],
                      autoPlay: false,
                      value: _calculateAnimationValue(bContext, scrollOffset)
                    )
                  ),
                  const SizedBox(height: 2000)
                  // Text("2022")
                ],
              ),
            ),
            offsetBuilder: (scrollOffset) => Offset(0, 400 - min(400, scrollOffset - (_secondPhaseHeight ?? 0))),
          ),
        ]
      ),
    );
  }
}

class Project extends StatelessWidget {
  const Project({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.url,
    this.reverse = false
  });

  final String  title;
  final String  imagePath;
  final String  description;
  final String  url;
  final bool    reverse;

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
  
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  
    return hslDark.toColor();
  }

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
              Image.asset(imagePath, width: 170),
              const SizedBox(width: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(description, style: TextStyle(color: context.read<AppTheme>().textColor1, fontSize: 17))
              )
            ]..sort((a, b) => reverse ? 1 : -1),
          ),
          const SizedBox(height: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => launch(url),
              child: Icon(MdiIcons.github, color: context.read<AppTheme>().textColor1, size: 30)
            ),
          )
        ],
      ),
    );
  }
}

class _TypewriterTitle extends StatelessWidget {
  const _TypewriterTitle(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(repeatForever: true, animatedTexts: [
      TypewriterAnimatedText(
        data,
        speed: const Duration(milliseconds: 250),
        textStyle: TextStyle(
          fontSize: 25,
          color: context.read<AppTheme>().textColor1,
          fontWeight: FontWeight.bold,
        )
      )
    ]);
  }
}

class _SkillsWrap extends StatelessWidget {
  const _SkillsWrap({
    required GlobalKey<State<StatefulWidget>> wrapKey,
    required double value,
  }) : _wrapKey = wrapKey, _value = value;

  final GlobalKey<State<StatefulWidget>> _wrapKey;
  final double _value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: _wrapKey,
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: MediaQuery.of(context).size.width * 0.15
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runAlignment: WrapAlignment.center,
        spacing: MediaQuery.of(context).size.width * 0.05,
        runSpacing: MediaQuery.of(context).size.width < 620 ? 15 : 80,
        children: [
          SkillProgressIndicator(label: 'C', imageName: 'c.png', finalValue: 0.90, value: _value),
          SkillProgressIndicator(label: 'C++', imageName: 'cpp.png', finalValue: 0.60, value: _value),
          SkillProgressIndicator(label: 'HTML / CSS / JS', imageName: 'web.png', finalValue: 0.75, value: _value),
          SkillProgressIndicator(label: 'Node js', imageName: 'node.png', finalValue: 0.7, value: _value),
          SkillProgressIndicator(label: 'React', imageName: 'react.png', finalValue: 0.7, value: _value),
          SkillProgressIndicator(label: 'Dart / Flutter', imageName: 'flutter.png', finalValue: 0.85, value: _value),
          SkillProgressIndicator(label: 'php', imageName: 'php.png', finalValue: 0.55, value: _value),
          SkillProgressIndicator(label: 'SQL', imageName: 'sql.png', finalValue: 0.65, value: _value),
        ],
      ),
    );
  }
}

class _ContinuousLearning extends StatelessWidget {
  const _ContinuousLearning({
    required double Function(BuildContext, double, {bool hasMax})  calculacteAnimationValue,
    required bool                                   isSmallWindow,
    required this.scrollOffset
  }) :
  _calculateAnimationValue = calculacteAnimationValue,
  _isSmallWindow = isSmallWindow;

  final double Function(BuildContext, double, {bool hasMax}) _calculateAnimationValue;
  final bool                                  _isSmallWindow;
  final double                                scrollOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: context.read<AppTheme>().color2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
          topRight: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * (_isSmallWindow ? 0.7 : 0.25),
                child: Builder(
                  builder: (bContext) {
    
                    return Text(
                      "Une des premières choses que j'ai appris à propos de informatique, c'est qu'il ne faut jamais arrêter d'apprendre.",
                      style: TextStyle(color: context.read<AppTheme>().textColor1, fontFamily: 'VictorianBritania', fontSize: 20)
                    ).animate(
                      effects: [
                        MoveEffect(
                          begin: Offset(-MediaQuery.of(context).size.width, 0),
                          end: Offset.zero
                        )
                      ],
                      autoPlay: false,
                      value: _calculateAnimationValue(bContext, scrollOffset)
                    );
                  }
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Apprentissage continu", style: TextStyle(color: context.read<AppTheme>().textColor1, fontSize: 20)),
                    Container(
                      alignment: Alignment.centerLeft,
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * (_isSmallWindow ? 0.75 : 0.5)),
                      child: Builder(
                        builder: (bContext) => CustomProgressIndicator(value: _calculateAnimationValue(bContext, scrollOffset, hasMax: false))
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}