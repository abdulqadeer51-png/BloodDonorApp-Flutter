import 'package:flutter/material.dart';
import 'package:blooddonerapp/screens/donorprofilescreen/donorprofilescreen.dart';
import 'package:blooddonerapp/screens/finddonnerscreen/finddonnerscreen.dart';
import 'package:blooddonerapp/screens/homescreen/homescreen.dart';

class DonateBloodScreen extends StatefulWidget {
  const DonateBloodScreen({super.key});

  @override
  State<DonateBloodScreen> createState() => _DonateBloodScreenState();
}

class _DonateBloodScreenState extends State<DonateBloodScreen> {
  static const Color primaryRed = Color(0xFFD92D3A);

  int currentIndex = 2;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  String? _selectedBloodGroup;
  bool _isAvailable = true;

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get pageBackground => Theme.of(context).scaffoldBackgroundColor;
  Color get cardBackground => Theme.of(context).cardColor;
  Color get primaryText => Theme.of(context).colorScheme.onSurface;
  Color get secondaryText => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get borderColor => Theme.of(context).dividerColor;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void openTab(int index) {
    if (index == 2) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FindDonorScreen(donors: [])),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DonorProfileScreen()),
        );
        break;
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: secondaryText),
      hintStyle: TextStyle(color: secondaryText.withValues(alpha: 0.8)),
      prefixIcon: Icon(icon, color: primaryRed, size: 22),
      filled: true,
      fillColor: cardBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: primaryRed, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  Map<String, dynamic> _createDonorData() {
    return {
      'name': _nameController.text.trim(),
      'blood': _selectedBloodGroup!,
      'phone': _phoneController.text.trim(),
      'city': _cityController.text.trim(),
      'area': _areaController.text.trim(),
      'available': _isAvailable,
    };
  }

  bool _validateForm() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return false;

    if (_selectedBloodGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your blood group.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    return true;
  }

  void _previewListing() {
    if (!_validateForm()) return;

    final donor = _createDonorData();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardBackground,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              const Icon(Icons.fact_check_outlined, color: primaryRed),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Review Your Details',
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryRed.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryRed,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          donor['blood'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              donor['name'].toString(),
                              style: TextStyle(
                                color: primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${donor['area']}, ${donor['city']}',
                              style: TextStyle(color: secondaryText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _previewRow('Phone', donor['phone'].toString()),
                _previewRow(
                  'Availability',
                  donor['available'] == true ? 'Available' : 'Unavailable',
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your details before publishing.',
                  style: TextStyle(color: secondaryText, fontSize: 12),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Edit Details',
                style: TextStyle(color: secondaryText),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _publishListing();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Publish'),
            ),
          ],
        );
      },
    );
  }

  Widget _previewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: secondaryText, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _publishListing() {
    if (!_validateForm()) return;

    // Returns the donor data to the previous screen.
    // Permanent storage will be added during the data/Firebase phase.
    Navigator.pop(context, _createDonorData());
  }

  Widget _sectionHeading(String title, String subtitle) {
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
        const SizedBox(height: 5),
        Text(subtitle, style: TextStyle(color: secondaryText, fontSize: 13)),
      ],
    );
  }

  Widget _buildDonationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3424D), Color(0xFFB91525)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Be Someone’s Hero',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your blood donation can give someone another chance at life.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.favorite_rounded, color: Colors.white, size: 17),
              const SizedBox(width: 7),
              Text(
                'Donate blood. Share hope.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor.withValues(alpha: 0.7)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeading(
              'Your Information',
              'Enter accurate details so recipients can contact you.',
            ),
            const SizedBox(height: 22),

            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: primaryText),
              decoration: _inputDecoration(
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                if (value.trim().length < 3) {
                  return 'Name must contain at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 17),

            DropdownButtonFormField<String>(
              initialValue: _selectedBloodGroup,
              dropdownColor: cardBackground,
              style: TextStyle(color: primaryText, fontSize: 15),
              icon: Icon(Icons.keyboard_arrow_down, color: secondaryText),
              decoration: _inputDecoration(
                label: 'Blood Group',
                icon: Icons.bloodtype_outlined,
              ),
              hint: Text(
                'Select your blood group',
                style: TextStyle(color: secondaryText),
              ),
              items: _bloodGroups.map((group) {
                return DropdownMenuItem<String>(
                  value: group,
                  child: Text(
                    group,
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedBloodGroup = value);
              },
              validator: (value) {
                if (value == null) return 'Please select your blood group';
                return null;
              },
            ),
            const SizedBox(height: 17),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: primaryText),
              decoration: _inputDecoration(
                label: 'Mobile Number',
                icon: Icons.phone_outlined,
                hint: '03XXXXXXXXX',
              ),
              validator: (value) {
                final phone = (value ?? '').replaceAll(RegExp(r'[\s\-()]'), '');
                final valid = RegExp(r'^(03\d{9}|\+923\d{9}|923\d{9})$')
                    .hasMatch(phone);

                if (phone.isEmpty) return 'Please enter your mobile number';
                if (!valid) {
                  return 'Enter a valid Pakistani number';
                }
                return null;
              },
            ),
            const SizedBox(height: 17),

            TextFormField(
              controller: _cityController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: primaryText),
              decoration: _inputDecoration(
                label: 'City',
                icon: Icons.location_city_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
            ),
            const SizedBox(height: 17),

            TextFormField(
              controller: _areaController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              style: TextStyle(color: primaryText),
              decoration: _inputDecoration(
                label: 'Area / Locality',
                icon: Icons.location_on_outlined,
                hint: 'e.g. Hayatabad, Saddar',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your area';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withValues(alpha: 0.7)),
      ),
      child: SwitchListTile(
        tileColor: cardBackground,
        selectedTileColor: cardBackground,
        splashRadius: 24,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        activeThumbColor: Colors.white,
        activeTrackColor: primaryRed,
        inactiveTrackColor: borderColor,
        secondary: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: primaryRed.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.volunteer_activism_outlined,
            color: primaryRed,
          ),
        ),
        title: Text(
          'Available to Donate',
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            _isAvailable
                ? 'Recipients can contact you for donation.'
                : 'Your donor listing will show you as unavailable.',
            style: TextStyle(color: secondaryText, fontSize: 12),
          ),
        ),
        value: _isAvailable,
        onChanged: (value) {
          setState(() => _isAvailable = value);
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: _previewListing,
            icon: const Icon(Icons.visibility_outlined, size: 20),
            label: const Text(
              'Preview My Listing',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryRed,
              side: const BorderSide(color: primaryRed, width: 1.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: _publishListing,
            icon: const Icon(Icons.favorite_rounded, size: 20),
            label: const Text(
              'Publish Donor Listing',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        title: const Text(
          'Donate Blood',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD92D3A),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDonationBanner(),
              const SizedBox(height: 25),
              _buildFormCard(),
              const SizedBox(height: 20),
              _buildAvailabilityCard(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Your kindness can make a difference.',
                  style: TextStyle(color: secondaryText, fontSize: 12),
                ),
              ),
            ],
          ),
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
        onTap: openTab,
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
