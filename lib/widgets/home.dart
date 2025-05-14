import 'package:boxk/providers/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boxk/colors/color.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() {
    return _HomedWidgetState();
  }
}

class _HomedWidgetState extends ConsumerState<HomeWidget> {
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
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    ref.read(selectedPage.notifier).update((state) => 5);
                  }),
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
                    'Reports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  ref.read(selectedPage.notifier).update((state) => 2);
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
                    'Manage',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
