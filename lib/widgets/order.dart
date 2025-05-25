import 'package:boxk/parts/number_Set.dart';
import 'package:boxk/parts/number_group.dart';
import 'package:boxk/parts/play.dart';
import 'package:boxk/parts/user.dart';
import 'package:boxk/providers/user.dart';
import 'package:boxk/widgets/keyboard.dart';
import 'package:boxk/widgets/number_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderWidget extends ConsumerStatefulWidget {
  const OrderWidget({super.key});

  @override
  ConsumerState<OrderWidget> createState() {
    return _OrderWidgetState();
  }
}

class _OrderWidgetState extends ConsumerState<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const NumberGroup(),
          Row(
            children: [
              const Expanded(
                child: PlayDropdownList(
                  isBlockedCheck: true,
                ),
              ),
              if (ref.watch(currentUserProvider)['role'] != 'User')
                const SizedBox(
                  width: 2,
                ),
              if (ref.watch(currentUserProvider)['role'] != 'User')
                const Expanded(
                  child: UserDropdownList(),
                ),
            ],
          ),
          const NumberSet(),
          const NumberListWidget(),
          const KeyboardWidget(),
        ],
      ),
    );
  }
}
