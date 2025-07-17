import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
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
    /*if (ref.watch(selectedUserProviderReport)['role'] == 'Leader') {
      orders = orders.where('parent',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    }*/
    if (ref.watch(selectedUserProviderReport)['role'] == 'User') {
      orders = orders.where('user_id',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    } else {
      orders = orders.where(Filter.or(
          Filter('user_id',
              isEqualTo: ref.watch(selectedUserProviderReport)['uid']),
          Filter('parent',
              isEqualTo: ref.watch(selectedUserProviderReport)['uid'])));
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
              if (res['p1'].toString().substring(0, 1) == order['number'] &&
                  order['ticket'] == 'a' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                tot += order['count'] * scheme['amount'] -
                    order['count'] * scheme['super'];
                count += order['count'];
                superr += order['count'] * scheme['super'];
              }
              if (res['p1'].toString().substring(1, 2) == order['number'] &&
                  order['ticket'] == 'b' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                tot += order['count'] * scheme['amount'] -
                    order['count'] * scheme['super'];
                count += order['count'];
                superr += order['count'] * scheme['super'];
              }
              if (res['p1'].toString().substring(2, 3) == order['number'] &&
                  order['ticket'] == 'c' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                tot += order['count'] * scheme['amount'] -
                    order['count'] * scheme['super'];
                count += order['count'];
                superr += order['count'] * scheme['super'];
              }
            }
          }
        }
      }
      ref.read(reportWinningTotal.notifier).update((state) => tot - superr);
      ref.read(reportWinningCount.notifier).update((state) => count);
      ref.read(reportWinningSuper.notifier).update((state) => superr);
      setState(() {});
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
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          ref.invalidate(reportWinningTotal);
          ref.invalidate(reportWinningCount);
          ref.invalidate(reportWinningSuper);
        }
      },
      child: Scaffold(
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
                            'Grand Amount: ${(ref.watch(reportWinningTotal) + ref.watch(reportWinningSuper)).toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Total Amount: ${(ref.watch(reportWinningTotal)).toStringAsFixed(2)}',
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
                            'Total Count: ${ref.watch(reportWinningCount).toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Total Super: ${ref.watch(reportWinningSuper).toStringAsFixed(2)}',
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
                                    builder: (ctx) =>
                                        const WinningSummaryDetailReport(),
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
      ),
    );
  }
}

class WinningSummaryDetailReport extends ConsumerStatefulWidget {
  const WinningSummaryDetailReport({super.key});

  @override
  ConsumerState<WinningSummaryDetailReport> createState() {
    return _WinningSummaryDetailReportState();
  }
}

class _WinningSummaryDetailReportState
    extends ConsumerState<WinningSummaryDetailReport> {
  var sales = [];
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
    bool isUserId = false;
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
    /*if (ref.watch(selectedUserProviderReport)['role'] == 'Leader') {
      orders = orders.where('parent',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    }*/
    if (ref.watch(selectedUserProviderReport)['role'] == 'User' &&
        ref.watch(selectedUserProviderReport)['uid'] > 0) {
      isUserId = true;
      orders = orders.where('user_id',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    } else {
      orders = orders.where(Filter.or(
          Filter('user_id',
              isEqualTo: ref.watch(selectedUserProviderReport)['uid']),
          Filter('parent',
              isEqualTo: ref.watch(selectedUserProviderReport)['uid'])));
    }
    final collection = FirebaseFirestore.instance
        .collection('users')
        .where('name', isNotEqualTo: 'All')
        .where('status', isEqualTo: 'Active');
    var users = await collection.where('role', isEqualTo: 'User').get();
    /*if (ref.watch(selectedUserProviderReport)['role'] == 'Leader') {
      users = await collection
          .where('role', isEqualTo: 'User')
          .where('parent',
              isEqualTo: ref.watch(selectedUserProviderReport)['uid'])
          .get();
    }*/
    if (ref.watch(selectedUserProviderReport)['role'] == 'User') {
      users = await collection
          .where('uid', isEqualTo: ref.watch(selectedUserProviderReport)['uid'])
          .get();
    } else {
      if (ref.watch(selectedUserFlag) > 0) {
        users = await collection
            .where('uid',
                isEqualTo: ref.watch(selectedUserProviderReport)['uid'])
            .get();
      } else {
        users = await collection
            .where(Filter.or(
                Filter('uid',
                    isEqualTo: ref.watch(selectedUserProviderReport)['uid']),
                Filter('parent',
                    isEqualTo: ref.watch(selectedUserProviderReport)['uid'])))
            .get();
      }
    }
    if (users.docs.isNotEmpty) {
      var result = await FirebaseFirestore.instance
          .collection('result')
          .where('play_date',
              isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
              isLessThanOrEqualTo: ref.watch(selectedDateTo))
          .where('play', isEqualTo: ref.watch(selectedPlayCodeReport))
          .get();
      var schemes = FirebaseFirestore.instance.collection('schemes');
      for (var item in users.docs) {
        var orders1 = orders;
        if (!isUserId) {
          orders1 = orders.where('user_id', isEqualTo: item['uid']);
        }
        double tot = 0;
        double c = 0;
        double superr = 0;
        await orders1.get().then((snapshot) async {
          if (snapshot.docs.isNotEmpty) {
            for (var order in snapshot.docs) {
              for (var res in result.docs) {
                for (int i = 1; i <= 35; i++) {
                  if (res['p$i'] == order['number'] &&
                      order['ticket'] == 'king') {
                    var scheme = await schemes
                        .where('position', isEqualTo: (i <= 5) ? i : 6)
                        .where('ticket', isEqualTo: order['ticket'])
                        .get()
                        .then((snapshot) {
                      return snapshot.docs[0];
                    });
                    tot += order['count'] * scheme['amount'] -
                        order['count'] * scheme['super'];
                    c += order['count'];
                    superr += order['count'] * scheme['super'];
                  }
                  if (res['p$i'] == order['number'] &&
                      order['ticket'] == 'box-k') {
                    if (i <= 5) {
                      var scheme = await schemes
                          .where('position', isEqualTo: (i <= 2) ? i : 2)
                          .where('ticket', isEqualTo: order['ticket'])
                          .get()
                          .then((snapshot) {
                        return snapshot.docs[0];
                      });
                      tot += order['count'] * scheme['amount'] -
                          order['count'] * scheme['super'];
                      c += order['count'];
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
                    tot += order['count'] * scheme['amount'] -
                        order['count'] * scheme['super'];
                    c += order['count'];
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
                    tot += order['count'] * scheme['amount'] -
                        order['count'] * scheme['super'];
                    c += order['count'];
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
                    tot += order['count'] * scheme['amount'] -
                        order['count'] * scheme['super'];
                    c += order['count'];
                    superr += order['count'] * scheme['super'];
                  }
                  if (res['p1'].toString().substring(0, 1) == order['number'] &&
                      order['ticket'] == 'a' &&
                      i == 1) {
                    var scheme = await schemes
                        .where('position', isEqualTo: i)
                        .where('ticket', isEqualTo: order['ticket'])
                        .get()
                        .then((snapshot) {
                      return snapshot.docs[0];
                    });
                    tot += order['count'] * scheme['amount'] -
                        order['count'] * scheme['super'];
                    c += order['count'];
                    superr += order['count'] * scheme['super'];
                  }
                  if (res['p1'].toString().substring(1, 2) == order['number'] &&
                      order['ticket'] == 'b' &&
                      i == 1) {
                    var scheme = await schemes
                        .where('position', isEqualTo: i)
                        .where('ticket', isEqualTo: order['ticket'])
                        .get()
                        .then((snapshot) {
                      return snapshot.docs[0];
                    });
                    tot += order['count'] * scheme['amount'] -
                        order['count'] * scheme['super'];
                    c += order['count'];
                    superr += order['count'] * scheme['super'];
                  }
                  if (res['p1'].toString().substring(2, 3) == order['number'] &&
                      order['ticket'] == 'c' &&
                      i == 1) {
                    var scheme = await schemes
                        .where('position', isEqualTo: i)
                        .where('ticket', isEqualTo: order['ticket'])
                        .get()
                        .then((snapshot) {
                      return snapshot.docs[0];
                    });
                    tot += order['count'] * scheme['amount'] -
                        order['count'] * scheme['super'];
                    c += order['count'];
                    superr += order['count'] * scheme['super'];
                  }
                }
              }
            }
          }
        });
        var ord = {
          'uname': item['name'],
          'uid': item['uid'],
          'count': c,
          'amount': tot,
          'super': superr,
        };
        if (ord['count'] > 0) {
          setState(() {
            sales.add(ord);
          });
        }
      }
    }

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
        title: Text('Winning Agent Wise',
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
                          'Total Amount: ${ref.watch(reportWinningTotal).toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
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
                          'Total Count: ${ref.watch(reportWinningCount).toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Sub Agents',
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).myBlueColorDark),
          ),
          SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sales.length,
              itemExtent: 100.0,
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Theme.of(context).myBlueColorLight,
                  child: ListTile(
                    trailing: Text(
                      '₹ ${sales[index]['amount']} \n ${double.parse(sales[index]['count'].toString()).toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      sales[index]['uname'],
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      ref.read(reportWinningTotalUser.notifier).update(
                          (state) =>
                              double.parse(sales[index]['amount'].toString()));
                      ref.read(reportWinningCountUser.notifier).update(
                          (state) =>
                              double.parse(sales[index]['count'].toString()));
                      ref.read(reportWinningSuperUser.notifier).update(
                          (state) =>
                              double.parse(sales[index]['super'].toString()));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => WinningDetailsReport(
                            uid: sales[index]['uid'],
                            uname: sales[index]['uname'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WinningDetailsReport extends ConsumerStatefulWidget {
  const WinningDetailsReport(
      {super.key, required this.uid, required this.uname});

  final int uid;
  final String uname;

  @override
  ConsumerState<WinningDetailsReport> createState() {
    return _WinningDetailsReportState();
  }
}

class _WinningDetailsReportState extends ConsumerState<WinningDetailsReport> {
  var sales = [];
  String stockist = '';
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
        .where('user_id', isEqualTo: widget.uid)
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
                sales.add({
                  'bill_number': order['bill_number'],
                  'ticket': order['ticket'],
                  'prize': order['number'],
                  'count': order['count'],
                  'position': scheme['position'],
                  'super': scheme['super'],
                  'amount': scheme['super'] * order['count'],
                });
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
                  sales.add({
                    'bill_number': order['bill_number'],
                    'ticket': order['ticket'],
                    'prize': order['number'],
                    'count': order['count'],
                    'position': scheme['position'],
                    'super': scheme['super'],
                    'amount': scheme['super'] * order['count'],
                  });
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
                sales.add({
                  'bill_number': order['bill_number'],
                  'ticket': order['ticket'],
                  'prize': order['number'],
                  'count': order['count'],
                  'position': scheme['position'],
                  'super': scheme['super'],
                  'amount': scheme['super'] * order['count'],
                });
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
                sales.add({
                  'bill_number': order['bill_number'],
                  'ticket': order['ticket'],
                  'prize': order['number'],
                  'count': order['count'],
                  'position': scheme['position'],
                  'super': scheme['super'],
                  'amount': scheme['super'] * order['count'],
                });
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
                sales.add({
                  'bill_number': order['bill_number'],
                  'ticket': order['ticket'],
                  'prize': order['number'],
                  'count': order['count'],
                  'position': scheme['position'],
                  'super': scheme['super'],
                  'amount': scheme['super'] * order['count'],
                });
              }
              if (res['p1'].toString().substring(0, 1) == order['number'] &&
                  order['ticket'] == 'a' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                sales.add({
                  'bill_number': order['bill_number'],
                  'ticket': order['ticket'],
                  'prize': order['number'],
                  'count': order['count'],
                  'position': scheme['position'],
                  'super': scheme['super'],
                  'amount': scheme['super'] * order['count'],
                });
              }
              if (res['p1'].toString().substring(1, 2) == order['number'] &&
                  order['ticket'] == 'b' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                sales.add({
                  'bill_number': order['bill_number'],
                  'ticket': order['ticket'],
                  'prize': order['number'],
                  'count': order['count'],
                  'position': scheme['position'],
                  'super': scheme['super'],
                  'amount': scheme['super'] * order['count'],
                });
              }
              if (res['p1'].toString().substring(2, 3) == order['number'] &&
                  order['ticket'] == 'c' &&
                  i == 1) {
                var scheme = await schemes
                    .where('position', isEqualTo: i)
                    .where('ticket', isEqualTo: order['ticket'])
                    .get()
                    .then((snapshot) {
                  return snapshot.docs[0];
                });
                sales.add({
                  'bill_number': order['bill_number'],
                  'ticket': order['ticket'],
                  'prize': order['number'],
                  'count': order['count'],
                  'position': scheme['position'],
                  'super': scheme['super'],
                  'amount': scheme['super'] * order['count'],
                });
              }
              setState(() {
                //
              });
            }
          }
        }
      }
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.uid)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: snapshot.docs[0]['parent'])
            .get()
            .then((agent) {
          setState(() {
            stockist = agent.docs[0]['name'];
          });
        });
      }
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
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          ref.invalidate(reportWinningCountUser);
          ref.invalidate(reportWinningTotalUser);
          ref.invalidate(reportWinningSuperUser);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Winning Details',
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
                            'Count: ${ref.watch(reportWinningCountUser).toString()}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Amount: ${double.parse(ref.watch(reportWinningTotalUser).toString()).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Super: ${ref.watch(reportWinningSuperUser).toString()}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Total: ${double.parse((ref.watch(reportWinningTotalUser) + ref.watch(reportWinningSuperUser)).toString()).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 25,
                headingTextStyle: TextStyle(fontSize: 13),
                dataTextStyle: TextStyle(fontSize: 13),
                columns: [
                  DataColumn(label: Text('Bill')),
                  DataColumn(label: Text('Ticket')),
                  DataColumn(label: Text('Prize')),
                  DataColumn(label: Text('Count')),
                  DataColumn(label: Text('Position')),
                  DataColumn(label: Text('Super')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Agent')),
                  DataColumn(label: Text('Stockist')),
                ],
                rows: sales
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text(item['bill_number'].toString())),
                          DataCell(Text(item['ticket'])),
                          DataCell(
                            Text(item['prize'].toString()),
                          ),
                          DataCell(
                            Text(item['count'].toString()),
                          ),
                          DataCell(
                            Text(item['position'].toString()),
                          ),
                          DataCell(
                            Text(item['super'].toString()),
                          ),
                          DataCell(
                            Text(item['amount'].toString()),
                          ),
                          DataCell(
                            Text(widget.uname),
                          ),
                          DataCell(
                            Text(stockist),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
