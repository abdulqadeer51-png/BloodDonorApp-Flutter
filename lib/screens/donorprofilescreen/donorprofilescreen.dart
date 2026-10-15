import 'package:blooddonerapp/screens/donatebloodscreen/donatebloodscreen.dart';
import 'package:blooddonerapp/screens/finddonnerscreen/finddonnerscreen.dart';
import 'package:blooddonerapp/screens/homescreen/homescreen.dart';
import 'package:flutter/material.dart';

class DonorProfileScreen extends StatefulWidget {
  const DonorProfileScreen({super.key});

  @override
  State<DonorProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<DonorProfileScreen> {
  int currentIndex = 3;
  void openTab(int index) {
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        ).then((_) {
          if (mounted) setState(() => currentIndex = 0);
        });
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FindDonorScreen(donors: [])),
        ).then((_) {
          if (mounted) setState(() => currentIndex = 0);
        });
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DonateBloodScreen()),
        ).then((_) {
          if (mounted) setState(() => currentIndex = 0);
        });
        break;
      case 3:
        break;
    }
  }

  static const Color primaryRed = Color(0xFFD71920);

  final TextEditingController _nameController = TextEditingController(
    text: 'Your Name',
  );

  final TextEditingController _emailController = TextEditingController(
    text: 'yourname@email.com',
  );

  final TextEditingController _phoneController = TextEditingController(
    text: '',
  );

  final TextEditingController _cityController = TextEditingController(text: '');

  bool _darkMode = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _editProfile() {
    final nameController = TextEditingController(text: _nameController.text);
    final phoneController = TextEditingController(text: _phoneController.text);
    final cityController = TextEditingController(text: _cityController.text);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Personal Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _nameController.text = nameController.text.trim();
                  _phoneController.text = phoneController.text.trim();
                  _cityController.text = cityController.text.trim();
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated for this session'),
                  ),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color background = _darkMode
        ? const Color(0xFF171717)
        : const Color(0xFFF7F7F7);
    final Color surface = _darkMode ? const Color(0xFF252525) : Colors.white;
    final Color textColor = _darkMode ? Colors.white : const Color(0xFF222222);
    final Color secondaryColor = _darkMode
        ? Colors.white70
        : Colors.grey.shade600;

    return Theme(
      data: _darkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: background,
              colorScheme: const ColorScheme.dark(
                primary: primaryRed,
                secondary: primaryRed,
              ),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: background,
              colorScheme: const ColorScheme.light(
                primary: primaryRed,
                secondary: primaryRed,
              ),
            ),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text(
            'My Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: primaryRed,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 55,
                            color: primaryRed,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: primaryRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _nameController.text,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _emailController.text,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: _editProfile,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _infoTile(
                surface: surface,
                textColor: textColor,
                secondaryColor: secondaryColor,
                icon: Icons.person_outline,
                title: 'Full Name',
                value: _nameController.text,
              ),
              _infoTile(
                surface: surface,
                textColor: textColor,
                secondaryColor: secondaryColor,
                icon: Icons.email_outlined,
                title: 'Email Address',
                value: _emailController.text,
              ),
              _infoTile(
                surface: surface,
                textColor: textColor,
                secondaryColor: secondaryColor,
                icon: Icons.phone_outlined,
                title: 'Mobile Number',
                value: _phoneController.text.isEmpty
                    ? 'Not added'
                    : _phoneController.text,
              ),
              _infoTile(
                surface: surface,
                textColor: textColor,
                secondaryColor: secondaryColor,
                icon: Icons.location_city_outlined,
                title: 'City',
                value: _cityController.text.isEmpty
                    ? 'Not added'
                    : _cityController.text,
              ),

              const SizedBox(height: 18),

              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  value: _darkMode,
                  activeThumbColor: primaryRed,
                  secondary: const Icon(
                    Icons.dark_mode_outlined,
                    color: primaryRed,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  subtitle: Text(
                    'Change the appearance of this screen',
                    style: TextStyle(color: secondaryColor),
                  ),
                  onChanged: (value) {
                    setState(() => _darkMode = value);
                  },
                ),
              ),

              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: primaryRed),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: secondaryColor,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text(
                          'Logout functionality will be connected '
                          'with Firebase later.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: primaryRed,
          unselectedItemColor: Colors.grey.shade600,
          onTap: openTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Find Donors',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism_outlined),
              label: 'Donate Blood',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required Color surface,
    required Color textColor,
    required Color secondaryColor,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryRed.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryRed),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 13, color: secondaryColor),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
