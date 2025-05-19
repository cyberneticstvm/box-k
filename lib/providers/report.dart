import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedNumberGroupReport = StateProvider<int>((ref) {
  return 0;
});

final selectedPlayCodeReport = StateProvider<String>((ref) {
  return 'king'; // Always selected 3:00 PM as default play
});

final selectedTicketReport = StateProvider<String>((ref) {
  return 'All';
});

final selectedDateFrom = StateProvider<DateTime>((ref) {
  return DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
});

final selectedDateTo = StateProvider<DateTime>((ref) {
  return DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
});

final enteredBillNumber = StateProvider<String>((ref) {
  return '';
});

final enteredTicketNumber = StateProvider<String>((ref) {
  return '';
});
