import 'dart:math';

import 'package:flutter/material.dart';

class IntroductionSlider extends StatelessWidget {
  const IntroductionSlider({
    super.key,
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