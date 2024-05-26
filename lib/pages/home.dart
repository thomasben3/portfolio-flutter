import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:thbensem_portfolio/components/introduction_slider.dart';
import 'package:thbensem_portfolio/components/skill_progress_indicator.dart';
import 'package:thbensem_portfolio/extensions/context.dart';
import 'package:thbensem_portfolio/extensions/list.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late final AnimationController  _animationController = AnimationController(vsync: this);
  late Animation                  _animation;
  final ScrollController          _scrollController = ScrollController();
  final ScrollController          _presentationController = ScrollController();
  final GlobalKey                 _wrapKey = GlobalKey();
  final GlobalKey                 _secondPhaseKey = GlobalKey();

  double _scrollOffset = 0;

  double get        _firstPhaseLength => MediaQuery.of(context).size.height;
  double get        _secondPhaseLength => (_secondPhaseHeight ?? 0) - _firstContainerHeight + max(0, ((_wrapHeight ?? 0) - MediaQuery.of(context).size.height));
  List<double> get  _phasesLength => [
    _firstPhaseLength,
    _secondPhaseLength
  ];
  double get        _firstPhaseIndicatorValue => min(_scrollOffset / _firstPhaseLength, 1);

  double? get _wrapHeight => (_wrapKey.currentContext?.findRenderObject() as RenderBox?)?.size.height;
  double? get _secondPhaseHeight => (_secondPhaseKey.currentContext?.findRenderObject() as RenderBox?)?.size.height;
  double get  _firstContainerHeight => max(MediaQuery.of(context).size.height / 2 - (_wrapHeight ?? 0) / 2, 80);

  @override
  void initState() {
    super.initState();
    _animationController.addListener(() {
      setState(() {
        _scrollOffset = _animation.value;
        _manageScrollOffset(0); // Update scroll position based on _scrollOffset
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _presentationController.dispose();

    super.dispose();
  }

  void _manageScrollOffset(double dy) {
    setState(() => 
      _scrollOffset = clampDouble(
        _scrollOffset + dy,
        0,
        _phasesLength.sum
      )
    );

    if (_scrollOffset <= _firstPhaseLength) {
      if (_scrollController.position.pixels != _scrollController.position.minScrollExtent) _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      _presentationController.jumpTo(_scrollOffset);
    } else if (_scrollOffset <= _phasesLength.sublist(0, 2).sum) {
      if (_presentationController.position.pixels != _presentationController.position.maxScrollExtent) _presentationController.jumpTo(_presentationController.position.maxScrollExtent);
      _scrollController.position.jumpTo(_scrollOffset - _firstPhaseLength);
    }
  }

  void _onPointerSignal(event) {
    if (event is PointerScrollEvent) {
      _manageScrollOffset(event.scrollDelta.dy);
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _manageScrollOffset(-details.delta.dy);
  }

  // All this function is meant to manage scroll inertia on mobile navigator.
  void _onVerticalDragEnd(DragEndDetails details) {

    final FrictionSimulation simulation = FrictionSimulation(
      0.7, // <- the bigger this value, the less friction is applied
      _scrollOffset,
      -details.velocity.pixelsPerSecond.dy / 10 // <- Velocity of inertia
    );

    _animationController.duration = Duration(
      milliseconds: (simulation.timeAtX(simulation.x(double.infinity)) * 100).toInt(),
    );

    _animation = Tween<double>(
      begin: _scrollOffset,
      end: simulation.x(double.infinity),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.decelerate));

    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.read<AppTheme>().color1,
      body: Listener(
        onPointerSignal: _onPointerSignal,
        child: GestureDetector(
          onVerticalDragStart: context.isTouchDevice ? (d) => _animationController.stop() : null,
          onVerticalDragUpdate: context.isTouchDevice ? _onVerticalDragUpdate : null,
          onVerticalDragEnd: context.isTouchDevice ? _onVerticalDragEnd : null,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            child: Stack(
              children: [
                Column(
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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                          TypewriterAnimatedText(
                            'Compétences',
                            speed: const Duration(milliseconds: 250),
                            textStyle: TextStyle(
                              fontSize: 25,
                              color: context.read<AppTheme>().textColor1,
                              fontWeight: FontWeight.bold,
                              // shadows: [Shadow(blurRadius: 1)]
                            )
                          )
                        ]),
                      )
                    ),
                    Column(
                      children: [
                        Padding(
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
                              SkillProgressIndicator(label: 'C', imageName: 'c.png', finalValue: 0.90, value: _firstPhaseIndicatorValue),
                              SkillProgressIndicator(label: 'C++', imageName: 'cpp.png', finalValue: 0.60, value: _firstPhaseIndicatorValue),
                              SkillProgressIndicator(label: 'HTML / CSS / JS', imageName: 'web.png', finalValue: 0.75, value: _firstPhaseIndicatorValue),
                              SkillProgressIndicator(label: 'Node js', imageName: 'node.png', finalValue: 0.7, value: _firstPhaseIndicatorValue),
                              SkillProgressIndicator(label: 'React', imageName: 'react.png', finalValue: 0.7, value: _firstPhaseIndicatorValue),
                              SkillProgressIndicator(label: 'Dart / Flutter', imageName: 'flutter.png', finalValue: 0.85, value: _firstPhaseIndicatorValue),
                              SkillProgressIndicator(label: 'php', imageName: 'php.png', finalValue: 0.55, value: _firstPhaseIndicatorValue),
                              SkillProgressIndicator(label: 'SQL', imageName: 'sql.png', finalValue: 0.65, value: _firstPhaseIndicatorValue),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: max(0, MediaQuery.of(context).size.height - (_wrapHeight ?? 0) - _firstContainerHeight)),
                      key: _secondPhaseKey,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: context.read<AppTheme>().color2,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                          topRight: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                        )
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Une des premières choses que j'ai appris à propos de informatique, c'est qu'il faut apprendre à apprendre",
                                    style: TextStyle(color: context.read<AppTheme>().textColor1, fontFamily: 'VictorianBritania', fontSize: 20)
                                  ).animate(
                                    effects: [
                                      MoveEffect(
                                        begin: Offset(-MediaQuery.of(context).size.width * 0.35, 0),
                                        end: Offset.zero
                                      )
                                    ],
                                    autoPlay: false,
                                    value: _scrollOffset / _firstPhaseLength
                                  ),
                                )
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Apprentissage continu", style: TextStyle(color: context.read<AppTheme>().textColor1, fontSize: 20)),
                                  CustomProgressIndicator(value: _scrollOffset / _firstPhaseLength)
                                ],
                              ),
                            ],
                          ),
                          Text('mdr'),
                          SizedBox(height: 5000)
                        ],
                      ),
                    ),
                  ],
                ),
                IntroductionSlider(presentationController: _presentationController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
