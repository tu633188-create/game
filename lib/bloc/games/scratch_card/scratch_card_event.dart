import 'package:equatable/equatable.dart';

abstract class ScratchCardEvent extends Equatable {
  const ScratchCardEvent();

  @override
  List<Object> get props => [];
}

class ScratchCardLoadEvent extends ScratchCardEvent {
  const ScratchCardLoadEvent();
}

class ScratchCardScratchEvent extends ScratchCardEvent {
  const ScratchCardScratchEvent();
}

class ScratchCardScratchCompleteEvent extends ScratchCardEvent {
  final String rewardId;

  const ScratchCardScratchCompleteEvent(this.rewardId);

  @override
  List<Object> get props => [rewardId];
}

class ScratchCardResetEvent extends ScratchCardEvent {
  const ScratchCardResetEvent();
}
