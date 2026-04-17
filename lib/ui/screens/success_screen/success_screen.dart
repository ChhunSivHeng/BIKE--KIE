import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/success_model.dart';
import 'widgets/success_content.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuccessModel(),
      child: const SuccessContent(),
    );
  }
}
