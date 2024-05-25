import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:thbensem_portfolio/components/introduction_slider.dart';
import 'package:thbensem_portfolio/components/skill_progress_indicator.dart';
import 'package:thbensem_portfolio/extensions/context.dart';
import 'package:thbensem_portfolio/extensions/list.dart';

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

  double _scrollOffset = 0;

  double get        _firstPhaseLength => MediaQuery.of(context).size.height;
  double get        _secondPhaseLength => MediaQuery.of(context).size.height;
  List<double> get  _phasesLength => [
    _firstPhaseLength,
    _secondPhaseLength
  ];
  double get        _firstPhaseIndicatorValue => min(_scrollOffset / _firstPhaseLength, 1);

  @override
  void initState() {
    super.initState();
    _animationController.addListener(() {
      setState(() {
        _scrollOffset = _animation.value;
        _manageScrollOffset(0); // Update scroll position based on _scrollOffset
      });
    });
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
      body: Listener(
        onPointerSignal: _onPointerSignal,
        child: GestureDetector(
          onVerticalDragStart: context.isTouchDevice ? (d) => _animationController.stop() : (d) => _animationController.stop(),
          onVerticalDragUpdate: context.isTouchDevice ? _onVerticalDragUpdate : _onVerticalDragUpdate,
          onVerticalDragEnd: context.isTouchDevice ? _onVerticalDragEnd : _onVerticalDragEnd,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
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
                            SkillProgressIndicator(label: 'HTML / CSS / JS', imageName: 'moi.png', finalValue: 0.75, value: _firstPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'Node js', imageName: 'node.png', finalValue: 0.7, value: _firstPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'React', imageName: 'react.png', finalValue: 0.7, value: _firstPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'Dart / Flutter', imageName: 'moi.png', finalValue: 0.85, value: _firstPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'php', imageName: 'php.png', finalValue: 0.55, value: _firstPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'SQL', imageName: 'sql.png', finalValue: 0.65, value: _firstPhaseIndicatorValue),
                          ],
                        ),
                      )
                    ),
                    IntroductionSlider(presentationController: _presentationController),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                      topRight: Radius.elliptical(MediaQuery.of(context).size.width / 2, 50),
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
