import 'package:equatable/equatable.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class CoinLoadEvent extends CoinEvent {
  const CoinLoadEvent();
}

class CoinAddEvent extends CoinEvent {
  final int amount;

  const CoinAddEvent(this.amount);

  @override
  List<Object> get props => [amount];
}

class CoinSubtractEvent extends CoinEvent {
  final int amount;

  const CoinSubtractEvent(this.amount);

  @override
  List<Object> get props => [amount];
}

class CoinResetEvent extends CoinEvent {
  const CoinResetEvent();
}

