import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/reports/sales_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WinningSummaryReport extends ConsumerStatefulWidget {
  const WinningSummaryReport({super.key});

  @override
  ConsumerState<WinningSummaryReport> createState() {
    return _WinningSummaryReportState();
  }
}

class _WinningSummaryReportState extends ConsumerState<WinningSummaryReport> {
  double tot = 0;
  double count = 0;
  double superr = 0;
  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          heightFactor: 1,
          widthFactor: 1,
          child: SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: Theme.of(context).myAmberColorDark,
            ),
          ),
        );
      },
    );
  }

  void hideLoadingIndicator() {
    Navigator.of(context).pop();
  }

  Future<void> getData() async {
    showLoadingIndicator();
    var orders = FirebaseFirestore.instance
        .collection('orders')
        .where('play', isEqualTo: ref.watch(selectedPlayCodeReport))
        .where('play_date',
            isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
            isLessThanOrEqualTo: ref.watch(selectedDateTo));
    if (ref.watch(enteredTicketNumber) != '') {
      orders =
          orders.where('number', isEqualTo: ref.watch(enteredTicketNumber));
    }
    if (ref.watch(enteredBillNumber) > 0) {
      orders =
          orders.where('bill_number', isEqualTo: ref.watch(enteredBillNumber));
    }
    if (ref.watch(selectedTicketReport) != 'All') {
      orders =
          orders.where('ticket', isEqualTo: ref.watch(selectedTicketReport));
    }
    if (ref.watch(selectedUserProviderReport)['role'] == 'Leader') {
      orders = orders.where('parent',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    }
    if (ref.watch(selectedUserProviderReport)['role'] == 'User') {
      orders = orders.where('user_id',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    }

    var result = await FirebaseFirestore.instance
        .collection('result')
        .where('play_date',
            isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
            isLessThanOrEqualTo: ref.watch(selectedDateTo))
        .where('play', isEqualTo: ref.watch(selectedPlayCodeReport))
        .get();
    var schemes = FirebaseFirestore.instance.collection('schemes');

    await orders.get().then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        for (var order in snapshot.docs) {
          for (var res in result.docs) {
            for (int i = 1; i <= 35; i++) {
              if (res['p$i'] == order['number'] && order['ticket'] == 'king') {
                var scheme = await schemes
                    .where('position', isEqualTo: (i <= 5) ? i : 6)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                if (i <= 5) {
                  tot += order['count'] * scheme['amount'];
                  count += order['count'];
                  superr += order['count'] * scheme['super'];
                } else {
                  tot += order['count'] * scheme['amount'];
                  count += order['count'];
                  superr += order['count'] * scheme['super'];
                }
              }
              if (res['p$i'] == order['number'] && order['ticket'] == 'box-k') {
                if (i <= 5) {
                  var scheme = await schemes
                      .where('position', isEqualTo: (i <= 2) ? i : 2)
                      .where('ticket', isEqualTo: order['ticket'])
                      .get()
                      .then((snapshot) {
                    return snapshot.docs[0];
                  });
                  tot += order['count'] * scheme['amount'];
                  count += order['count'];
                  superr += order['count'] * scheme['super'];
                }
              }
              if (res['p1'].toString().substring(0, 2) == order['number'] &&
                  order['ticket'] == 'ab' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                tot += order['count'] * scheme['amount'];
                count += order['count'];
                superr += order['count'] * scheme['super'];
              }
              if (res['p1'].toString().substring(1, 3) == order['number'] &&
                  order['ticket'] == 'bc' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                tot += order['count'] * scheme['amount'];
                count += order['count'];
                superr += order['count'] * scheme['super'];
              }
              if ('${res['p1'].toString().substring(0, 1)}${res['p$i'].toString().substring(2, 3)}' ==
                      order['number'] &&
                  order['ticket'] == 'ac' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                tot += order['count'] * scheme['amount'];
                count += order['count'];
                superr += order['count'] * scheme['super'];
              }
            }
          }
        }
      }
      setState(() {
        //
      });
    });

    hideLoadingIndicator();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Winning Summary',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).myBlueColorDark)),
      ),
      body: Column(
        children: [
          Card(
            color: Theme.of(context).myBlueColorLight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '${DateFormat.yMMMMd().format(ref.watch(selectedDateFrom)).toString()} - ${DateFormat.yMMMMd().format(ref.watch(selectedDateTo)).toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Grand Amount: ${tot.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Total Amount: ${(tot - superr).toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total Count: ${count.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Total Super: ${superr.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        child: Center(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                              width: 1.0,
                              color: Colors.white,
                            )),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const SalesDetailReport(),
                                ),
                              );
                            },
                            child: Text(
                              'VIEW DETAILS',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
