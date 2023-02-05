// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:ltogt_utils/ltogt_utils.dart';

import 'package:ltogt_utils_flutter/src/extensions/axis_x.dart';
import 'package:ltogt_utils_flutter/src/extensions/positioned_directional_x.dart';
import 'package:ltogt_utils_flutter/src/widget/layout/sized_box_axis.dart';

// =============================================================================
// =============================================================================
// =============================================================================

/// {@template sliderConfig}
/// Config for a generic slider
/// whose handle offset is anchored to the handle start in respect to the used axis.
///
/// See [handleMainAxisSizeHalf].
/// {@endtemplate}
class SliderConfig {
  // ---------------------------------------------------------------------------

  /// The lower bound for the value that should be changed via the slider
  final double minValue;

  /// The upper bound for the value that should be changed via the slider
  final double maxValue;

  // ---------------------------------------------------------------------------

  /// The length of the entire slider in respect to the [axisDirection]
  final double sliderMainAxisSize;

  /// The width of the entire slider in respect to the [axisDirection]
  final double sliderCrossAxisSize;

  // ---------------------------------------------------------------------------

  /// The length of the dragable handle in respect to the [axisDirection]
  final double handleMainAxisSize;

  /// The width of the dragable handle in respect to the [axisDirection]
  final double handleCrossAxisSize;

  /// Half of [handleCrossAxisSize] which is used since the
  /// directional offsets are anchored on the start of the handle,
  /// while the gestures are expected to be centered on the handle instead.
  ///
  /// Also see
  /// - [valueToOffsetDirectional]
  /// - [offsetDirectionalToValue]
  /// - [minOffsetDirectional]
  /// - [maxOffsetDirectional]
  double get handleMainAxisSizeHalf => handleMainAxisSize / 2;

  /// Get the center offset for a given start offset,
  /// e.g. received via [valueToOffsetDirectional].
  double handleStartOffsetToCenterOffset(double handleOffsetStart) => //
      handleOffsetStart + handleMainAxisSizeHalf;

  // ---------------------------------------------------------------------------

  /// The minimum handle position in respect to [axisDirection].
  /// Is always zero and is anchored to the start of the handle.
  ///
  /// Also see [handleMainAxisSizeHalf].
  static const double minOffsetDirectional = 0;

  /// The maximum handle position in respect to [axisDirection].
  /// Is the slider length reduced by the handle length,
  /// since its anchored to the start of the handle.
  ///
  /// Also see [handleMainAxisSizeHalf].
  double get maxOffsetDirectional => sliderMainAxisSize - handleMainAxisSize;

  // ---------------------------------------------------------------------------

  /// The axis direction on which the slider should increase the value when dragged.
  final AxisDirection axisDirection;
  bool get isHorizontal => axisDirection.isHorizontal;
  bool get isReverse => axisDirection.isReverse;

  // ---------------------------------------------------------------------------

  /// {@macro sliderConfig}
  const SliderConfig({
    required this.minValue,
    required this.maxValue,
    required this.sliderMainAxisSize,
    required this.sliderCrossAxisSize,
    required this.handleMainAxisSize,
    required this.handleCrossAxisSize,
    required this.axisDirection,
  });

  // ---------------------------------------------------------------------------

  /// Convert the [value] into a directional offset
  /// in respect to [axisDirection] and handle start.
  double valueToOffsetDirectional(double value) => NumHelper.rescale(
        value: value,
        min: minValue,
        max: maxValue,
        newMin: minOffsetDirectional,
        newMax: maxOffsetDirectional,
        enforceOldBounds: true,
        enforceNewBounds: true,
      );

  /// Convert the [offsetDirectional] (in respect to [axisDirection] and handle start)
  /// into the corresponding value.
  ///
  /// You probably want to use [offsetLocalToValue] instead.
  double offsetDirectionalToValue(double offsetDirectional) => NumHelper.rescale(
        value: offsetDirectional,
        newMin: minValue,
        newMax: maxValue,
        min: minOffsetDirectional,
        max: maxOffsetDirectional,
        enforceOldBounds: true,
        enforceNewBounds: true,
      );

  /// Convert the [offsetLocal] (e.g. received via a gesture) into the corresponsing value.
  ///
  /// See [handleMainAxisSizeHalf].
  double offsetLocalToValue(Offset offsetLocal) {
    final offsetOnAxis = isHorizontal //
        ? offsetLocal.dx
        : offsetLocal.dy;
    final offsetDirectional = isReverse //
        ? sliderMainAxisSize - offsetOnAxis
        : offsetOnAxis;
    return offsetDirectionalToValue(offsetDirectional - handleMainAxisSizeHalf);
  }

  // ---------------------------------------------------------------------------

  /// Wrap your custom [slider] with a [GestureDetector] that uses this [SliderConfig].
  ///
  /// Enforces the [SliderConfig]s size infos if [enforceSize].
  ///
  /// Calls [onUpdate] on [GestureDetector.onTapDown] and [GestureDetector.onPanUpdate],
  /// unless disabled via [tapEnabled] or [dragEnabled].
  ///
  /// Your slider should position the handle via [valueToOffsetDirectional].
  ///
  /// See [CustomSlider] for an example.
  Widget buildGestureDetector({
    required void Function(double value) onUpdate,
    required Widget slider,
    bool enforceSize = true,
    bool tapEnabled = true,
    bool dragEnabled = true,
    HitTestBehavior? behavior,
    Set<PointerDeviceKind>? supportedDevices,
  }) {
    final child = enforceSize
        ? SizedBoxAxis(
            mainAxisSize: sliderMainAxisSize,
            crossAxisSize: sliderCrossAxisSize,
            axis: axisDirection.axis,
            child: slider,
          )
        : slider;

    return GestureDetector(
      onTapDown: !tapEnabled ? null : (details) => onUpdate(offsetLocalToValue(details.localPosition)),
      onPanUpdate: !dragEnabled ? null : (details) => onUpdate(offsetLocalToValue(details.localPosition)),
      supportedDevices: supportedDevices,
      behavior: behavior,
      child: child,
    );
  }

  // ---------------------------------------------------------------------------

  SliderConfig copyWith({
    double? minValue,
    double? maxValue,
    double? sliderMainAxisSize,
    double? sliderCrossAxisSize,
    double? handleMainAxisSize,
    double? handleCrossAxisSize,
    AxisDirection? axisDirection,
  }) {
    return SliderConfig(
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      sliderMainAxisSize: sliderMainAxisSize ?? this.sliderMainAxisSize,
      sliderCrossAxisSize: sliderCrossAxisSize ?? this.sliderCrossAxisSize,
      handleMainAxisSize: handleMainAxisSize ?? this.handleMainAxisSize,
      handleCrossAxisSize: handleCrossAxisSize ?? this.handleCrossAxisSize,
      axisDirection: axisDirection ?? this.axisDirection,
    );
  }

  // ---------------------------------------------------------------------------

  @override
  bool operator ==(covariant SliderConfig other) {
    if (identical(this, other)) return true;

    return other.minValue == minValue &&
        other.maxValue == maxValue &&
        other.sliderMainAxisSize == sliderMainAxisSize &&
        other.sliderCrossAxisSize == sliderCrossAxisSize &&
        other.handleMainAxisSize == handleMainAxisSize &&
        other.handleCrossAxisSize == handleCrossAxisSize &&
        other.handleMainAxisSizeHalf == handleMainAxisSizeHalf &&
        other.axisDirection == axisDirection;
  }

  @override
  int get hashCode {
    return minValue.hashCode ^
        maxValue.hashCode ^
        sliderMainAxisSize.hashCode ^
        sliderCrossAxisSize.hashCode ^
        handleMainAxisSize.hashCode ^
        handleCrossAxisSize.hashCode ^
        handleMainAxisSizeHalf.hashCode ^
        axisDirection.hashCode;
  }
}

// =============================================================================
// =============================================================================
// =============================================================================

/// A customizable slider using the generic [sliderConfig] for the slider logic.
class CustomSlider extends StatelessWidget {
  const CustomSlider({
    Key? key,
    required this.value,
    required this.sliderConfig,
    required this.handle,
    required this.sliderBefore,
    required this.sliderAfter,
    required this.onUpdateValue,
  }) : super(key: key);

  /// The current value that should be displayed and changed via this slider.
  ///
  /// See [onUpdateValue].
  final double value;

  /// The configuration and logic defining and powering this slider.
  final SliderConfig sliderConfig;

  /// The widget used as the draggable handle.
  final Widget handle;

  /// The widget shown before (and under the first half of) the slider.
  final Widget sliderBefore;

  /// The widget shown after (and under the second half of) the slider.
  final Widget sliderAfter;

  /// Callback for when the user dragged the handle or tapped on the slider.
  final void Function(double value) onUpdateValue;

  void onLocalPosition(Offset localPosition) {
    onUpdateValue(sliderConfig.offsetLocalToValue(localPosition));
  }

  @override
  Widget build(BuildContext context) {
    final handleOffset = sliderConfig.valueToOffsetDirectional(value);
    final handleCenterOffset = sliderConfig.handleStartOffsetToCenterOffset(handleOffset);

    // before and after meet on the half point of the handle
    // for cases like circular handles etc where you can see under the handle
    final sbLength = handleCenterOffset;

    final axisDirection = sliderConfig.axisDirection;

    return sliderConfig.buildGestureDetector(
      onUpdate: onUpdateValue,
      slider: Stack(
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
                axis: axisDirection.axis,
                child: handle,
              ),
            ),
            mainAxisLength: sliderConfig.handleMainAxisSize,
            crossAxisLength: sliderConfig.handleCrossAxisSize,
            start: handleOffset,
          )
        ],
      ),
    );
  }
}
