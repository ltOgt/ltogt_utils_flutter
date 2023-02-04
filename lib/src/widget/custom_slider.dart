import 'package:flutter/widgets.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

/// Config for a slider whose handle offset is at the start in respect to the used axis.
class SliderConfig {
  final double minValue;
  final double maxValue;

  final double sliderMainAxisSize;
  final double handleMainAxisSize;
  final double sliderCrossAxisSize;
  final double handleCrossAxisSize;

  final double minOffset = 0;
  final double maxOffset;

  const SliderConfig({
    required this.minValue,
    required this.maxValue,
    required this.sliderMainAxisSize,
    required this.handleMainAxisSize,
    required this.sliderCrossAxisSize,
    required this.handleCrossAxisSize,
  }) : this.maxOffset = sliderMainAxisSize - handleMainAxisSize;

  double valueToOffset(double value) => NumHelper.rescale(
        value: value,
        min: minValue,
        max: maxValue,
        newMin: minOffset,
        newMax: maxOffset,
        enforceOldBounds: true,
        enforceNewBounds: true,
      );

  double offsetToValue(double position) => NumHelper.rescale(
        value: position,
        newMin: minValue,
        newMax: maxValue,
        min: minOffset,
        max: maxOffset,
        enforceOldBounds: true,
        enforceNewBounds: true,
      );
}

// TODO move the axis stuff from here into slider config
class CustomSlider extends StatelessWidget {
  const CustomSlider({
    Key? key,
    required this.value,
    required this.sliderConfig,
    required this.handle,
    required this.sliderBefore,
    required this.sliderAfter,
    required this.onUpdateValue,
    this.axisDirection = AxisDirection.right,
  }) : super(key: key);

  final double value;

  final SliderConfig sliderConfig;

  final Widget handle;
  final Widget sliderBefore;
  final Widget sliderAfter;

  final AxisDirection axisDirection;

  final void Function(double value) onUpdateValue;

  double get handleLengthHalf => sliderConfig.handleMainAxisSize / 2;

  bool get isHorizontal => axisDirection == AxisDirection.right || axisDirection == AxisDirection.left;
  bool get isReverse => (axisDirection == AxisDirection.left || axisDirection == AxisDirection.up);
  void onLocalPosition(Offset localPosition) {
    final offsetOnAxis = isHorizontal ? localPosition.dx : localPosition.dy;
    final offsetDirectional = isReverse ? sliderConfig.sliderMainAxisSize - offsetOnAxis : offsetOnAxis;
    final value = sliderConfig.offsetToValue(offsetDirectional - handleLengthHalf);
    onUpdateValue(value);
  }

  @override
  Widget build(BuildContext context) {
    final handleOffset = sliderConfig.valueToOffset(value);

    // before and after meet on the half point of the handle
    // for cases like circular handles etc where you can see under the handle
    final sbLength = handleOffset + handleLengthHalf;

    return GestureDetector(
      onTapDown: (details) => onLocalPosition(details.localPosition),
      onPanUpdate: (details) => onLocalPosition(details.localPosition),
      child: SizedBoxAxis(
        mainAxisSize: sliderConfig.sliderMainAxisSize,
        crossAxisSize: sliderConfig.sliderCrossAxisSize,
        axis: axisDirectionToAxis(axisDirection),
        child: Stack(
          children: [
            PositionedDirectionalX.directional(
              axisDirection: axisDirection,
              child: sliderBefore,
              start: 0,
              mainAxisLength: sbLength,
              left: 0,
              right: 0,
            ),
            PositionedDirectionalX.directional(
              axisDirection: axisDirection,
              child: sliderAfter,
              start: sbLength,
              end: 0,
              left: 0,
              right: 0,
            ),
            PositionedDirectionalX.directional(
              axisDirection: axisDirection,
              child: Center(
                child: SizedBoxAxis(
                  mainAxisSize: sliderConfig.handleMainAxisSize,
                  crossAxisSize: sliderConfig.handleCrossAxisSize,
                  axis: axisDirectionToAxis(axisDirection),
                  child: handle,
                ),
              ),
              mainAxisLength: sliderConfig.handleMainAxisSize,
              crossAxisLength: sliderConfig.handleCrossAxisSize,
              start: handleOffset,
            )
          ],
        ),
      ),
    );
  }
}
