import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boxk/models/item.dart';

class ItemAddNotifier extends StateNotifier<List<Item>> {
  ItemAddNotifier() : super(const []);

  Future<void> loadItems() async {
    final List<Item> items = [];
    state = items;
  }

  void addItem(
      String ticket,
      String userId,
      String play,
      String number,
      int count,
      double rate,
      num total,
      DateTime playDate,
      DateTime createdAt) async {
    final newItem = Item(
      ticket: ticket,
      userId: userId,
      play: play,
      number: number,
      count: count,
      rate: rate,
      total: total,
      playDate: playDate,
      createdAt: createdAt,
    );
    state = [newItem, ...state];
  }

  void removeItem(index) {
    state.removeAt(index);
  }

  int getItemCount() {
    int count = 0;
    for (final c in state) {
      count += c.count;
    }
    return count;
  }
}

final itemAddProvider = StateNotifierProvider<ItemAddNotifier, List<Item>>(
  (ref) => ItemAddNotifier(),
);

final itemListCountProvider = Provider((ref) {
  final items = ref.watch(itemAddProvider);
  int count = 0;
  for (final c in items) {
    count += c.count;
  }
  return count;
});

final itemCountProvider = StateProvider<int>((ref) {
  final count = ref.watch(itemListCountProvider);
  return count;
});

final itemListAmountProvider = Provider((ref) {
  final items = ref.watch(itemAddProvider);
  double amount = 0;
  for (final rs in items) {
    amount += rs.total;
  }
  return amount;
});

final itemAmountProvider = StateProvider<double>((ref) {
  final amount = ref.watch(itemListAmountProvider);
  return amount;
});
