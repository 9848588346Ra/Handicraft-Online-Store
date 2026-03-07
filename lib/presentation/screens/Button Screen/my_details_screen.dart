import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handicraft_online_store/core/di/injection_container.dart';
import 'package:handicraft_online_store/data/profile_provider.dart';
import 'package:handicraft_online_store/domain/entities/user_entity.dart';
import 'package:image_picker/image_picker.dart';

class MyDetailsScreen extends StatefulWidget {
  const MyDetailsScreen({
    super.key,
    this.user,
  });

  final UserEntity? user;

  static const Color _primaryPurple = Color(0xFF5E35B1);

  @override
  State<MyDetailsScreen> createState() => _MyDetailsScreenState();
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  UserEntity? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    UserEntity? user = widget.user;
    if (user == null) {
      try {
        final container = InjectionContainer();
        if (container.isInitialized) {
          user = await container.getCurrentUserUseCase.call();
        }
      } catch (_) {}
    }

    if (user != null) {
      _user = user;
      await ProfileProvider.instance.loadForUser(user.email);
      _nameController.text = ProfileProvider.instance.name ?? user.name;
      _phoneController.text = ProfileProvider.instance.phone ?? '';
      _addressController.text = ProfileProvider.instance.address ?? '';
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 512, maxHeight: 512, imageQuality: 85);
    if (picked != null && _user != null) {
      await ProfileProvider.instance.updateProfile(
        email: _user!.email,
        profileImagePath: picked.path,
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _user == null) return;

    await ProfileProvider.instance.updateProfile(
      email: _user!.email,
      name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      profileImagePath: ProfileProvider.instance.profileImagePath,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Details'),
          backgroundColor: MyDetailsScreen._primaryPurple,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Details'),
          backgroundColor: MyDetailsScreen._primaryPurple,
        ),
        body: const Center(
          child: Text('Please log in to view your details'),
        ),
      );
    }

    return ListenableBuilder(
      listenable: ProfileProvider.instance,
      builder: (context, _) {
        final profileImagePath = ProfileProvider.instance.profileImagePath;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Details',
              style: TextStyle(
                fontFamily: 'open sans bold',
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: MyDetailsScreen._primaryPurple,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: profileImagePath != null
                          ? FileImage(File(profileImagePath))
                          : null,
                      child: profileImagePath == null
                          ? Icon(Icons.person, size: 56, color: Colors.grey.shade500)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to change photo',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MyDetailsScreen._primaryPurple, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _user!.email,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v != null && v.trim().isNotEmpty) {
                        final digits = v.replaceAll(RegExp(r'\D'), '');
                        if (digits.length < 10) return 'Enter a valid phone number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MyDetailsScreen._primaryPurple, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MyDetailsScreen._primaryPurple, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyDetailsScreen._primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'open sans bold',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
