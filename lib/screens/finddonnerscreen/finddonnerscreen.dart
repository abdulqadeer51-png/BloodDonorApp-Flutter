import 'package:blooddonerapp/screens/donatebloodscreen/donatebloodscreen.dart';
import 'package:blooddonerapp/screens/donorprofilescreen/donorprofilescreen.dart';
import 'package:blooddonerapp/screens/homescreen/donordetailscreen/donordetailscreen.dart';
import 'package:blooddonerapp/screens/homescreen/homescreen.dart';
import 'package:blooddonerapp/data/donordata.dart';
import 'package:flutter/material.dart';

class FindDonorScreen extends StatefulWidget {
  final List<Map<String, dynamic>> donors;

  const FindDonorScreen({super.key, required this.donors});

  @override
  State<FindDonorScreen> createState() => _FindDonorScreenState();
}

class _FindDonorScreenState extends State<FindDonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();

  static const Color red = Color(0xFFD71920);

  int currentIndex = 1;
  String? _selectedGroup;

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  List<Map<String, dynamic>> searchResults = [];
  bool hasSearched = false;

  void openTab(int index) {
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        ).then((_) {
          if (mounted) setState(() => currentIndex = 1);
        });
        break;

      case 1:
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DonateBloodScreen()),
        ).then((_) {
          if (mounted) setState(() => currentIndex = 1);
        });
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DonorProfileScreen()),
        ).then((_) {
          if (mounted) setState(() => currentIndex = 1);
        });
        break;
    }
  }

  void _searchDonors() {
    if (!_formKey.currentState!.validate()) return;

    final cityOrArea = _cityController.text.trim().toLowerCase();

    final results = DonorData.donors.where((donor) {
      final bloodMatches = donor['blood'] == _selectedGroup;

      final city = (donor['city'] ?? '').toString().toLowerCase();
      final area = (donor['area'] ?? '').toString().toLowerCase();

      final locationMatches =
          city.contains(cityOrArea) || area.contains(cityOrArea);

      return bloodMatches && locationMatches;
    }).toList();

    setState(() {
      searchResults = results;
      hasSearched = true;
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: red,
        foregroundColor: Colors.white,
        title: const Text('Find Blood Donor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.volunteer_activism, color: Colors.white, size: 45),
                  SizedBox(height: 12),
                  Text(
                    'Find a Life Saver',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Search for blood donors in your area.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              'Search Donors',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 14),

            Card(
              color: theme.cardColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Blood Group',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        initialValue: _selectedGroup,
                        dropdownColor: theme.cardColor,
                        style: TextStyle(color: colors.onSurface),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.bloodtype),
                          hintText: 'Choose blood group',
                          border: OutlineInputBorder(),
                        ),
                        items: bloodGroups.map((group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a blood group';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() => _selectedGroup = value);
                        },
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'City or Area',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _cityController,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(color: colors.onSurface),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_on_outlined),
                          hintText: 'e.g. Peshawar',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your city or area';
                          }
                          if (value.trim().length < 2) {
                            return 'Enter a valid city or area';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _searchDonors,
                          icon: const Icon(Icons.search),
                          label: const Text(
                            'Search Donors',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (hasSearched) ...[
              Text(
                'Search Results (${searchResults.length})',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              if (searchResults.isEmpty)
                Card(
                  color: theme.cardColor,
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No matching donors found.\n'
                        'Try another blood group or location.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 225,
                  ),
                  itemBuilder: (context, index) {
                    final donor = searchResults[index];
                    final available = donor['available'] == true;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.15 : 0.04,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 17,
                                backgroundColor: red.withValues(alpha: 0.12),
                                child: const Icon(Icons.person, color: red),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: red.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  donor['blood']?.toString() ?? '',
                                  style: const TextStyle(
                                    color: red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            donor['name']?.toString() ?? 'Donor',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: colors.onSurface,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: colors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  donor['city']?.toString() ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text(
                            donor['area']?.toString() ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 9,
                                color: available ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  available ? 'Available' : 'Unavailable',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: available
                                        ? Colors.green
                                        : colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DonorDetailsScreen(donor: donor),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: red,
                                side: const BorderSide(color: red),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],

            const SizedBox(height: 24),

            Text(
              'Helpful Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 10),

            Card(
              color: theme.cardColor,
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: const Icon(
                  Icons.health_and_safety_outlined,
                  color: red,
                  size: 32,
                ),
                title: Text(
                  'Verify donor eligibility',
                  style: TextStyle(color: colors.onSurface),
                ),
                subtitle: Text(
                  'Confirm donor suitability with a qualified '
                  'healthcare professional.',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.cardColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: red,
        unselectedItemColor: colors.onSurfaceVariant,
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
