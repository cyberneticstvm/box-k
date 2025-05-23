import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesDetailBillReport extends ConsumerStatefulWidget {
  const SalesDetailBillReport(
      {super.key,
      required this.userId,
      required this.userName,
      required this.count,
      required this.total});

  final int userId;
  final String userName;
  final double count;
  final double total;

  @override
  ConsumerState<SalesDetailBillReport> createState() {
    return _SalesDetailBillReportState();
  }
}

class _SalesDetailBillReportState extends ConsumerState<SalesDetailBillReport> {
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

  getData() async {
    showLoadingIndicator();
    bool isBillNo = false;
    var orders = FirebaseFirestore.instance
        .collection('orders')
        .where('play_date',
            isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
            isLessThanOrEqualTo: ref.watch(selectedDateTo))
        .where('user_id', isEqualTo: widget.userId);
    if (ref.watch(enteredBillNumber) > 0) {
      isBillNo = true;
      orders =
          orders.where('bill_number', isEqualTo: ref.watch(enteredBillNumber));
    }
    if (ref.watch(selectedPlayCodeReport) != 'All') {
      orders =
          orders.where('play', isEqualTo: ref.watch(selectedPlayCodeReport));
    }
    if (ref.watch(selectedTicketReport) != 'All') {
      orders =
          orders.where('ticket', isEqualTo: ref.watch(selectedTicketReport));
    }
    final ord = await orders.get().then((snapshot) {
      return snapshot.docs;
    });
    var grouped = [{}];
    for (var item in ord) {
      var l = {
        'bill_number': item['bill_number'],
      };
      setState(() {
        grouped.add(l);
      });
    }
    var newMap = groupBy(grouped, (Map obj) => obj['bill_number']);
    var grpdBillNos = newMap.keys.nonNulls.toList();
    Query<Map<String, dynamic>> ordTot;
    for (var item in grpdBillNos) {
      if (isBillNo) {
        ordTot = orders;
      } else {
        ordTot = orders.where('bill_number', isEqualTo: item);
      }
      final data = await ordTot.get().then(
        (snapshot) {
          return snapshot.docs[0];
        },
      );
      final c = await ordTot.aggregate(sum('count')).get().then((res) {
        return res.getSum('count');
      });
      final s = await ordTot.aggregate(sum('total')).get().then((res) {
        return res.getSum('total');
      });
      var finalItems = {
        'bill_number': item,
        'total': s,
        'count': c,
        'cdate': data['created_at']
      };
      setState(() {
        sales.add(finalItems);
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

  bool active = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Details Bill',
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).myBlueColorDark),
        ),
        actions: [
          Text(
            '${widget.count.toString()} \t\t\t',
            style: TextStyle(
              color: Theme.of(context).myRedColorDark,
              fontSize: 18,
            ),
          ),
          Text(
            '₹ ${widget.total.toString()} \t',
            style: TextStyle(
              color: Theme.of(context).myGreenColorDark,
              fontSize: 18,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: sales.length,
          itemBuilder: (context, index) {
            return Card(
              child: ExpansionTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        sales[index]['bill_number'].toString(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        DateFormat('HH:mm:ss')
                            .format(sales[index]['cdate'].toDate())
                            .toString(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        sales[index]['count'].toString(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        sales[index]['total'].toString(),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('dd-MM-yy')
                            .format(sales[index]['cdate'].toDate())
                            .toString(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.userName,
                      ),
                    ),
                  ],
                ),
                children: [
                  ExpandedItem(
                    billNumber: sales[index]['bill_number'],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ExpandedItem extends ConsumerStatefulWidget {
  const ExpandedItem({super.key, required this.billNumber});

  final int billNumber;

  @override
  ConsumerState<ExpandedItem> createState() {
    return _ExpandedItemState();
  }
}

class _ExpandedItemState extends ConsumerState<ExpandedItem> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .where('bill_number', isEqualTo: widget.billNumber)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No records found.'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).myBlueColorDark),
            );
          }
          return SizedBox(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Ticket')),
                DataColumn(label: Text('Number')),
                DataColumn(label: Text('Count')),
                DataColumn(label: Text('Total')),
              ],
              rows: snapshot.data!.docs
                  .map(
                    (item) => DataRow(
                      cells: [
                        DataCell(Text(item['play'])),
                        DataCell(Text(item['number'])),
                        DataCell(Text(item['count'].toString())),
                        DataCell(Text(item['total'].toString())),
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
