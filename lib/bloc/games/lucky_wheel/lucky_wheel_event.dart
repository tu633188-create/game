import 'package:equatable/equatable.dart';

abstract class LuckyWheelEvent extends Equatable {
  const LuckyWheelEvent();

  @override
  List<Object> get props => [];
}

class LuckyWheelLoadEvent extends LuckyWheelEvent {
  const LuckyWheelLoadEvent();
}

class LuckyWheelSpinEvent extends LuckyWheelEvent {
  const LuckyWheelSpinEvent();
}

class LuckyWheelSpinCompleteEvent extends LuckyWheelEvent {
  final int selectedIndex;

  const LuckyWheelSpinCompleteEvent(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

class LuckyWheelResetEvent extends LuckyWheelEvent {
  const LuckyWheelResetEvent();
}

