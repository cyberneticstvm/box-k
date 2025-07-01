import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedPage = StateProvider<int>((ref) {
  return 4;
});

final isPageDetached = StateProvider<bool>((ref) {
  return false;
});
