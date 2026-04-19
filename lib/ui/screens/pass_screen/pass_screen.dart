import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/passRepository/pass_repository.dart';
import 'view_model/pass_model.dart';
import 'widgets/pass_content.dart';

/// Pass browsing and purchase screen
///
/// Displays all available passes and allows users to select and purchase them.
/// Requires PassRepository to be provided via global Provider.
class PassScreen extends StatelessWidget {
  const PassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PassViewModel(passRepository: context.read<PassRepository>())
            ..loadPasses(),
      child: Builder(
        builder: (context) =>
            PassContent(viewModel: context.read<PassViewModel>()),
      ),
    );
  }
}
