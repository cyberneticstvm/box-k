import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/report.dart';
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
  double total = 0.0;
  int? count = 0;
  Future<void> getData() async {
    final collection = FirebaseFirestore.instance.collection('orders').where(
        'play_date',
        isGreaterThanOrEqualTo: ref.watch(selectedDateFrom),
        isLessThanOrEqualTo: ref.watch(selectedDateTo));
    final c = await collection.aggregate(sum('count')).get().then((res) {
      return res.getSum('count');
    });
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
            color: const Color(0xff2c73e7),
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
                          'Count: ${count.toString()}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Amount: ${double.parse(total.toString()).toStringAsFixed(2)}',
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
        ],
      ),
    );
  }
}
