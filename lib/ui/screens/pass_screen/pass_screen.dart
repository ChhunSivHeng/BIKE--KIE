import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/passRepository/pass_repository.dart';
import '../../../data/repositories/userRepository/user_repository.dart';
import 'view_model/pass_model.dart';
import 'widgets/pass_content.dart';

class PassScreen extends StatelessWidget {
  const PassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PassViewModel(
        passRepository: context.read<PassRepository>(),
        userRepository: context.read<UserRepository>(),
      )..loadPasses(),
      child: Builder(
        builder: (context) =>
            PassContent(viewModel: context.read<PassViewModel>()),
      ),
    );
  }
}
