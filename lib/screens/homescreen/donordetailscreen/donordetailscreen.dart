
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DonorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> donor;

  const DonorDetailsScreen({
    super.key,
    required this.donor,
  });

  static const Color red = Color(0xFFD71920);

  @override
  Widget build(BuildContext context) {
    final String name = donor['name'] ?? 'Donor';
    final String blood = donor['blood'] ?? 'N/A';
    final String city = donor['city'] ?? 'Not provided';
    final String area = donor['area'] ?? 'Not provided';
    final String phone = donor['phone'] ?? 'Not provided';
    final bool available = donor['available'] == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: red,
        foregroundColor: Colors.white,
        title: const Text(
          'Donor Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Donor profile card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFFFCE7E7),
                    child: const Icon(
                      Icons.person,
                      size: 58,
                      color: red,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE7E7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Blood Group: $blood',
                      style: const TextStyle(
                        color: red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: available ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        available ? 'Available to Donate' : 'Unavailable',
                        style: TextStyle(
                          color: available ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Contact & Location',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _detailRow(
                    icon: Icons.phone_outlined,
                    title: 'Contact Number',
                    value: phone,
                  ),
                  const Divider(height: 26),
                  _detailRow(
                    icon: Icons.location_city,
                    title: 'City',
                    value: city,
                  ),
                  const Divider(height: 26),
                  _detailRow(
                    icon: Icons.location_on_outlined,
                    title: 'Area',
                    value: area,
                  ),
                  const Divider(height: 26),
                  _detailRow(
                    icon: Icons.bloodtype_outlined,
                    title: 'Blood Group',
                    value: blood,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Contact Donor',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Call button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: phone == 'Not provided'
                    ? null
                    : () async {
                        await Clipboard.setData(
                          ClipboardData(text: phone),
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Phone number copied. You can paste it into your phone app.',
                              ),
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.phone),
                label: const Text('Copy Contact Number'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Donors'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: red,
                  side: const BorderSide(color: red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Please confirm donor availability before travelling.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFCE7E7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: red),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
