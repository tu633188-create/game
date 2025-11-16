import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/plant_lottie_widget.dart';

/// Test screen để xem Lottie animation cây lớn lên
class PlantWateringTestScreen extends StatefulWidget {
  const PlantWateringTestScreen({super.key});

  @override
  State<PlantWateringTestScreen> createState() =>
      _PlantWateringTestScreenState();
}

class _PlantWateringTestScreenState extends State<PlantWateringTestScreen> {
  final PlantLottieController _lottieController = PlantLottieController();
  bool _showWaterAnimation = false;
  int _currentStage = 0; // Giai đoạn hiện tại (0-5)
  int _cooldownSeconds = 0; // Thời gian cooldown còn lại (giây)

  // Các giai đoạn phát triển của cây (theo % animation)
  final List<double> _growthStages = [
    0.0, // 0: Hạt giống
    0.2, // 1: Nảy mầm
    0.29, // 2: Cây nhỏ
    0.35, // 3: Cây trung bình
    0.5, // 4: Cây lớn
    1.0, // 5: Cây trưởng thành
  ];

  final List<String> _stageNames = [
    'Hạt giống',
    'Nảy mầm',
    'Cây nhỏ',
    'Cây trung bình',
    'Cây lớn',
    'Cây trưởng thành',
  ];

  void _startCooldown() {
    setState(() {
      _cooldownSeconds = 10; // Cooldown 10 giây
    });

    // Timer đếm ngược cooldown
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _cooldownSeconds > 0) {
        setState(() {
          _cooldownSeconds--;
        });
        return true;
      }
      return false;
    });
  }

  void _playWaterAnimation() {
    // Kiểm tra cooldown
    if (_cooldownSeconds > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng đợi $_cooldownSeconds giây nữa! ⏱️'),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    // Kiểm tra xem đã đạt giai đoạn cuối chưa
    if (_currentStage >= _growthStages.length - 1) {
      // Đã đạt giai đoạn cuối, không thể tưới thêm
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cây đã đạt giai đoạn trưởng thành! 🌳'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Bắt đầu cooldown
    _startCooldown();

    // Hiển thị animation nước
    setState(() {
      _showWaterAnimation = true;
    });

    // Tự động ẩn animation nước sau khi hoàn thành (khoảng 4 giây)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showWaterAnimation = false;
        });
      }
    });

    // Sau khi animation nước hoàn thành (4 giây), delay thêm một chút rồi mới cho cây lớn
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Lấy progress của giai đoạn cũ và mới (trước khi cập nhật)
        final oldProgress = _growthStages[_currentStage];
        final newStage = _currentStage + 1;
        final newProgress = _growthStages[newStage];

        // Cập nhật giai đoạn
        setState(() {
          _currentStage = newStage;
        });

        // Jump về giai đoạn cũ và play animation đến giai đoạn mới
        _lottieController.jumpToProgress(oldProgress);
        _lottieController.play();

        // Tính toán thời gian cần thiết để animation chạy từ oldProgress đến newProgress
        // Giả sử toàn bộ animation là 3.33 giây (100 frames / 30 fps)
        final totalDuration = const Duration(milliseconds: 3330);
        final progressDiff = newProgress - oldProgress;
        final animationDuration = Duration(
          milliseconds: (totalDuration.inMilliseconds * progressDiff).round(),
        );

        // Dừng ở giai đoạn mới sau khi animation chạy đủ thời gian
        Future.delayed(animationDuration, () {
          if (mounted) {
            _lottieController.jumpToProgress(newProgress);
            _lottieController.pause();
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo cây ở giai đoạn đầu tiên khi màn hình load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lottieController.jumpToProgress(_growthStages[_currentStage]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMaxStage = _currentStage >= _growthStages.length - 1;
    final isCooldown = _cooldownSeconds > 0;
    final canWater = !isMaxStage && !isCooldown;

    return Scaffold(
      appBar: AppBar(title: const Text('Cây lớn lên - Animation Test')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Hiển thị giai đoạn hiện tại
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Text(
                    'Giai đoạn: ${_stageNames[_currentStage]}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Lottie Animation - Cây
                SizedBox(
                  width: size.width,
                  height: size.width,
                  child: PlantLottieWidget(
                    controller: _lottieController,
                    width: size.width,
                    height: size.width,
                    repeat: false,
                    autoPlay: false,
                  ),
                ),
                const SizedBox(height: 32),
                // Nút tưới nước
                ElevatedButton.icon(
                  onPressed: canWater
                      ? () {
                          _playWaterAnimation();
                        }
                      : null,
                  icon: Icon(isCooldown ? Icons.timer : Icons.water_drop),
                  label: Text(
                    isMaxStage
                        ? 'Đã đạt giai đoạn tối đa'
                        : isCooldown
                        ? 'Đợi $_cooldownSeconds giây'
                        : 'Tưới nước',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    backgroundColor: canWater ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Water Animation Overlay
          if (_showWaterAnimation)
            Positioned(
              left: -50,
              bottom: size.height * 0.2,
              width: size.width * 0.5,
              height: size.width * 0.5,
              child: Lottie.asset(
                'assets/animations/spray.json',
                fit: BoxFit.contain,
                repeat: false,
              ),
            ),
        ],
      ),
    );
  }
}
