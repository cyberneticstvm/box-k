import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedNumberGroup = StateProvider<int>((ref) {
  return 3;
});

final selectedNumberSet = StateProvider<int>((ref) {
  return 0;
});

final selectedPlayCode = StateProvider<String>((ref) {
  return 'king'; // Always selected 3:00 PM as default play
});

final selectedUser = StateProvider<int>((ref) {
  return 1;
});

final selectedTicket = StateProvider<String>((ref) {
  return 'king';
});

final isPlayBlocked = StateProvider<bool>((ref) {
  return false;
});
