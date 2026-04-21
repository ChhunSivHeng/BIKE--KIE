import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/auth_service.dart';
import '../view_model/login_view_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_field.dart';
import '../../../widgets/app_message.dart';
import 'login_header.dart';

/// LoginForm Widget
///
/// Orchestrates login UI using ViewModel for state management.
/// Separates concerns:
/// - UI rendering: this widget
/// - State & logic: LoginViewModel
/// - Authentication: AuthService
class LoginForm extends StatefulWidget {
  final AuthService authService;

  const LoginForm({super.key, required this.authService});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _userIdController;
  late LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController();
    _viewModel = LoginViewModel(authService: widget.authService);
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final success = await _viewModel.login(_userIdController.text);
    if (success && mounted) {
      // AuthService state changed, UI will rebuild via Consumer
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: _viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ===== HEADER =====
                const LoginHeader(),
                const SizedBox(height: 48),

                // ===== INPUT FIELD =====
                AppInputField(
                  label: 'User ID',
                  controller: _userIdController,
                  hintText: 'Enter your user ID (e.g., user_001)',
                  error: viewModel.errorMessage,
                  enabled: !viewModel.isLoading,
                  prefixIcon: Icons.person,
                  onSubmit: _handleLogin,
                  onChanged: (_) {
                    if (viewModel.hasError) {
                      viewModel.clearError();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // ===== ERROR MESSAGE =====
                if (viewModel.hasError)
                  AppMessage(
                    message: viewModel.errorMessage ?? 'An error occurred',
                    isError: true,
                    onDismiss: viewModel.clearError,
                  ),
                const SizedBox(height: 24),

                // ===== LOGIN BUTTON =====
                AppButton(
                  label: 'Login',
                  onPressed: _handleLogin,
                  isLoading: viewModel.isLoading,
                  enabled: !viewModel.isLoading,
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
