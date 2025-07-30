import 'package:flutter/material.dart';
import 'dart:math'; // Import for random number generation

class DeliveryBoyScreen extends StatefulWidget {
  final String riderId; // This can now be an optional hint or ignored if random selection is always desired

  const DeliveryBoyScreen({super.key, this.riderId = ''}); // Made riderId optional

  @override
  State<DeliveryBoyScreen> createState() => _DeliveryBoyScreenState();
}

class _DeliveryBoyScreenState extends State<DeliveryBoyScreen> {
  Map<String, dynamic>? _riderData;
  double _currentRating = 0.0; // For the star rating
  final TextEditingController _commentController = TextEditingController();

  // Hardcoded rider data using the specified assets
  final List<Map<String, dynamic>> _allRidersData = [
    {
      "riderId": "rider_001",
      "name": "Ronald Richards",
      "profileImageUrl": "assets/rider_profile_1.jpg",
      "bikeNumber": "AMR7282",
      "bikeModel": "Ninja H2r",
      "memberSince": "1 December 2023",
      "rating": 4.5,
      "yearsExperience": 2,
      "phoneNumber": "+1234567890",
      "chatId": "rider_chat_001",
      "backgroundImageUrl": "assets/rider_background_1.jpg"
    },
    {
      "riderId": "rider_002",
      "name": "Jane Doe",
      "profileImageUrl": "assets/rider_profile_2.jpg",
      "bikeNumber": "XYZ9876",
      "bikeModel": "Honda CBR",
      "memberSince": "15 March 2022",
      "rating": 4.8,
      "yearsExperience": 3,
      "phoneNumber": "+0987654321",
      "chatId": "rider_chat_002",
      "backgroundImageUrl": "assets/rider_background_2.jpg"
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchRiderData(); // Now fetches randomly from the hardcoded list
  }

  // Modified to randomly select a rider from the hardcoded list
  Future<void> _fetchRiderData() async {
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate a small loading delay

    setState(() {
      final random = Random();
      // Randomly pick one of the two riders
      _riderData = _allRidersData[random.nextInt(_allRidersData.length)];
      _currentRating = (_riderData!['rating'] as num?)?.toDouble() ?? 0.0;
    });
  }

  // Function to handle feedback (without Firestore)
  void _submitFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Feedback submitted for ${_riderData!['name']}: Rating $_currentRating, Comment: ${_commentController.text}'),
      ),
    );
    // Optionally navigate back or to another screen after submission
    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_riderData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                _riderData!['backgroundImageUrl'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container( // Fallback to a grey container with broken image icon
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '60+', // This seems to be a static element from previous screens
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture and Action Buttons
                      Align(
                        alignment: Alignment.center,
                        child: Transform.translate(
                          offset: const Offset(0, -50), // Move avatar up
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(_riderData!['profileImageUrl']),
                                onBackgroundImageError: (exception, stackTrace) {
                                  // Fallback to a default icon if image fails to load
                                  setState(() {
                                    _riderData!['profileImageUrl'] = 'assets/rider_profile_1.jpg'; // Fallback to one of the allowed assets
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildActionButton(Icons.star, "${_riderData!['rating']} rating", Colors.amber, () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Show rider ratings')),
                                    );
                                  }),
                                  const SizedBox(width: 10),
                                  _buildActionButton(Icons.call, "Call", Colors.green, () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Calling ${_riderData!['phoneNumber']}')),
                                    );
                                  }),
                                  const SizedBox(width: 10),
                                  _buildActionButton(Icons.message, "Message", Colors.blue, () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Messaging ${_riderData!['name']}')),
                                    );
                                  }),
                                  const SizedBox(width: 10),
                                  _buildActionButton(Icons.access_time, "${_riderData!['yearsExperience']} years", Colors.grey, () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Rider experience details')),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Adjust spacing after avatar and buttons

                      // Rider Details
                      _buildDetailRow("Driver Name", _riderData!['name']),
                      _buildDetailRow("Bike Number", _riderData!['bikeNumber']),
                      _buildDetailRow("Bike Model", _riderData!['bikeModel']),
                      _buildDetailRow("Member Since", _riderData!['memberSince']),
                      const SizedBox(height: 30),

                      // How was the Delivery? Section
                      const Text(
                        "How was the Delivery?",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < _currentRating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 40,
                              ),
                              onPressed: () {
                                setState(() {
                                  _currentRating = (index + 1).toDouble();
                                });
                              },
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Text(
                          "Your feedback is anonymous",
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Leave a comment section
                      TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "Leave a comment",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 30),

                      // Done Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitFeedback(); // Call the submit feedback function (now without Firestore)
                            // Optionally navigate back or to another screen after submission
                            Navigator.popUntil(context, ModalRoute.withName('/home'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD28A3C), // Orange-brown color
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Done",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for action buttons (rating, call, message, years)
  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color.withOpacity(0.1),
          child: IconButton(
            icon: Icon(icon, color: color, size: 20),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }

  // Helper widget for rider detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ), // Corrected: removed extra ')' and ';'
    );
  }
}
