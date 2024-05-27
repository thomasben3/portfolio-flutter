import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';

class IntroductionSlider extends StatelessWidget {
  const IntroductionSlider({ super.key });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: context.read<AppTheme>().color1,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.elliptical(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width / 2),
                bottomLeft: Radius.elliptical(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width / 2)
              ),
              boxShadow: const [BoxShadow(blurRadius: 10)]
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
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.25,
                          width: min(400, MediaQuery.of(context).size.width),
                          child: FittedBox(
                            child: Container(
                              color: context.read<AppTheme>().color0,
                              child: TextLiquidFill(
                                boxWidth: 800,
                                boxBackgroundColor: context.read<AppTheme>().color1,
                                waveColor: context.read<AppTheme>().color2,
                                loadDuration: Duration.zero,
                                loadUntil: 0.45,
                                text: 'Portfolio'
                              ),
                            ),
                          ),
                        ),
                        Align(alignment: Alignment.bottomCenter, child: Image.asset('assets/images/moi.png', height: min(MediaQuery.of(context).size.height, 300))),
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
    );
  }
}