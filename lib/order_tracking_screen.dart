import 'package:flutter/material.dart';
import 'delivery_boy_screen.dart'; // Import DeliveryBoyScreen

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  // We no longer need the trackingSteps list as the design is different.
  // Placeholder data for the new design elements
  final String orderId = "#324561324";
  final String orderDescription = "Birthdays gifts";
  final String deliveryTimeSlot = "10 AM – 1 PM";
  final String customerName = "Holden Caulfield";
  final String deliveryAddress = "2464 Royal Ln. Mesa, New Jersey 45463";
  final String orderType = "Own terms";
  final double orderCost = 129.00;
  final String paymentMethod = "Mastercard ---0034";
  final String orderStatus = "Paid";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to home screen (or previous screen)
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          },
        ),
        title: const Text(
          "Order Tracking", // Title remains "Order Tracking"
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Distance, Time Left, Arrival
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTopInfoColumn("2.8 mile", "distance"),
                _buildTopInfoColumn("2:23 min", "Time left"),
                _buildTopInfoColumn("9:44 AM", "Arrival"),
              ],
            ),
            const SizedBox(height: 20),

            // Visual Progress Indicator (Box to Pin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2, size: 30, color: Colors.black), // Box icon
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 4,
                          color: Colors.grey[300], // Background line
                        ),
                        Container(
                          height: 4,
                          width: MediaQuery.of(context).size.width * 0.5, // Example progress (50%)
                          color: Colors.purple, // Progress line color
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.location_on, size: 30, color: Colors.red), // Pin icon
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order ID and Description Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100], // Light grey background
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2, size: 40, color: Colors.black), // Box icon
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderId,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          orderDescription,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      deliveryTimeSlot,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Customer Information Section
            const Text(
              "Customer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customerName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline, color: Colors.red), // Chat icon
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chat with customer functionality')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          deliveryAddress,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100], // Light grey background
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Type of order:", orderType),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Order cost:", "\$${orderCost.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Payment method:", paymentMethod),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Status:", orderStatus),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Contact Support Button (retained from previous version)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact Support functionality')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Contact Support",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some space before the new button
            // NEW: Button to navigate to Delivery Boy Screen
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Delivery Boy screen, passing a sample rider ID
                  // In a real app, you would pass the actual riderId associated with this order
                  Navigator.pushNamed(context, '/delivery_boy', arguments: 'rider_001');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // A distinct color for this button
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "View Delivery Boy Details",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for top info columns (distance, time, arrival)
  Widget _buildTopInfoColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // Helper widget for order summary rows
  Widget _buildSummaryRow(String label, String value) {
    return Row(
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
    );
  }
}
