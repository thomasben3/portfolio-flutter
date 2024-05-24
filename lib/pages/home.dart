import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:thbensem_portfolio/components/skill_progress_indicator.dart';
import 'package:thbensem_portfolio/extensions/context.dart';
import 'package:thbensem_portfolio/extensions/list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final ScrollController          _scrollController = ScrollController();
  final ScrollController          _presentationController = ScrollController();

  double _scrollOffset = 0;

  double get        _firstPhaseLength => MediaQuery.of(context).size.height;
  double get        _secondPhaseLength => MediaQuery.of(context).size.height;
  List<double> get  _phasesLength => [
    _firstPhaseLength,
    _secondPhaseLength
  ];
  double get        _secondPhaseIndicatorValue => (_scrollOffset - _firstPhaseLength) / _secondPhaseLength;

  @override
  void initState() {
    super.initState();

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

    if (_scrollOffset < _firstPhaseLength) {
      // if (_scrollController.position.pixels != _scrollController.position.minScrollExtent) _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      _presentationController.jumpTo(_scrollOffset);
    } else if (_scrollOffset < _phasesLength.sublist(0, 2).sum) {
      if (_presentationController.position.pixels != _presentationController.position.maxScrollExtent) _presentationController.jumpTo(_presentationController.position.maxScrollExtent);
      // _scrollController.position.jumpTo(_scrollOffset - MediaQuery.of(context).size.height);
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerSignal: _onPointerSignal,
        child: GestureDetector(
          onVerticalDragUpdate: context.isTouchDevice ? _onVerticalDragUpdate : null,
          onVerticalDragEnd: context.isTouchDevice ? _onVerticalDragEnd : null,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          alignment: WrapAlignment.spaceAround,
                          runAlignment: WrapAlignment.center,
                          spacing: 100,
                          runSpacing: 80,
                          children: [
                            SkillProgressIndicator(label: 'C', imageName: 'c.png', finalValue: 0.90, value: _secondPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'C++', imageName: 'cpp.png', finalValue: 0.60, value: _secondPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'HTML / CSS / JS', imageName: 'moi.png', finalValue: 0.75, value: _secondPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'Node js', imageName: 'node.png', finalValue: 0.7, value: _secondPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'React', imageName: 'react.png', finalValue: 0.7, value: _secondPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'Dart / Flutter', imageName: 'moi.png', finalValue: 0.85, value: _secondPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'php', imageName: 'php.png', finalValue: 0.55, value: _secondPhaseIndicatorValue),
                            SkillProgressIndicator(label: 'SQL', imageName: 'sql.png', finalValue: 0.65, value: _secondPhaseIndicatorValue),
                          ],
                        ),
                      )
                    ),
                    _IntroductionSlider(presentationController: _presentationController),
                  ],
                ),
                Container(height: 200, color: Colors.green,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroductionSlider extends StatelessWidget {
  const _IntroductionSlider({
    required ScrollController presentationController,
  }) : _presentationController = presentationController;

  final ScrollController _presentationController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _presentationController,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 2,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 34, 126, 192),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width / 2),
                    bottomLeft: Radius.elliptical(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width / 2)
                  )
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width / 2),
                    bottomLeft: Radius.elliptical(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width / 2)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: min(MediaQuery.of(context).size.height, 300),
                        width: MediaQuery.of(context).size.width,
                        child: /* if mediaquery.width < 822 */ Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/images/moi.png', height: min(MediaQuery.of(context).size.height, 300)),
                            Positioned(
                              bottom: 30,
                              width: MediaQuery.of(context).size.width - 16,
                              left: 8,
                              child: const Column(
                                children: [
                                  FittedBox(child: Text('Thomas Bensemhoun', style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: 'VictorianBritania'))),
                                  Text('Developper', style: TextStyle(color: Colors.white, fontSize: 35)),
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}