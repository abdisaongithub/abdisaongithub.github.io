part of 'os_mode_cubit.dart';

class OSModeState extends Equatable {
  final OSMode mode;

  const OSModeState(this.mode);

  @override
  List<Object> get props => [mode];
}
