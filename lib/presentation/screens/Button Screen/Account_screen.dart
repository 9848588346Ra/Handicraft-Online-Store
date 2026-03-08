import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/data/profile_provider.dart';
import 'package:handicraft_online_store/domain/entities/user_entity.dart';
import 'package:handicraft_online_store/data/admin_provider.dart';
import 'package:handicraft_online_store/core/services/auto_brightness_service.dart';
import 'package:handicraft_online_store/core/services/biometric_auth_service.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/about_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/admin_product_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/delivery_address_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/help_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/my_details_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/orders_screen.dart';
import 'package:handicraft_online_store/presentation/screens/admin_login_screen.dart';
import 'package:handicraft_online_store/presentation/screens/face_lock_verification_screen.dart';
import 'package:handicraft_online_store/presentation/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_settings/app_settings.dart';

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
            child: const Text('Logout', style: TextStyle(color: _primaryPurple, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        final isAdmin = AdminProvider.instance.isAdminLoggedIn;
        if (isAdmin) {
          await AdminProvider.instance.logout();
        } else if (InjectionContainer().isInitialized) {
          await InjectionContainer().logoutUseCase.call();
        }
        await BiometricAuthService.instance.disableFaceLock();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out successfully'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
          );
        }
      }
    }
  }

  Future<void> _pickProfileImage(ImageSource source, UserEntity user) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 512, maxHeight: 512, imageQuality: 85);
    if (picked != null) {
      await ProfileProvider.instance.updateProfile(email: user.email, profileImagePath: picked.path);
      if (mounted) setState(() {});
    }
  }

  Future<void> _handleFaceLockOption(BuildContext context) async {
    final container = InjectionContainer();
    if (!container.isInitialized) await container.init();
    final user = await container.getCurrentUserUseCase.call();
    if (user == null || user.email.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in first to use Face Lock'), behavior: SnackBarBehavior.floating),
        );
      }
      return;
    }

    final bio = BiometricAuthService.instance;
    final isEnabled = await bio.isFaceLockEnabled();
    if (isEnabled) {
      final disable = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Face Lock'),
          content: const Text('Face Lock is enabled. Do you want to disable it?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Disable', style: TextStyle(color: _primaryPurple, fontWeight: FontWeight.w600))),
          ],
        ),
      );
      if (disable == true) {
        await bio.disableFaceLock();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Face Lock disabled'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
          );
        }
      }
      return;
    }

    if (context.mounted) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (ctx) => FaceLockVerificationScreen(
            isEnabling: true,
            userEmail: user.email,
            userName: user.name,
          ),
        ),
      );
      if (result == true && context.mounted) {
        setState(() {});
      }
    }
  }

  void _showBrightnessDialog(BuildContext context) {
    final svc = AutoBrightnessService.instance;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Brightness'),
        content: const Text(
          'If auto brightness doesn\'t work on your device, use these to adjust manually. For stronger dimming, enable "Modify system settings" in App Settings.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppSettings.openAppSettings();
              Navigator.pop(ctx);
            },
            child: const Text('App Settings'),
          ),
          TextButton(
            onPressed: () async {
              await svc.setLowBrightness();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Screen dimmed'), behavior: SnackBarBehavior.floating),
                );
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.brightness_low, size: 20),
                SizedBox(width: 8),
                Text('Dim'),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              await svc.setFullBrightness();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Full brightness'), behavior: SnackBarBehavior.floating),
                );
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.brightness_high, size: 20),
                SizedBox(width: 8),
                Text('Full'),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              await svc.resetBrightness();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Brightness reset'), behavior: SnackBarBehavior.floating),
                );
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context, UserEntity user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Change profile photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.camera_alt, color: _primaryPurple),
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickProfileImage(ImageSource.camera, user);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.photo_library, color: _primaryPurple),
                  ),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickProfileImage(ImageSource.gallery, user);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              _buildAdminSection(context),
              const SizedBox(height: 20),
              _buildSectionTitle('Account'),
              const SizedBox(height: 12),
              _buildOptionsCard(context),
              const SizedBox(height: 24),
              _buildLogoutOrLoginButton(context),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.person_outline, color: _primaryPurple, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87)),
                Text('Manage your profile & settings', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
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
      builder: (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
        final user = snapshot.data;
        final profile = ProfileProvider.instance;
        final name = profile.name?.isNotEmpty == true ? profile.name! : (user?.name.isNotEmpty == true ? user!.name : 'User');
        final email = user?.email.isNotEmpty == true ? user!.email : '';
        final phone = profile.phone;
        final address = profile.address;

        return ListenableBuilder(
          listenable: ProfileProvider.instance,
          builder: (BuildContext ctx, _) {
            final currentImagePath = ProfileProvider.instance.profileImagePath;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: user != null ? () => _openMyDetails(ctx, user) : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: user != null ? () => _showImagePickerOptions(ctx, user) : null,
                            child: Stack(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(color: _lightBlue, borderRadius: BorderRadius.circular(20), border: Border.all(color: _primaryPurple.withOpacity(0.2))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: currentImagePath != null && File(currentImagePath).existsSync()
                                        ? Image.file(File(currentImagePath), fit: BoxFit.cover)
                                        : Icon(Icons.person, size: 40, color: _primaryPurple.withOpacity(0.8)),
                                  ),
                                ),
                                if (user != null)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: _primaryPurple, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
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
                                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87)),
                                if (email.isNotEmpty)
                                  Text(email, style: TextStyle(fontSize: 14, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis)
                                else
                                  Text('Sign in to sync your profile', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
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
                        Expanded(child: Text(phone, style: TextStyle(fontSize: 14, color: Colors.grey.shade700), overflow: TextOverflow.ellipsis)),
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
                        Expanded(child: Text(address, style: TextStyle(fontSize: 14, color: Colors.grey.shade700), maxLines: 2, overflow: TextOverflow.ellipsis)),
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
  },
    );
  }

  Future<void> _openMyDetails(BuildContext context, UserEntity user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyDetailsScreen(
          user: user,
        ),
      ),
    );
    if (result == true && mounted) setState(() {});
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold', color: Colors.grey.shade800)),
    );
  }

  Widget _buildOptionsCard(BuildContext context) {
    final options = [
      _AccountOption(Icons.receipt_long_outlined, 'My Orders', 'View your order history', () async {
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersScreen(onStartShopping: () => Navigator.pop(context, 'goToShop'))));
        if (result == 'goToShop' && context.mounted) widget.onNavigateToShop?.call();
      }),
      _AccountOption(Icons.badge_outlined, 'My Details', 'Update your profile', () async {
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDetailsScreen()));
        if (result == true && mounted) setState(() {});
      }),
      _AccountOption(Icons.location_on_outlined, 'Delivery Address', 'Manage addresses', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryAddressScreen()))),
      _AccountOption(Icons.face_retouching_natural, 'Face Lock', 'Sign in with Face ID or fingerprint', () => _handleFaceLockOption(context)),
      _AccountOption(Icons.brightness_6_outlined, 'Brightness', 'Dim or brighten screen manually', () => _showBrightnessDialog(context)),
      _AccountOption(Icons.help_outline, 'Help', 'FAQs & support', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreen()))),
      _AccountOption(Icons.info_outline, 'About', 'App version & info', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()))),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          for (int i = 0; i < options.length; i++) ...[
            _buildOptionTile(options[i]),
            if (i < options.length - 1) Divider(height: 1, indent: 72, endIndent: 16, color: Colors.grey.shade100),
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
              decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: Icon(option.icon, size: 22, color: _primaryPurple),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold', color: Colors.black87)),
                  if (option.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(option.subtitle!, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminSection(BuildContext context) {
    return ListenableBuilder(
      listenable: AdminProvider.instance,
      builder: (context, _) {
        final isAdmin = AdminProvider.instance.isAdminLoggedIn;
        if (isAdmin) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Admin'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildAdminOption(context, Icons.inventory_2_outlined, 'Manage Product', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminProductScreen()));
                }),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAdminOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, size: 22, color: _primaryPurple),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold', color: Colors.black87))),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutOrLoginButton(BuildContext context) {
    return FutureBuilder<UserEntity?>(
      future: _loadUserAndProfile(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final isLoggedIn = user != null && user.email.isNotEmpty;
        final isAdmin = AdminProvider.instance.isAdminLoggedIn;

        if (isLoggedIn || isAdmin) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
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
                        Text('Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold', color: Colors.red.shade400)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primaryPurple.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, size: 22, color: _primaryPurple),
                          const SizedBox(width: 12),
                          Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold', color: _primaryPurple)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primaryPurple.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.admin_panel_settings, size: 22, color: _primaryPurple),
                          const SizedBox(width: 12),
                          Text('Login as Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold', color: _primaryPurple)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
