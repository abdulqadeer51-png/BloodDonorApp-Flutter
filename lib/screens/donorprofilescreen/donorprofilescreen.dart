import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:blooddonerapp/theme/themecontroller.dart';
import 'package:blooddonerapp/screens/homescreen/homescreen.dart';
import 'package:blooddonerapp/screens/finddonnerscreen/finddonnerscreen.dart';
import 'package:blooddonerapp/screens/donatebloodscreen/donatebloodscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:blooddonerapp/screens/wellcomescreen/wellcomescreen.dart';

class DonorProfileScreen extends StatefulWidget {
  const DonorProfileScreen({super.key});

  @override
  State<DonorProfileScreen> createState() => _DonorProfileScreenState();
}

class _DonorProfileScreenState extends State<DonorProfileScreen> {
  static const Color primaryRed = Color(0xFFD92D3A);

  int currentIndex = 3;
  bool _isLoading = true;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get pageBackground => Theme.of(context).scaffoldBackgroundColor;

  Color get cardBackground => Theme.of(context).cardColor;

  Color get primaryText => Theme.of(context).colorScheme.onSurface;

  Color get secondaryText => Theme.of(context).colorScheme.onSurfaceVariant;

  Color get borderColor => Theme.of(context).dividerColor;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _nameController.text = prefs.getString('profile_name') ?? '';
      _emailController.text = prefs.getString('profile_email') ?? '';
      _phoneController.text = prefs.getString('profile_phone') ?? '';
      _cityController.text = prefs.getString('profile_city') ?? '';

      final path = prefs.getString('profile_image_path');

      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          _profileImage = file;
        }
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
      );

      if (image == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final extension = image.path.contains('.')
          ? image.path.substring(image.path.lastIndexOf('.'))
          : '.jpg';

      final savedFile = await File(image.path)
          .copy('${directory.path}/profile_picture$extension');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', savedFile.path);

      if (!mounted) return;

      setState(() => _profileImage = savedFile);

      _showMessage('Profile picture updated successfully.');
    } catch (e) {
      debugPrint('Profile image error: $e');
      if (mounted) {
        _showMessage('Unable to update picture. Please try again.');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  Future<void> _logout() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      debugPrint('Google sign-out error: $e');
    }

    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('Firebase sign-out completed');
    } catch (e, stackTrace) {
      debugPrint('Firebase sign-out error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }

    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  Future<void> _editProfile() async {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: _nameController.text);
    final emailController = TextEditingController(text: _emailController.text);
    final phoneController = TextEditingController(text: _phoneController.text);
    final cityController = TextEditingController(text: _cityController.text);

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: cardBackground,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              'Edit Personal Details',
              style: TextStyle(color: primaryText, fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _editField(
                      controller: nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      capitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().length < 3) {
                          return 'Enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _editField(
                      controller: emailController,
                      label: 'Gmail Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        final email = (value ?? '').trim();
                        final valid = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')
                            .hasMatch(email);

                        if (!valid) {
                          return 'Enter a valid Gmail address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _editField(
                      controller: phoneController,
                      label: 'Mobile Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        final phone = (value ?? '').trim();

                        if (phone.isNotEmpty &&
                            !RegExp(r'^03[0-9]{9}$').hasMatch(phone)) {
                          return 'Use format 03XXXXXXXXX';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _editField(
                      controller: cityController,
                      label: 'City',
                      icon: Icons.location_city_outlined,
                      capitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your city';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Cancel', style: TextStyle(color: secondaryText)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final prefs = await SharedPreferences.getInstance();

                  await prefs.setString(
                    'profile_name',
                    nameController.text.trim(),
                  );
                  await prefs.setString(
                    'profile_email',
                    emailController.text.trim(),
                  );
                  await prefs.setString(
                    'profile_phone',
                    phoneController.text.trim(),
                  );
                  await prefs.setString(
                    'profile_city',
                    cityController.text.trim(),
                  );

                  if (!mounted || !dialogContext.mounted) return;

                  setState(() {
                    _nameController.text = nameController.text.trim();
                    _emailController.text = emailController.text.trim();
                    _phoneController.text = phoneController.text.trim();
                    _cityController.text = cityController.text.trim();
                  });

                  Navigator.pop(dialogContext);
                  _showMessage('Profile updated successfully.');
                },
                child: const Text('Save Changes'),
              ),
            ],
          );
        },
      );
    } finally {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      cityController.dispose();
    }
  }

  Widget _editField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      validator: validator,
      style: TextStyle(color: primaryText),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryRed),
        filled: true,
        fillColor: pageBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryRed, width: 1.5),
        ),
      ),
    );
  }

  void _openTab(int index) {
    if (index == currentIndex) return;

    final Widget screen;

    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const FindDonorScreen(donors: []);
        break;
      case 2:
        screen = const DonateBloodScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Widget _sectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 5),
          Text(subtitle, style: TextStyle(color: secondaryText, fontSize: 13)),
        ],
      ],
    );
  }

  Widget _profileHeader() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3424D), Color(0xFFB91525)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withValues(alpha: 0.20),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? const Icon(
                          Icons.person_rounded,
                          size: 52,
                          color: primaryRed,
                        )
                      : null,
                ),
              ),
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _pickProfileImage,
                  child: const Padding(
                    padding: EdgeInsets.all(9),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 18,
                      color: primaryRed,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            name.isEmpty ? 'Your Name' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email.isEmpty ? 'Add your email address' : email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 19),
          OutlinedButton.icon(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withValues(alpha: 0.65)),
      ),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          tileColor: cardBackground,
          selectedTileColor: isDark
              ? const Color(0xFF303B4A)
              : const Color(0xFFFFE5E7),
          splashColor: primaryRed.withValues(alpha: 0.15),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: primaryRed.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primaryRed),
          ),
          title: Text(
            title,
            style: TextStyle(color: secondaryText, fontSize: 12),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              value.isEmpty ? 'Not added yet' : value,
              style: TextStyle(
                color: primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withValues(alpha: 0.65)),
      ),
      child: Material(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          tileColor: cardBackground,
          selectedTileColor: cardBackground,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryRed.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: primaryRed),
          ),
          title: Text(
            title,
            style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle,
              style: TextStyle(color: secondaryText, fontSize: 12),
            ),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppThemeController.isDarkMode.value;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD92D3A),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryRed))
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileHeader(),
                  const SizedBox(height: 28),
                  _sectionTitle(
                    'Personal Information',
                    subtitle: 'Your personal contact details',
                  ),
                  const SizedBox(height: 15),
                  _infoTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Full Name',
                    value: _nameController.text,
                  ),
                  _infoTile(
                    icon: Icons.email_outlined,
                    title: 'Email Address',
                    value: _emailController.text,
                  ),
                  _infoTile(
                    icon: Icons.phone_outlined,
                    title: 'Mobile Number',
                    value: _phoneController.text,
                  ),
                  _infoTile(
                    icon: Icons.location_city_outlined,
                    title: 'City',
                    value: _cityController.text,
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Preferences'),
                  const SizedBox(height: 14),
                  _settingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Change the appearance across the app',
                    trailing: Switch(
                      value: isDarkMode,
                      activeThumbColor: Colors.white,
                      activeTrackColor: primaryRed,
                      onChanged: (value) async {
                        await AppThemeController.setDarkMode(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  _settingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: secondaryText,
                    ),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          backgroundColor: cardBackground,
                          title: Text(
                            'Logout',
                            style: TextStyle(color: primaryText),
                          ),
                          content: Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(color: secondaryText),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                _logout();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryRed,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: cardBackground,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: primaryRed,
        unselectedItemColor: secondaryText,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: _openTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Find Donor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism_outlined),
            activeIcon: Icon(Icons.volunteer_activism_rounded),
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
