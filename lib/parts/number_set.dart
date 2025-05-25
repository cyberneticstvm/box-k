import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberSet extends ConsumerStatefulWidget {
  const NumberSet({super.key});

  @override
  ConsumerState<NumberSet> createState() {
    return _NumberSetState();
  }
}

class _NumberSetState extends ConsumerState<NumberSet> {
  final List items = [
    {
      'id': 1,
      'value': false,
      'title': 'Set',
    },
    {
      'id': 2,
      'value': false,
      'title': 'Any',
    },
    {
      'id': 3,
      'value': false,
      'title': '100',
    },
    {
      'id': 4,
      'value': false,
      'title': '111',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).myGrayColorLight,
      height: MediaQuery.of(context).size.height * .050,
      child: Column(
        children: [
          Row(
            children: List.generate(
              items.length,
              (index) {
                return Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: Text(
                        items[index]["title"],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    Checkbox(
                      side: BorderSide(
                        color: Theme.of(context).myBlueColorLight,
                        width: 2,
                      ),
                      activeColor: Theme.of(context).myBlueColorDark,
                      checkColor: Colors.white,
                      value: items[index]['value'],
                      onChanged: (value) {
                        for (var element in items) {
                          element["value"] = false;
                        }
                        ref.read(selectedNumberSet.notifier).update(
                            (state) => (value!) ? items[index]['id'] : 0);
                        setState(() {
                          items[index]['value'] = value!;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
