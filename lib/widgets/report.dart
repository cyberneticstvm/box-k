import 'package:boxk/colors/color.dart';
import 'package:boxk/reports/number.dart';
import 'package:boxk/reports/prize.dart';
import 'package:boxk/reports/sales.dart';
import 'package:boxk/reports/winning.dart';
import 'package:boxk/screens/scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportWidget extends ConsumerStatefulWidget {
  const ReportWidget({super.key});

  @override
  ConsumerState<ReportWidget> createState() {
    return _ReportWidgetState();
  }
}

class _ReportWidgetState extends ConsumerState<ReportWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                // Create a gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).myRedColorDark,
                    Theme.of(context).myRedColorLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.article,
                  color: Colors.white,
                  size: 35,
                ),
                title: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Sales Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const SalesReportScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                // Create a gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).myRedColorDark,
                    Theme.of(context).myRedColorLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.article,
                  color: Colors.white,
                  size: 35,
                ),
                title: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Winning Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const WinningReportScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                // Create a gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).myRedColorDark,
                    Theme.of(context).myRedColorLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.article,
                  color: Colors.white,
                  size: 35,
                ),
                title: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Number Wise',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => NumberWiseReport(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                // Create a gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).myAmberColorDark,
                    Theme.of(context).myAmberColorlight,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 35,
                ),
                title: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Account Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  //
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                // Create a gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).myAmberColorDark,
                    Theme.of(context).myAmberColorlight,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 35,
                ),
                title: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Net Pay Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  //
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                // Create a gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).myAmberColorDark,
                    Theme.of(context).myAmberColorlight,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 35,
                ),
                title: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Prize Result',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctxx) => PrizeResultReport(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                // Create a gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).myGreenColorDark,
                    Theme.of(context).myGreenColorLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.article,
                  color: Colors.white,
                  size: 35,
                ),
                title: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Rate & Schemes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const SchemeScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
