import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_service.dart';
import 'view_model/login_view_model.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (context) =>
          LoginViewModel(authService: context.read<AuthService>()),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LoginForm(
            viewModel: context.read<LoginViewModel>(),
            authService: context.read<AuthService>(),
          ),
        ),
      ),
    );
  }
}
