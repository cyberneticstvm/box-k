import 'package:boxk/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrizeResultDetailReport extends ConsumerStatefulWidget {
  const PrizeResultDetailReport(
      {super.key, required this.prize, required this.ticket});

  final List prize;
  final String ticket;

  @override
  ConsumerState<PrizeResultDetailReport> createState() {
    return _PrizeResultDetailReportState();
  }
}

class _PrizeResultDetailReportState
    extends ConsumerState<PrizeResultDetailReport> {
  @override
  Widget build(BuildContext context) {
    List prizeNums = [];
    for (var item in widget.prize) {
      prizeNums.add(item);
    }
    prizeNums.removeRange(0, 4);
    prizeNums.sort((b, a) => b.compareTo(a));
    return (widget.ticket == 'king')
        ? Column(
            children: [
              Text(
                'COMPLEMENT PRIZE',
                style: TextStyle(
                  color: Theme.of(context).myBlueColorDark,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i <= 2; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 3; i <= 5; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 6; i <= 8; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 9; i <= 11; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 12; i <= 14; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 15; i <= 17; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 18; i <= 20; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 21; i <= 23; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 24; i <= 26; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 27; i <= 29; i++)
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            right: BorderSide(width: 1),
                          )),
                          child: Center(
                            child: Text(
                              '\t\t\t${prizeNums[i]}\t\t\t',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          )
        : Container();
  }
}
