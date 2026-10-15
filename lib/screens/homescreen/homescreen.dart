import 'package:blooddonerapp/screens/donatebloodscreen/donatebloodscreen.dart';
import 'package:blooddonerapp/screens/donorprofilescreen/donorprofilescreen.dart';
import 'package:blooddonerapp/screens/finddonnerscreen/finddonnerscreen.dart';
import 'package:blooddonerapp/screens/homescreen/donordetailscreen/donordetailscreen.dart';
import 'package:blooddonerapp/data/donordata.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color red = Color(0xFFD71920);

  int currentIndex = 0;

  // Temporary sample data. Firebase baad mein add hoga.
  List<Map<String, dynamic>> get donors => DonorData.donors;

  void openTab(int index) {
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        break;

        case 1:
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FindDonorScreen(donors: donors),
    ),
  ).then((_) {
    if (mounted) setState(() => currentIndex = 0);
  });
  break;
      case 2:
        Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(builder: (_) => const DonateBloodScreen()),
        ).then((result) {
          if (!mounted) return;

          setState(() {
            currentIndex = 0;

            if (result != null) {
              donors.insert(0, result);
            }
          });

          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Donor profile published successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DonorProfileScreen()),
        ).then((_) {
          if (mounted) setState(() => currentIndex = 0);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: red,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Donor Finder',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            Text('Find a donor. Save a life.', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications will be added later.'),
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Every Drop Counts ❤️',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Connect with blood donors near you.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Only two Quick Actions
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: _quickAction(
                        icon: Icons.search,
                        title: 'Find Blood Donor',
                        subtitle: 'Search by blood group',
                        onTap: () => openTab(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickAction(
                        icon: Icons.volunteer_activism,
                        title: 'Donate Blood',
                        subtitle: 'Share your details',
                        onTap: () => openTab(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Donor grid heading
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 26, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Donors',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${donors.where((d) => d['available'] == true).length} available',
                      style: const TextStyle(
                        color: red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Donor GridView
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final donor = donors[index];

                  return _donorCard(donor);
                }, childCount: donors.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 218,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: red,
        unselectedItemColor: Colors.grey,
        onTap: openTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Donor',
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
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7E7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: red, size: 25),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _donorCard(Map<String, dynamic> donor) {
    final bool available = donor['available'] == true;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DonorDetailsScreen(donor: donor)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: const Color(0xFFFCE7E7),
                  child: const Icon(Icons.person, color: red),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7E7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    donor['blood'],
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
              donor['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 15,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    donor['city'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
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
                    style: TextStyle(
                      fontSize: 11,
                      color: available ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DonorDetailsScreen(donor: donor),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: red,
                  side: const BorderSide(color: red),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
