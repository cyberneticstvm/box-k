import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberListWidget extends ConsumerStatefulWidget {
  const NumberListWidget({super.key});

  @override
  ConsumerState<NumberListWidget> createState() {
    return _NumberListWidgetState();
  }
}

class _NumberListWidgetState extends ConsumerState<NumberListWidget> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemAddProvider);
    if (items.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .280,
        child: Center(
          child: Text(
            'No items added yet!',
            style: TextStyle(color: Theme.of(context).myBlueColorLight),
          ),
        ),
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * .300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (ctx, index) => Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
            ),
            Expanded(
              child: Text(
                items[index].ticket,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: Text(
                items[index].number.toString(),
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: Text(
                items[index].count.toString(),
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: Text(
                items[index].total.toString(),
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    ref.read(itemCountProvider.notifier).update((state) =>
                        ref.watch(itemCountProvider) - items[index].count);
                    ref.read(itemAmountProvider.notifier).update((state) =>
                        ref.watch(itemAmountProvider) - items[index].total);
                    //ref.read(itemAddProvider.notifier).removeItem(index);
                  });
                  items.removeAt(index);
                  if (items.isEmpty) {
                    ref.read(itemCountProvider.notifier).update((state) => 0);
                    ref
                        .read(itemAmountProvider.notifier)
                        .update((state) => 0.00);
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xFFEA4335),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
