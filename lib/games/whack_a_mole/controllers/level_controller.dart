part of '../main.dart';

class LevelController extends ChangeNotifier {
  LevelController({
    Duration initialDuration = const Duration(seconds: 30),
    int totalMoles = 9,
  }) : _duration = initialDuration,
       _length = totalMoles;

  final Duration _duration;
  final int _length;

  late Duration countdown = _duration;
  late List<MoleModel> moles = [
    for (int i = 0; i < _length; i++) MoleModel(index: i),
  ];

  DateTime? _startedAt;
  DateTime? _stoppedAt;
  int _coinsEarned = 0;

  int get coinsEarned => _coinsEarned;

  Duration? get result {
    if (_startedAt == null || _stoppedAt == null) return null;
    return _stoppedAt!.difference(_startedAt!);
  }

  Function(int)? onCoinEarned; // Callback khi đập được mole
  Function(int)? onCoinSubtracted; // Callback khi đập trúng bomber (trừ coin)

  bool get isGameOver {
    final result = countdown.inSeconds <= 0;
    if (result) {
      _stoppedAt = DateTime.now();
      countdown = Duration.zero;
    }
    return result;
  }

  Future<void> start({bool isFirstTime = true}) async {
    if (isFirstTime) {
      countdown = _duration;
      _startedAt = DateTime.now();
      _coinsEarned = 0;
    }
    if (!isGameOver) {
      // Tăng delay lên 2 giây để giảm độ khó (spawn chậm hơn)
      await Future.delayed(const Duration(seconds: 2));
      countdown = countdown - const Duration(seconds: 2); // Giảm đúng với delay

      // Giảm tỷ lệ spawn mole (chỉ spawn 50% mole mỗi lần)
      for (var mole in moles) {
        if (Random().nextDouble() < 0.5) {
          moles[mole.index] = mole
            ..isTapped = false
            ..type = MoleType.values
                .where((e) => e != mole.type)
                .toList()[Random().nextInt(2)];
        } else {
          moles[mole.index] = mole
            ..isTapped = false
            ..type = MoleType.none;
        }
      }

      notifyListeners();
      await start(isFirstTime: false);
    } else {
      return;
    }
  }

  Future<void> stop() async {
    if (!isGameOver) countdown = const Duration(seconds: 1);
  }

  Future<void> onTap(MoleModel value) async {
    if (!isGameOver && !value.isTapped) {
      if (value.type == MoleType.bomber) {
        countdown -= const Duration(seconds: 5);
        // Trừ coin khi đập trúng bomber mole
        const coinsToSubtract = 2; // Trừ 2 coin
        _coinsEarned -= coinsToSubtract;
        onCoinSubtracted?.call(coinsToSubtract);
      } else if (value.type == MoleType.normal) {
        countdown += const Duration(seconds: 1);
        // Thêm coin khi đập được normal mole
        _coinsEarned += 1;
        onCoinEarned?.call(1);
      }

      moles[value.index] = value..isTapped = true;
      notifyListeners();
    }
  }
}
