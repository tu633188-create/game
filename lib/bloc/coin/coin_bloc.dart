import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coin_event.dart';
import 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  CoinBloc() : super(const CoinInitial()) {
    on<CoinLoadEvent>(_onLoadCoins);
    on<CoinAddEvent>(_onAddCoins);
    on<CoinSubtractEvent>(_onSubtractCoins);
    on<CoinResetEvent>(_onResetCoins);

    // Load coins when bloc is created
    add(const CoinLoadEvent());
  }

  static const String _coinKey = 'total_coins';

  Future<void> _onLoadCoins(
    CoinLoadEvent event,
    Emitter<CoinState> emit,
  ) async {
    emit(const CoinLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final coins = prefs.getInt(_coinKey) ?? 0;
      emit(CoinLoaded(coins));
    } catch (e) {
      emit(CoinError('Failed to load coins: $e'));
    }
  }

  Future<void> _onAddCoins(
    CoinAddEvent event,
    Emitter<CoinState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCoins = prefs.getInt(_coinKey) ?? 0;
      final newTotal = currentCoins + event.amount;
      await prefs.setInt(_coinKey, newTotal);
      emit(CoinLoaded(newTotal));
    } catch (e) {
      emit(CoinError('Failed to add coins: $e'));
    }
  }

  Future<void> _onSubtractCoins(
    CoinSubtractEvent event,
    Emitter<CoinState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCoins = prefs.getInt(_coinKey) ?? 0;
      final newTotal = (currentCoins - event.amount).clamp(0, double.infinity).toInt();
      await prefs.setInt(_coinKey, newTotal);
      emit(CoinLoaded(newTotal));
    } catch (e) {
      emit(CoinError('Failed to subtract coins: $e'));
    }
  }

  Future<void> _onResetCoins(
    CoinResetEvent event,
    Emitter<CoinState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_coinKey, 0);
      emit(const CoinLoaded(0));
    } catch (e) {
      emit(CoinError('Failed to reset coins: $e'));
    }
  }
}

