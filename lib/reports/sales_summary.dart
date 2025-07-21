import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/reports/sales_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesSummaryReport extends ConsumerStatefulWidget {
  const SalesSummaryReport({super.key});

  @override
  ConsumerState<SalesSummaryReport> createState() {
    return _SalesSummaryReportState();
  }
}

class _SalesSummaryReportState extends ConsumerState<SalesSummaryReport> {
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
    var collection = FirebaseFirestore.instance.collection('orders').where(
        'play_date',
        isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
        isLessThanOrEqualTo: ref.watch(selectedDateTo));
    if (ref.watch(enteredTicketNumber) != '') {
      collection =
          collection.where('number', isEqualTo: ref.watch(enteredTicketNumber));
    }
    if (ref.watch(enteredBillNumber) > 0) {
      collection = collection.where('bill_number',
          isEqualTo: ref.watch(enteredBillNumber));
    }
    if (ref.watch(selectedPlayCodeReport) != 'All') {
      collection = collection.where('play',
          isEqualTo: ref.watch(selectedPlayCodeReport));
    }
    if (ref.watch(selectedTicketReport) != 'All') {
      collection = collection.where('ticket',
          isEqualTo: ref.watch(selectedTicketReport));
    }
    /*if (ref.watch(selectedUserProviderReport)['role'] == 'Leader') {
      collection = collection.where('parent',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    }*/
    if (ref.watch(selectedUserProviderReport)['role'] == 'User') {
      collection = collection.where('user_id',
          isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
    } else {
      if (ref.watch(selectedUserFlag) > 0) {
        collection = collection.where('user_id',
            isEqualTo: ref.watch(selectedUserProviderReport)['uid']);
      } else {
        collection = collection.where(Filter.or(
            Filter('user_id',
                isEqualTo: ref.watch(selectedUserProviderReport)['uid']),
            Filter('parent',
                isEqualTo: ref.watch(selectedUserProviderReport)['uid'])));
      }
    }
    final c = await collection.aggregate(sum('count')).get().then((res) {
      return res.getSum('count');
    });
    final s = await collection.aggregate(sum('total')).get().then((res) {
      return res.getSum('total');
    });
    var tickets = FirebaseFirestore.instance.collection('tickets');
    var users = FirebaseFirestore.instance.collection('users');
    double commission = 0;
    await collection.get().then((snapshot) async {
      for (var order in snapshot.docs) {
        var ticket = await tickets
            .where('name', isEqualTo: order['ticket'])
            .get()
            .then((snapshot) {
          return snapshot.docs[0];
        });
        var u = await users
            .where('uid', isEqualTo: order['user_id'])
            .get()
            .then((snapshot) {
          return snapshot.docs[0];
        });
        commission += (u['role'] == 'User')
            ? (ticket['user_rate'] - ticket['leader_rate']) * order['count']
            : 0;
      }
    });

    ref
        .read(reportSalesCount.notifier)
        .update((state) => double.parse(c.toString()));
    ref
        .read(reportSalesTotal.notifier)
        .update((state) => double.parse(s.toString()));
    ref
        .read(reportCommissionTotal.notifier)
        .update((state) => double.parse(commission.toString()));

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
        title: Text('Sales Summary',
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
                          'Count: ${ref.watch(reportSalesCount).toString()}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Amount: ${double.parse((ref.watch(reportSalesTotal) - ref.watch(reportCommissionTotal)).toString()).toStringAsFixed(2)}',
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
