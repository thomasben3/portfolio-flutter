import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

double calculateAnimationValue(final BuildContext context, final double scrollOffset, {final bool hasMax = true}) {
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