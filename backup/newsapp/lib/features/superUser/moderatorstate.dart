import 'package:flutter_riverpod/flutter_riverpod.dart';

final moderatorStateProvider = StateNotifierProvider((ref) => ModeratorState());

class ModeratorState extends StateNotifier<bool> {
  ModeratorState() : super(false);

  void toggle() {
    state = state;
  }
}
