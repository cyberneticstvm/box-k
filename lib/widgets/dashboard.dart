import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardWidget extends ConsumerStatefulWidget {
  const DashboardWidget({super.key});

  @override
  ConsumerState<DashboardWidget> createState() {
    return _DashboardWidgetState();
  }
}

class _DashboardWidgetState extends ConsumerState<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
