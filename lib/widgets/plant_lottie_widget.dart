import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Controller để điều khiển PlantLottieWidget
class PlantLottieController {
  _PlantLottieWidgetState? _state;

  void _attach(_PlantLottieWidgetState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Play animation từ đầu
  void play() {
    _state?.play();
  }

  /// Pause animation
  void pause() {
    _state?.pause();
  }

  /// Reset animation về đầu
  void reset() {
    _state?.reset();
  }

  /// Jump đến progress cụ thể (0.0 - 1.0)
  void jumpToProgress(double progress) {
    _state?.jumpToProgress(progress);
  }

  /// Lấy progress hiện tại (0.0 - 1.0)
  double get currentProgress => _state?.currentProgress ?? 0.0;
}

/// Widget hiển thị animation cây lớn lên với khả năng điều khiển
class PlantLottieWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final bool repeat;
  final bool reverse;
  final bool autoPlay;
  final double? stopAtProgress; // Dừng tại % nào (0.0 - 1.0), null = không dừng
  final VoidCallback? onAnimationComplete; // Callback khi animation hoàn thành
  final VoidCallback? onStopAtProgress; // Callback khi dừng tại stopAtProgress
  final PlantLottieController?
  controller; // Controller để điều khiển từ bên ngoài

  const PlantLottieWidget({
    super.key,
    this.width,
    this.height,
    this.repeat = false,
    this.reverse = false,
    this.autoPlay = true,
    this.stopAtProgress,
    this.onAnimationComplete,
    this.onStopAtProgress,
    this.controller,
  });

  @override
  State<PlantLottieWidget> createState() => _PlantLottieWidgetState();
}

class _PlantLottieWidgetState extends State<PlantLottieWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasStoppedAtProgress = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Attach controller nếu có
    widget.controller?._attach(this);

    // Listener để dừng tại progress cụ thể
    if (widget.stopAtProgress != null) {
      _controller.addListener(_checkStopProgress);
    }

    // Listener để detect khi animation complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(PlantLottieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller nếu thay đổi
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  void _checkStopProgress() {
    if (widget.stopAtProgress != null &&
        !_hasStoppedAtProgress &&
        _controller.value >= widget.stopAtProgress!) {
      _controller.stop();
      _hasStoppedAtProgress = true;
      widget.onStopAtProgress?.call();
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _controller.dispose();
    super.dispose();
  }

  /// Play animation từ đầu
  void play() {
    if (_controller.value >= 1.0) {
      _controller.reset();
    }
    _controller.forward();
    setState(() {
      _hasStoppedAtProgress = false;
    });
  }

  /// Pause animation
  void pause() {
    _controller.stop();
  }

  /// Reset animation về đầu
  void reset() {
    _controller.reset();
    setState(() {
      _hasStoppedAtProgress = false;
    });
  }

  /// Jump đến progress cụ thể (0.0 - 1.0)
  void jumpToProgress(double progress) {
    _controller.value = progress.clamp(0.0, 1.0);
    setState(() {
      _hasStoppedAtProgress = false;
    });
  }

  /// Lấy progress hiện tại (0.0 - 1.0)
  double get currentProgress => _controller.value;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/plant.json',
      controller: _controller,
      width: widget.width,
      height: widget.height,
      repeat: widget.repeat,
      reverse: widget.reverse,
      fit: BoxFit.contain,
      animate: widget.autoPlay && widget.stopAtProgress == null,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        if (widget.autoPlay && widget.stopAtProgress == null) {
          _controller.forward();
        }
      },
    );
  }
}
