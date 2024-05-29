import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:thbensem_portfolio/components/expanding_menu.dart';
import 'package:thbensem_portfolio/components/home/project.dart';
import 'package:thbensem_portfolio/components/home/introduction_slider.dart';
import 'package:thbensem_portfolio/components/skill_progress_indicator.dart';
import 'package:thbensem_portfolio/extensions/list.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';
import 'package:thbensem_portfolio/utils/animation_value.dart';
import 'package:thbensem_portfolio/utils/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final GlobalKey                 _wrapKey = GlobalKey();
  final GlobalKey                 _secondPhaseKey = GlobalKey();
  final GlobalKey                 _thirdPhaseKey = GlobalKey();

  bool    _mounted = false;
  double  _scrollOffset = 0;

  double? get _wrapHeight => _mounted ? (_wrapKey.currentContext?.findRenderObject() as RenderBox?)?.size.height : 0;

  double? get _secondPhaseHeight => _mounted ? (_secondPhaseKey.currentContext?.findRenderObject() as RenderBox?)?.size.height : 0;
  double? get _thirdPhaseHeight => _mounted ? (_thirdPhaseKey.currentContext?.findRenderObject() as RenderBox?)?.size.height : 0;

  List<double> get _phasesLenght => [
    MediaQuery.of(context).size.height,
    _secondPhaseHeight ?? 0,
    _thirdPhaseHeight ?? 0
  ];

  Color get _backgroundColor {
    if (_scrollOffset > _phasesLenght.sublist(0, 2).sum) return context.read<AppTheme>().color3;
    return context.read<AppTheme>().color2;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // homeMade _mounted because the built-in one was too quick and cause errors when using globalKeys
      setState(() => _mounted = true);
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // if used to not refresh the state for every ScrollNotification received.
          if (notification.metrics.pixels > _phasesLenght.sublist(0, 2).sum && _scrollOffset < _phasesLenght.sublist(0, 2).sum
            || notification.metrics.pixels < _phasesLenght.sublist(0, 2).sum && _scrollOffset > _phasesLenght.sublist(0, 2).sum) {
            // This variable only purpose is to manage the backgroundColor according to the scrollView
            setState(() => _scrollOffset = notification.metrics.pixels);
          }
          return false ;
        },
        child: Stack(
          children: [
            ScrollTransformView(
              children: [
                ScrollTransformItem(
                  key: _secondPhaseKey,
                  builder: (scrollOffset) => Ink(
                    color: context.read<AppTheme>().color1,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: max(MediaQuery.of(context).size.height / 2 - (_wrapHeight ?? 0) / 2, 80), // <-- if wrapHeight < screenHeight then it's centered, otherwise there is 80 of height for the _TypewriterTitle
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: context.read<AppTheme>().color2,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                              bottomRight: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _TypewriterTitle(AppLocalizations.of(context)!.skills),
                          )
                        ),
                        _SkillsWrap(wrapKey: _wrapKey, value: min(1, scrollOffset / MediaQuery.of(context).size.height)),
                        Builder(
                          builder: (bContext) => _OtherTechnologies(
                            scrollOffset: scrollOffset,
                            value: MediaQuery.of(context).size.longestSide < 860 ? // <-- this check is to verify if the widget is present in the screen,
                              calculateAnimationValue(bContext, scrollOffset) //     if it is, we use the same animValue as SkillsWrap,
                              : min(1, scrollOffset / MediaQuery.of(context).size.height) // otherwise we use calculateAnimationValue.
                          )
                        ),
                        _ContinuousLearning(scrollOffset: scrollOffset)
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
                  key: _thirdPhaseKey,
                  builder: (scrollOffset) => Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: context.read<AppTheme>().color3,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                        topRight: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                      )
                    ),
                    child: _ProjectsList(scrollOffset: scrollOffset),
                  ),
                  offsetBuilder: (scrollOffset) => Offset(0, 500 - min(500, scrollOffset - (_secondPhaseHeight ?? 0))),
                ),
                ScrollTransformItem(
                  builder: (scrollOffset) => Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 35, bottom: 15, left: 15, right: 15),
                    height: 120,
                    decoration: BoxDecoration(
                      color: context.read<AppTheme>().color1,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                        topRight: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                      )
                    ),
                    child: const _BottomPage(),
                  ),
                  offsetBuilder: (scrollOffset) => Offset(0, 500 - min(500, (scrollOffset + (500 - 120)) - ((_secondPhaseHeight ?? 0) + (_thirdPhaseHeight ?? 0))))
                )
              ]
            ),
            Positioned(
              left: 8,
              top: 8,
              child: ExpandingMenu(refreshState: () => setState(() {}))
            )
          ],
        ),
      ),
    );
  }
}

class _BottomPage extends StatelessWidget {
  const _BottomPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(text: TextSpan(
          style: TextStyle(color: context.read<AppTheme>().textColor1),
          text: AppLocalizations.of(context)!.portfolioMadeWithFlutter,
          children: [
            TextSpan(
              text: 'https://github.com/thomasben3/portfolio-flutter',
              style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
              mouseCursor: SystemMouseCursors.click,
              recognizer: TapGestureRecognizer()..onTap = () => launch("https://github.com/thomasben3/portfolio-flutter")
            )
          ]
        )
      ),
      Text("© 2024 Thomas Bensemhoun", style: TextStyle(color: context.read<AppTheme>().textColor1))
    ]);
  }
}

class _ProjectsList extends StatelessWidget {
  const _ProjectsList({
    required this.scrollOffset
  });

  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: _TypewriterTitle(AppLocalizations.of(context)!.projects),
        ),
        ProjectListHeader(
          imagePath: 'assets/images/42.png',
          description: AppLocalizations.of(context)!.projectsOf42,
        ),
        const SizedBox(height: 25),
        AnimatedProject(
          scrollOffset: scrollOffset,
          title: 'Cub3d',
          imagePath: 'assets/images/projects/cub3d.gif',
          description: AppLocalizations.of(context)!.cub3dQuote,
          url: "https://github.com/thomasben3/cub3d"
        ),
        const SizedBox(height: 50),
        AnimatedProject(
          scrollOffset: scrollOffset,
          reverse: true,
          title: 'ft_transcendence',
          imagePath: 'assets/images/projects/pong.png',
          description: AppLocalizations.of(context)!.transcendenceQuote,
          url: "https://github.com/thomasben3/ft_transcendence"
        ),
        const SizedBox(height: 50),
        Builder(
          builder: (bContext) {
            return ProjectListHeader(
              mainAxisAlignment: MainAxisAlignment.start,
              imagePath: 'assets/images/office.png',
              description: AppLocalizations.of(context)!.professionalProject,
            ).animate(
              effects: const [ScaleEffect(), RotateEffect(begin: 0.5, alignment: Alignment.centerLeft)],
              autoPlay: false,
              value: calculateAnimationValue(bContext, scrollOffset)
            );
          }
        ),
        const SizedBox(height: 15),
        AnimatedProject(
          scrollOffset: scrollOffset,
          reverse: true,
          title: 'Isoclean',
          imagePath: 'assets/images/projects/isoclean.png',
          imageWidth: 80,
          description: AppLocalizations.of(context)!.isocleanQuote
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class _OtherTechnologies extends StatelessWidget {
  const _OtherTechnologies({
    required this.scrollOffset,
    required this.value,
  });

  final double scrollOffset;
  final double value;

  static const double       _imageHeight = 40;
  static final List<Image>  _technologies = [
    Image.asset('assets/images/technologies/docker.png', height: _imageHeight),
    Image.asset('assets/images/technologies/git.png', height: _imageHeight),
    Image.asset('assets/images/technologies/aws.png', height: _imageHeight)
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _technologies.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: _technologies[index]
        ).animate(
          effects: [MoveEffect(begin: Offset(MediaQuery.of(context).size.width * (index + 1), 0))],
          autoPlay: false,
          value: value
        )
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
        runSpacing: MediaQuery.of(context).size.width < 620 ? 15 : 60,
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
    required this.scrollOffset
  });

  final double  scrollOffset;


  @override
  Widget build(BuildContext context) {
    bool isSmallWindow() => MediaQuery.of(context).size.width < 600;

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
                width: MediaQuery.of(context).size.width * (isSmallWindow() ? 0.7 : 0.25),
                child: Builder(
                  builder: (bContext) {
    
                    return Text(
                      AppLocalizations.of(context)!.learningQuote,
                      style: TextStyle(color: context.read<AppTheme>().textColor1, fontFamily: 'VictorianBritania', fontSize: 20)
                    ).animate(
                      effects: [
                        MoveEffect(
                          begin: Offset(-MediaQuery.of(context).size.width, 0),
                          end: Offset.zero
                        )
                      ],
                      autoPlay: false,
                      value: calculateAnimationValue(bContext, scrollOffset)
                    );
                  }
                )
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.continuousLearning, style: TextStyle(color: context.read<AppTheme>().textColor1, fontSize: 20)),
                    Container(
                      alignment: Alignment.centerLeft,
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * (isSmallWindow() ? 0.75 : 0.5)),
                      child: Builder(
                        builder: (bContext) => CustomProgressIndicator(
                          value: MediaQuery.of(context).size.longestSide < 935 ? // <-- this check is to verify if the widget is present in the screen,
                            calculateAnimationValue(bContext, scrollOffset, hasMax: false) //     if it is, we use the same animValue as SkillsWrap,
                            : scrollOffset / MediaQuery.of(context).size.height // otherwise we use calculateAnimationValue.)
                        )
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