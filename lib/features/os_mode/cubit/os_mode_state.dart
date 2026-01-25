part of 'os_mode_cubit.dart';

class OSModeState extends Equatable {
  final OSMode mode;
  final bool isManual;

  const OSModeState(this.mode, {this.isManual = false});

  @override
  List<Object> get props => [mode, isManual];
}
