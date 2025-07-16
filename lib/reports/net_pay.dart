import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/providers/user.dart';
import 'package:boxk/reports/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NetPayReportScreen extends ConsumerStatefulWidget {
  const NetPayReportScreen({super.key});

  @override
  ConsumerState<NetPayReportScreen> createState() {
    return _NetPayReportScreenState();
  }
}

class _NetPayReportScreenState extends ConsumerState<NetPayReportScreen> {
  final _globalFormKey = GlobalKey<FormState>();
  fetchData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NetPayReportDetail(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          ref.invalidate(selectedPlayCodeReport);
          ref.invalidate(selectedDateFrom);
          ref.invalidate(selectedDateTo);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Net Pay Report',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).myBlueColorDark),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _globalFormKey,
            child: Column(
              children: [
                PlayDropdownListReport(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    FromDate(),
                    SizedBox(
                      width: 10,
                    ),
                    ToDate(),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchData();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    backgroundColor: const Color(0xff2c73e7),
                  ),
                  child: Wrap(
                    children: [
                      Text(
                        'GENERATE REPORT',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NetPayReportDetail extends ConsumerStatefulWidget {
  const NetPayReportDetail({super.key});

  @override
  ConsumerState<NetPayReportDetail> createState() {
    return _NetPayReportDetailState();
  }
}

class _NetPayReportDetailState extends ConsumerState<NetPayReportDetail> {
  var sales = [];
  double balTot = 0;
  double wTot = 0;
  double oTot = 0;
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
    var orders = FirebaseFirestore.instance.collection('orders').where(
        'play_date',
        isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
        isLessThanOrEqualTo: ref.watch(selectedDateTo));
    if (ref.watch(selectedUserProviderReport)['role'] == 'Leader') {
      orders = orders.where('parent',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    }
    if (ref.watch(selectedPlayCodeReport) != 'All') {
      orders =
          orders.where('play', isEqualTo: ref.watch(selectedPlayCodeReport));
    }

    var result1 = FirebaseFirestore.instance.collection('result').where(
        'play_date',
        isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
        isLessThanOrEqualTo: ref.watch(selectedDateTo));
    if (ref.watch(selectedPlayCodeReport) != 'All') {
      result1 =
          result1.where('play', isEqualTo: ref.watch(selectedPlayCodeReport));
    }

    var result = await result1.get();
    var schemes = FirebaseFirestore.instance.collection('schemes');
    var tickets = FirebaseFirestore.instance.collection('tickets');

    double orderTotal = 0;
    double winTotal = 0;
    double superr = 0;
    double commission = 0;
    await orders.get().then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        for (var order in snapshot.docs) {
          if (result.docs.isEmpty) {
            winTotal = 0;
            orderTotal += order['total'];
            superr = 0;
            commission = 0;
          } else {
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
                  var ticket = await tickets
                      .where('name', isEqualTo: order['ticket'])
                      .get()
                      .then((snapshot) {
                    return snapshot.docs[0];
                  });
                  winTotal += order['count'] * scheme['amount'];
                  orderTotal += order['total'];
                  superr += order['count'] * scheme['super'];
                  commission += ticket['user_rate'] - ticket['leader_rate'];
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
                    var ticket = await tickets
                        .where('name', isEqualTo: order['ticket'])
                        .get()
                        .then((snapshot) {
                      return snapshot.docs[0];
                    });
                    winTotal += order['count'] * scheme['amount'];
                    orderTotal += order['total'];
                    superr += order['count'] * scheme['super'];
                    commission += ticket['user_rate'] - ticket['leader_rate'];
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
                  var ticket = await tickets
                      .where('name', isEqualTo: order['ticket'])
                      .get()
                      .then((snapshot) {
                    return snapshot.docs[0];
                  });
                  winTotal += order['count'] * scheme['amount'];
                  orderTotal += order['total'];
                  superr += order['count'] * scheme['super'];
                  commission += ticket['user_rate'] - ticket['leader_rate'];
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
                  var ticket = await tickets
                      .where('name', isEqualTo: order['ticket'])
                      .get()
                      .then((snapshot) {
                    return snapshot.docs[0];
                  });
                  winTotal += order['count'] * scheme['amount'];
                  orderTotal += order['total'];
                  superr += order['count'] * scheme['super'];
                  commission += ticket['user_rate'] - ticket['leader_rate'];
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
                  var ticket = await tickets
                      .where('name', isEqualTo: order['ticket'])
                      .get()
                      .then((snapshot) {
                    return snapshot.docs[0];
                  });
                  winTotal += order['count'] * scheme['amount'];
                  orderTotal += order['total'];
                  superr += order['count'] * scheme['super'];
                  commission += ticket['user_rate'] - ticket['leader_rate'];
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
                  var ticket = await tickets
                      .where('name', isEqualTo: order['ticket'])
                      .get()
                      .then((snapshot) {
                    return snapshot.docs[0];
                  });
                  winTotal += order['count'] * scheme['amount'];
                  orderTotal += order['total'];
                  superr += order['count'] * scheme['super'];
                  commission += ticket['user_rate'] - ticket['leader_rate'];
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
                  var ticket = await tickets
                      .where('name', isEqualTo: order['ticket'])
                      .get()
                      .then((snapshot) {
                    return snapshot.docs[0];
                  });
                  winTotal += order['count'] * scheme['amount'];
                  orderTotal += order['total'];
                  superr += order['count'] * scheme['super'];
                  commission += ticket['user_rate'] - ticket['leader_rate'];
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
                  var ticket = await tickets
                      .where('name', isEqualTo: order['ticket'])
                      .get()
                      .then((snapshot) {
                    return snapshot.docs[0];
                  });
                  winTotal += order['count'] * scheme['amount'];
                  orderTotal += order['total'];
                  superr += order['count'] * scheme['super'];
                  commission += ticket['user_rate'] - ticket['leader_rate'];
                }
              }
            }
          }
        }
      }
    });
    var ord = {
      'uname': ref.watch(currentUserProvider)['name'],
      'date': DateFormat("dd/MM/yyyy")
          .format(ref.watch(selectedDateFrom))
          .toString(),
      'ordTot': orderTotal,
      'winTot': winTotal - commission,
      'super': superr,
      'commission': commission,
      'balance': orderTotal - (winTotal + commission),
    };
    setState(() {
      sales.add(ord);
      balTot = sales.fold(0, (s, item) => s + item['balance']);
      wTot = sales.fold(0, (s, item) => s + item['winTot']);
      oTot = sales.fold(0, (s, item) => s + item['ordTot']);
      sales.add({
        'uname': '',
        'date': 'Total',
        'ordTot': oTot,
        'winTot': wTot,
        'super': 0,
        'commission': 0,
        'balance': balTot,
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
        title: Text('Net Pay Detail',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).myBlueColorDark)),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 20,
          columns: [
            DataColumn(label: Text('User')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Purchase')),
            DataColumn(label: Text('Winning')),
            DataColumn(label: Text('Balance')),
          ],
          rows: sales
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(Text(item['uname'])),
                    DataCell(Text(item['date'])),
                    DataCell(
                      Text(item['ordTot'].toString()),
                    ),
                    DataCell(
                      Text(item['winTot'].toString()),
                    ),
                    DataCell(
                      Text(item['balance'].toString()),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
