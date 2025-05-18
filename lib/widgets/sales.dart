import 'package:boxk/colors/color.dart';
import 'package:boxk/providers/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesWidget extends ConsumerStatefulWidget {
  const SalesWidget({super.key});

  @override
  ConsumerState<SalesWidget> createState() {
    return _SalesWidgetState();
  }
}

class _SalesWidgetState extends ConsumerState<SalesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(selectedPage.notifier).update((state) => 5);
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              backgroundColor: Theme.of(context).myBlueColorDark,
            ),
            child: Text(
              'Add New Sales',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
