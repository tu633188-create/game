import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lucky_wheel_event.dart';
import 'lucky_wheel_state.dart';

class LuckyWheelBloc extends Bloc<LuckyWheelEvent, LuckyWheelState> {
  LuckyWheelBloc() : super(const LuckyWheelInitial()) {
    on<LuckyWheelLoadEvent>(_onLoad);
    on<LuckyWheelSpinEvent>(_onSpin);
    on<LuckyWheelSpinCompleteEvent>(_onSpinComplete);
    on<LuckyWheelResetEvent>(_onReset);

    // Load initial state
    add(const LuckyWheelLoadEvent());
  }

  static const String _spinsKey = 'lucky_wheel_spins';
  static const String _lastSpinDateKey = 'lucky_wheel_last_spin_date';
  static const int _maxSpinsPerDay = 5;
  static const int _minSpinsPerDay = 3;

  // Default rewards configuration
  static const List<LuckyWheelReward> _defaultRewards = [
    LuckyWheelReward(label: '10 Coin', coinAmount: 10, type: 'coin'),
    LuckyWheelReward(label: '20 Coin', coinAmount: 20, type: 'coin'),
    LuckyWheelReward(label: '30 Coin', coinAmount: 30, type: 'coin'),
    LuckyWheelReward(label: '50 Coin', coinAmount: 50, type: 'coin'),
    LuckyWheelReward(
      label: 'Voucher 10%',
      coinAmount: 0,
      voucherId: 'voucher_10',
      type: 'voucher',
    ),
    LuckyWheelReward(
      label: 'Voucher 20%',
      coinAmount: 0,
      voucherId: 'voucher_20',
      type: 'voucher',
    ),
    LuckyWheelReward(label: '5 Coin', coinAmount: 5, type: 'coin'),
    LuckyWheelReward(label: '15 Coin', coinAmount: 15, type: 'coin'),
    LuckyWheelReward(
      label: 'Chúc bạn may mắn lần sau',
      coinAmount: 0,
      type: 'none',
    ),
  ];

  Future<void> _onLoad(
    LuckyWheelLoadEvent event,
    Emitter<LuckyWheelState> emit,
  ) async {
    emit(const LuckyWheelLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSpinDate = prefs.getString(_lastSpinDateKey);
      final today = DateTime.now().toIso8601String().split('T')[0];

      int spinsRemaining;
      if (lastSpinDate != today) {
        // New day, reset spins
        final random = Random();
        spinsRemaining =
            _minSpinsPerDay +
            random.nextInt(_maxSpinsPerDay - _minSpinsPerDay + 1);
        await prefs.setInt(_spinsKey, spinsRemaining);
        await prefs.setString(_lastSpinDateKey, today);
      } else {
        spinsRemaining = prefs.getInt(_spinsKey) ?? 0;
      }

      emit(
        LuckyWheelLoaded(
          rewards: _defaultRewards,
          spinsRemaining: spinsRemaining,
          canSpin: spinsRemaining > 0,
        ),
      );
    } catch (e) {
      emit(LuckyWheelError('Failed to load: $e'));
    }
  }

  Future<void> _onSpin(
    LuckyWheelSpinEvent event,
    Emitter<LuckyWheelState> emit,
  ) async {
    final currentState = state;
    if (currentState is LuckyWheelLoaded && !currentState.canSpin) {
      return; // Cannot spin
    }

    if (currentState is LuckyWheelLoaded) {
      emit(
        LuckyWheelSpinning(
          rewards: currentState.rewards,
          spinsRemaining: currentState.spinsRemaining,
        ),
      );
    }
  }

  Future<void> _onSpinComplete(
    LuckyWheelSpinCompleteEvent event,
    Emitter<LuckyWheelState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentSpins = prefs.getInt(_spinsKey) ?? 0;
      final newSpinsRemaining = (currentSpins - 1)
          .clamp(0, double.infinity)
          .toInt();
      await prefs.setInt(_spinsKey, newSpinsRemaining);

      final currentState = state;
      if (currentState is LuckyWheelSpinning) {
        final selectedReward = currentState.rewards[event.selectedIndex];

        emit(
          LuckyWheelLoaded(
            rewards: currentState.rewards,
            spinsRemaining: newSpinsRemaining,
            canSpin: newSpinsRemaining > 0,
            lastReward: selectedReward,
          ),
        );
      }
    } catch (e) {
      emit(LuckyWheelError('Failed to complete spin: $e'));
    }
  }

  Future<void> _onReset(
    LuckyWheelResetEvent event,
    Emitter<LuckyWheelState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_spinsKey);
      await prefs.remove(_lastSpinDateKey);
      add(const LuckyWheelLoadEvent());
    } catch (e) {
      emit(LuckyWheelError('Failed to reset: $e'));
    }
  }
}
