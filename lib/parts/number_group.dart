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
    return Container(
      color: Theme.of(context).myGrayColorLight,
      height: MediaQuery.of(context).size.height * .060,
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
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  ('₹${ref.watch(itemAmountProvider).toString()}'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
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
                              ? Theme.of(context).myBlueColorDark
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
                              ? Theme.of(context).myBlueColorDark
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
                              ? Theme.of(context).myBlueColorDark
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
    );
  }
}
