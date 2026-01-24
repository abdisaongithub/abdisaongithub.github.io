part of 'window_manager_cubit.dart';

class WindowManagerState extends Equatable {
  final List<VirtualWindowItem> windows;

  const WindowManagerState({this.windows = const []});

  WindowManagerState copyWith({List<VirtualWindowItem>? windows}) {
    return WindowManagerState(windows: windows ?? this.windows);
  }

  @override
  List<Object> get props => [windows];
}
