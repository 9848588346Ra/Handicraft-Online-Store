import 'dart:io';

import 'package:flutter/material.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/profile_provider.dart';
import '../../../domain/entities/user_entity.dart';
import '../welcome.dart';
import 'my_details_screen.dart';
import 'orders_screen.dart';

// Consistent with Shop, Explore, Cart design
const Color _primaryPurple = Color(0xFF5E35B1);
const Color _lightBlue = Color(0xFFE3F2FD);

class AccountScreen extends StatefulWidget {
  final VoidCallback? onNavigateToShop;

  const AccountScreen({super.key, this.onNavigateToShop});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  Future<UserEntity?> _loadUserAndProfile() async {
    final user = await InjectionContainer().getCurrentUserUseCase.call();
    if (user != null && user.email.isNotEmpty) {
      await ProfileProvider.instance.loadForUser(user.email);
    }
    return user;
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: _primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        final injectionContainer = InjectionContainer();
        if (injectionContainer.isInitialized) {
          await injectionContainer.logoutUseCase();
        }

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged out successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logging out: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildProfileCard(context),
              const SizedBox(height: 20),
              _buildSectionTitle('Account'),
              const SizedBox(height: 12),
              _buildOptionsCard(context),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline,
              color: _primaryPurple,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'open sans bold',
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Manage your profile & settings',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return FutureBuilder<UserEntity?>(
      future: _loadUserAndProfile(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final profile = ProfileProvider.instance;
        final name = profile.name?.isNotEmpty == true
            ? profile.name!
            : (user?.name.isNotEmpty == true ? user!.name : 'User');
        final email = user?.email.isNotEmpty == true ? user!.email : '';
        final phone = profile.phone;
        final address = profile.address;
        final imagePath = profile.profileImagePath;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: user != null ? () => _openMyDetails(context, user, profile) : null,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _openMyDetails(context, user, profile),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: _lightBlue,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _primaryPurple.withOpacity(0.2)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: imagePath != null && File(imagePath).existsSync()
                                ? Image.file(File(imagePath), fit: BoxFit.cover)
                                : Icon(Icons.person, size: 40, color: _primaryPurple.withOpacity(0.8)),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _primaryPurple,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryPurple.withOpacity(0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'open sans bold',
                            color: Colors.black87,
                          ),
                        ),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ] else
                          Text(
                            'Sign in to sync your profile',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (phone != null && phone.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.phone_outlined, size: 18, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        phone,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (address != null && address.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined, size: 18, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  },
    );
  }

  Future<void> _openMyDetails(BuildContext context, UserEntity? user, ProfileProvider profile) async {
    if (user == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyDetailsScreen(
          userName: profile.name ?? user.name,
          userEmail: user.email,
          profilePhone: profile.phone,
          profileAddress: profile.address,
          profileImagePath: profile.profileImagePath,
        ),
      ),
    );
    if (result == true && mounted) setState(() {});
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'open sans bold',
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildOptionsCard(BuildContext context) {
    final options = [
      _AccountOption(
        Icons.receipt_long_outlined,
        'My Orders',
        'View your order history',
        () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdersScreen(
                onStartShopping: () => Navigator.pop(context, 'goToShop'),
              ),
            ),
          );
          if (result == 'goToShop' && context.mounted) {
            widget.onNavigateToShop?.call();
          }
        },
      ),
      _AccountOption(
        Icons.badge_outlined,
        'My Details',
        'Update your profile',
        () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyDetailsScreen()),
          );
          if (result == true && mounted) setState(() {});
        },
      ),
      _AccountOption(
        Icons.location_on_outlined,
        'Delivery Address',
        'Manage addresses',
        () {},
      ),
      _AccountOption(Icons.help_outline, 'Help', 'FAQs & support', () {}),
      _AccountOption(Icons.info_outline, 'About', 'App version & info', () {}),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < options.length; i++) ...[
            _buildOptionTile(options[i]),
            if (i < options.length - 1)
              Divider(
                height: 1,
                indent: 72,
                endIndent: 16,
                color: Colors.grey.shade100,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionTile(_AccountOption option) {
    return InkWell(
      onTap: option.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _primaryPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(option.icon, size: 22, color: _primaryPurple),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'open sans bold',
                      color: Colors.black87,
                    ),
                  ),
                  if (option.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      option.subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleLogout(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 22, color: Colors.red.shade400),
                  const SizedBox(width: 12),
                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'open sans bold',
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountOption {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  _AccountOption(this.icon, this.label, this.subtitle, this.onTap);
}
