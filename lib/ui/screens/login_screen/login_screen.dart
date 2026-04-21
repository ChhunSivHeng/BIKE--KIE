import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_service.dart';
import 'view_model/login_view_model.dart';
import 'widgets/login_form.dart';

/// LoginScreen
///
/// Entry point for login flow.
/// Only displayed when user is not authenticated.
///
/// Architecture:
/// - LoginScreen (UI container, dependency injection)
///   ├─ LoginForm (UI orchestrator)
///   │  ├─ LoginViewModel (state & business logic)
///   │  └─ UI Widgets (header, input, button, etc)
///   └─ AuthService (authentication service)
///
/// Principles Applied:
/// - Separation of Concerns: UI, state, and auth are separate
/// - Dependency Injection: AuthService passed to LoginForm
/// - User-Friendly: UX principles applied throughout
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
