import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/pass_model.dart';
import 'widgets/pass_content.dart';

class PassScreen extends StatelessWidget {
  const PassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PassViewModel()..loadPasses(),
      child: const PassContent(),
    );
  }
}
