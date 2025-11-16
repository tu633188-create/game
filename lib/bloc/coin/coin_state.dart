import 'package:equatable/equatable.dart';

abstract class CoinState extends Equatable {
  const CoinState();

  @override
  List<Object> get props => [];
}

class CoinInitial extends CoinState {
  const CoinInitial();
}

class CoinLoading extends CoinState {
  const CoinLoading();
}

class CoinLoaded extends CoinState {
  final int totalCoins;

  const CoinLoaded(this.totalCoins);

  @override
  List<Object> get props => [totalCoins];
}

class CoinError extends CoinState {
  final String message;

  const CoinError(this.message);

  @override
  List<Object> get props => [message];
}

