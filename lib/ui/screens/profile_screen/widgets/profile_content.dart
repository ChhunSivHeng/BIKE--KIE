import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/app_theme.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_button.dart';
import '../view_model/user_profile_view_model.dart';
import 'pass_status_card.dart';
import 'no_pass_card.dart';

/// Profile screen content
///
/// Displays:
/// 1. User header with name and email
/// 2. Pass status (active pass or subscribe CTA)
/// 3. Logout button
class ProfileContent extends StatelessWidget {
  static const int _passPage = 0;
  final Function(int newTab) switchTab;
  const ProfileContent({super.key, required this.switchTab});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        if (viewModel.error != null) {
          return Center(
            child: Text(
              viewModel.error ?? 'Unknown error',
              style: const TextStyle(color: AppColors.gray600),
            ),
          );
        }

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Header
              AppAvatar(
                name: viewModel.userDisplayName,
                email: viewModel.userEmail,
              ),
              const SizedBox(height: 32),

              // Pass Status Section
              Text(
                'YOUR PASS STATUS',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.gray600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              if (viewModel.hasActivePass) ...[
                PassStatusCard(
                  passType: viewModel.passType ?? 'Unknown',
                  validUntil: viewModel.passValidUntil ?? 'N/A',
                  price: viewModel.passPrice ?? '0',
                ),
              ] else ...[
                NoPassCard(
                  onSubscribe: () => switchTab(_passPage), // switch to page 0 which is tha pass browsing page
                ),
              ],
              const SizedBox(height: 32),

              // Logout Button
              AppButton(
                label: viewModel.isLoggingOut ? 'Logging out...' : 'Logout',
                onPressed: () async {
                  final success = await viewModel.logout();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ Logged out successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                isLoading: viewModel.isLoggingOut,
                enabled: !viewModel.isLoggingOut,
                outlined: true,
                foregroundColor: Colors.red,
                icon: Icons.logout,
              ),
            ],
          ),
        );
      },
    );
  }
}
