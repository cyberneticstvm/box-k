import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/providers/user.dart';
import 'package:boxk/reports/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AccountSummaryReportScreen extends ConsumerStatefulWidget {
  const AccountSummaryReportScreen({super.key});

  @override
  ConsumerState<AccountSummaryReportScreen> createState() {
    return _AccountSummaryReportScreenState();
  }
}

class _AccountSummaryReportScreenState
    extends ConsumerState<AccountSummaryReportScreen> {
  final _globalFormKey = GlobalKey<FormState>();
  fetchData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const AccountSummaryReportDetail(),
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
          ref.invalidate(selectedUserProviderReport);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Account Summary',
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
                if (ref.watch(currentUserProvider)['role'] != 'User')
                  SizedBox(
                    height: 10,
                  ),
                if (ref.watch(currentUserProvider)['role'] != 'User')
                  UserDropdownListReport(),
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

class AccountSummaryReportDetail extends ConsumerStatefulWidget {
  const AccountSummaryReportDetail({super.key});

  @override
  ConsumerState<AccountSummaryReportDetail> createState() {
    return _AccountSummaryReportDetailState();
  }
}

class _AccountSummaryReportDetailState
    extends ConsumerState<AccountSummaryReportDetail> {
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
    bool isUserId = false;
    var orders = FirebaseFirestore.instance.collection('orders').where(
        'play_date',
        isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
        isLessThanOrEqualTo: ref.watch(selectedDateTo));

    if (ref.watch(selectedPlayCodeReport) != 'All') {
      orders =
          orders.where('play', isEqualTo: ref.watch(selectedPlayCodeReport));
    }

    if (ref.watch(selectedUserProviderReport)['role'] == 'Leader') {
      orders = orders.where('parent',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    }
    if (ref.watch(selectedUserProviderReport)['role'] == 'User' &&
        ref.watch(selectedUserProviderReport)['uid'] > 0) {
      isUserId = true;
      orders = orders.where('user_id',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    }
    final collection = FirebaseFirestore.instance
        .collection('users')
        .where('name', isNotEqualTo: 'All')
        .where('status', isEqualTo: 'Active');
    var users = await collection.where('role', isEqualTo: 'User').get();
    if (ref.watch(selectedUserProviderReport)['role'] == 'Leader') {
      users = await collection
          .where('role', isEqualTo: 'User')
          .where('parent',
              isEqualTo: ref.watch(selectedUserProviderReport)['uid'])
          .get();
    }
    if (ref.watch(selectedUserProviderReport)['role'] == 'User') {
      users = await collection
          .where('uid', isEqualTo: ref.watch(selectedUserProviderReport)['uid'])
          .get();
    }
    if (users.docs.isNotEmpty) {
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
      for (var item in users.docs) {
        var orders1 = orders;
        if (!isUserId) {
          orders1 = orders.where('user_id', isEqualTo: item['uid']);
        }
        double orderTotal = 0;
        double winTotal = 0;
        double superr = 0;
        double commission = 0;
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
        });
        var ord = {
          'date': DateFormat("dd/MM/yyyy")
              .format(ref.watch(selectedDateFrom))
              .toString(),
          'uname': item['name'],
          'uid': item['uid'],
          'ordTot': orderTotal,
          'winTot': winTotal,
          'super': superr,
          'commission': commission,
          'balance': orderTotal - winTotal,
        };
        setState(() {
          sales.add(ord);
        });
      }
      setState(() {
        balTot = sales.fold(0, (s, item) => s + item['balance']);
        wTot = sales.fold(0, (s, item) => s + item['winTot']);
        oTot = sales.fold(0, (s, item) => s + item['ordTot']);
        sales.add({
          'date': 'Total',
          'uname': '',
          'uid': '',
          'ordTot': oTot,
          'winTot': wTot,
          'super': 0,
          'commission': 0,
          'balance': balTot,
        });
      });
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
        title: Text('Account Summary',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).myBlueColorDark)),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 35,
          columns: [
            DataColumn(label: Text('User')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Sale')),
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
