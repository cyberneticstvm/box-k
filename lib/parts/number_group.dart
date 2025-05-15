import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/item.dart';
import 'package:boxk/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberGroup extends ConsumerStatefulWidget {
  const NumberGroup({super.key});

  @override
  ConsumerState<NumberGroup> createState() {
    return _NumberGroupState();
  }
}

class _NumberGroupState extends ConsumerState<NumberGroup> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'COUNT: ${ref.watch(itemCountProvider).toString()} | ',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    ('₹${ref.watch(itemAmountProvider).toString()}'),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Radio(
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            return (states.contains(WidgetState.selected))
                                ? const Color(0xff2c73e7)
                                : Colors.black;
                          },
                        ),
                        activeColor: Theme.of(context).myBlueColorDark,
                        value: 1,
                        groupValue: ref.watch(selectedNumberGroup),
                        onChanged: (value) {
                          ref
                              .read(selectedNumberGroup.notifier)
                              .update((state) => value!);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Radio(
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            return (states.contains(WidgetState.selected))
                                ? const Color(0xff2c73e7)
                                : Colors.black;
                          },
                        ),
                        activeColor: Theme.of(context).myBlueColorDark,
                        value: 2,
                        groupValue: ref.watch(selectedNumberGroup),
                        onChanged: (value) {
                          ref
                              .read(selectedNumberGroup.notifier)
                              .update((state) => value!);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Radio(
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            return (states.contains(WidgetState.selected))
                                ? const Color(0xff2c73e7)
                                : Colors.black;
                          },
                        ),
                        activeColor: Theme.of(context).myBlueColorDark,
                        value: 3,
                        groupValue: ref.watch(selectedNumberGroup),
                        onChanged: (value) {
                          ref
                              .read(selectedNumberGroup.notifier)
                              .update((state) => value!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
