import 'package:boxk/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesDetailReport extends ConsumerStatefulWidget {
  const SalesDetailReport({super.key});

  @override
  ConsumerState<SalesDetailReport> createState() {
    return _SalesDetailReportState();
  }
}

class _SalesDetailReportState extends ConsumerState<SalesDetailReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Details',
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).myBlueColorDark)),
      ),
      body: SingleChildScrollView(),
    );
  }
}
