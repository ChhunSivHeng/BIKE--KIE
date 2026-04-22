import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/userRepository/user_repository.dart';
import '../../../../services/auth_service.dart';
import '../../../../utils/app_theme.dart';
import 'view_model/user_profile_view_model.dart';
import 'widgets/profile_content.dart';

/// Profile screen entry point
///
/// Displays:
/// - User information
/// - Active pass status (if any)
/// - Subscribe to pass CTA (if no pass)
/// - Logout button
///
/// Dependency Injection:
/// - UserRepository, AuthService provided via global Provider
/// - Creates UserProfileViewModel with dependencies
class ProfileScreen extends StatelessWidget {
  final Function(int newTab) switchTab;
  const ProfileScreen({super.key, required this.switchTab});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileViewModel(
        userRepository: context.read<UserRepository>(),
        authService: context.read<AuthService>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.gray50,
        body: ProfileContent(switchTab: switchTab,),
      ),
    );
  }
}
