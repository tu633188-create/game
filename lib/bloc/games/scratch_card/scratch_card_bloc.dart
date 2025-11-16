import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scratch_card_event.dart';
import 'scratch_card_state.dart';

class ScratchCardBloc extends Bloc<ScratchCardEvent, ScratchCardState> {
  ScratchCardBloc() : super(const ScratchCardInitial()) {
    on<ScratchCardLoadEvent>(_onLoad);
    on<ScratchCardScratchEvent>(_onScratch);
    on<ScratchCardScratchCompleteEvent>(_onScratchComplete);
    on<ScratchCardResetEvent>(_onReset);

    // Load initial state
    add(const ScratchCardLoadEvent());
  }

  static const String _scratchesKey = 'scratch_card_scratches';
  static const String _lastScratchDateKey = 'scratch_card_last_scratch_date';
  static const int _maxScratchesPerDay = 2;
  static const int _minScratchesPerDay = 1;

  // Default rewards configuration
  static const List<ScratchCardReward> _defaultRewards = [
    ScratchCardReward(
      id: 'coin_10',
      label: '10 Coin',
      coinAmount: 10,
      type: 'coin',
    ),
    ScratchCardReward(
      id: 'coin_20',
      label: '20 Coin',
      coinAmount: 20,
      type: 'coin',
    ),
    ScratchCardReward(
      id: 'coin_30',
      label: '30 Coin',
      coinAmount: 30,
      type: 'coin',
    ),
    ScratchCardReward(
      id: 'voucher_10',
      label: 'Voucher 10%',
      coinAmount: 0,
      voucherId: 'voucher_10',
      type: 'voucher',
    ),
    ScratchCardReward(
      id: 'voucher_20',
      label: 'Voucher 20%',
      coinAmount: 0,
      voucherId: 'voucher_20',
      type: 'voucher',
    ),
    ScratchCardReward(
      id: 'none',
      label: 'Chúc bạn may mắn lần sau',
      coinAmount: 0,
      type: 'none',
    ),
  ];

  Future<void> _onLoad(
    ScratchCardLoadEvent event,
    Emitter<ScratchCardState> emit,
  ) async {
    emit(const ScratchCardLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastScratchDate = prefs.getString(_lastScratchDateKey);
      final today = DateTime.now().toIso8601String().split('T')[0];

      int scratchesRemaining;
      if (lastScratchDate != today) {
        // New day, reset scratches
        final random = Random();
        scratchesRemaining =
            _minScratchesPerDay +
            random.nextInt(_maxScratchesPerDay - _minScratchesPerDay + 1);
        await prefs.setInt(_scratchesKey, scratchesRemaining);
        await prefs.setString(_lastScratchDateKey, today);
      } else {
        scratchesRemaining = prefs.getInt(_scratchesKey) ?? 0;
      }

      emit(
        ScratchCardLoaded(
          availableRewards: _defaultRewards,
          scratchesRemaining: scratchesRemaining,
          canScratch: scratchesRemaining > 0,
        ),
      );
    } catch (e) {
      emit(ScratchCardError('Failed to load: $e'));
    }
  }

  Future<void> _onScratch(
    ScratchCardScratchEvent event,
    Emitter<ScratchCardState> emit,
  ) async {
    final currentState = state;
    if (currentState is ScratchCardLoaded && !currentState.canScratch) {
      return; // Cannot scratch
    }

    if (currentState is ScratchCardLoaded) {
      emit(
        ScratchCardScratching(
          availableRewards: currentState.availableRewards,
          scratchesRemaining: currentState.scratchesRemaining,
        ),
      );
    }
  }

  Future<void> _onScratchComplete(
    ScratchCardScratchCompleteEvent event,
    Emitter<ScratchCardState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentScratches = prefs.getInt(_scratchesKey) ?? 0;
      final newScratchesRemaining = (currentScratches - 1)
          .clamp(0, double.infinity)
          .toInt();
      await prefs.setInt(_scratchesKey, newScratchesRemaining);

      final currentState = state;
      if (currentState is ScratchCardScratching) {
        final selectedReward = currentState.availableRewards.firstWhere(
          (reward) => reward.id == event.rewardId,
          orElse: () => currentState.availableRewards.first,
        );

        emit(
          ScratchCardLoaded(
            availableRewards: currentState.availableRewards,
            scratchesRemaining: newScratchesRemaining,
            canScratch: newScratchesRemaining > 0,
            lastReward: selectedReward,
            isScratched: true,
          ),
        );
      }
    } catch (e) {
      emit(ScratchCardError('Failed to complete scratch: $e'));
    }
  }

  Future<void> _onReset(
    ScratchCardResetEvent event,
    Emitter<ScratchCardState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_scratchesKey);
      await prefs.remove(_lastScratchDateKey);
      add(const ScratchCardLoadEvent());
    } catch (e) {
      emit(ScratchCardError('Failed to reset: $e'));
    }
  }

  // Helper method to get random reward
  ScratchCardReward getRandomReward() {
    final random = Random();
    return _defaultRewards[random.nextInt(_defaultRewards.length)];
  }
}
