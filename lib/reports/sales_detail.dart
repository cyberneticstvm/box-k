import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:boxk/reports/sales_detail_bill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesDetailReport extends ConsumerStatefulWidget {
  const SalesDetailReport({super.key});

  @override
  ConsumerState<SalesDetailReport> createState() {
    return _SalesDetailReportState();
  }
}

class _SalesDetailReportState extends ConsumerState<SalesDetailReport> {
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

  var sales = [];

  getData() async {
    showLoadingIndicator();
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
      bool isUserId = false;
      var customer = FirebaseFirestore.instance.collection('users');
      var orders = FirebaseFirestore.instance.collection('orders').where(
          'play_date',
          isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
          isLessThanOrEqualTo: ref.watch(selectedDateTo));
      if (ref.watch(enteredTicketNumber) != '') {
        orders =
            orders.where('number', isEqualTo: ref.watch(enteredTicketNumber));
      }
      if (ref.watch(enteredBillNumber) > 0) {
        orders = orders.where('bill_number',
            isEqualTo: ref.watch(enteredBillNumber));
      }
      if (ref.watch(selectedPlayCodeReport) != 'All') {
        orders =
            orders.where('play', isEqualTo: ref.watch(selectedPlayCodeReport));
      }
      if (ref.watch(selectedTicketReport) != 'All') {
        orders =
            orders.where('ticket', isEqualTo: ref.watch(selectedTicketReport));
      }
      if (ref.watch(selectedUserProviderReport)['uid'] > 0 &&
          ref.watch(selectedUserProviderReport)['role'] == 'User') {
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
      Query<Map<String, dynamic>> ordTot;
      for (var item in users.docs) {
        if (isUserId) {
          ordTot = orders;
        } else {
          ordTot = orders.where('user_id', isEqualTo: item['uid']);
        }
        final c = await ordTot.aggregate(sum('count')).get().then((res) {
          return res.getSum('count');
        });
        final s = await ordTot.aggregate(sum('total')).get().then((res) {
          return res.getSum('total');
        });
        final cust = await customer.doc(item.id).get();
        var ord = {
          'uname': cust['name'],
          'uid': item['uid'],
          'count': c,
          'total': s
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
        title: Text('Sales Details',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).myBlueColorDark)),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                              'Amount: ${double.parse(ref.watch(reportSalesTotal).toString()).toStringAsFixed(2)}',
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
              height: 15,
            ),
            Text(
              'Sub Agents',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).myBlueColorDark),
            ),
            SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: sales.length,
              itemExtent: 100.0,
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Theme.of(context).myBlueColorLight,
                  child: ListTile(
                    trailing: Text(
                      '₹ ${sales[index]['total']} \n ${double.parse(sales[index]['count'].toString()).toStringAsFixed(0)}',
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => SalesDetailBillReport(
                          userId: sales[index]['uid'],
                          userName: sales[index]['uname'],
                          count: sales[index]['count'],
                          total: sales[index]['total'],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
