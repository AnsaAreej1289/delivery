import 'package:flutter/material.dart';
import 'order_tracking_screen.dart'; // <--- NEW: Import OrderTrackingScreen

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Checkmark Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFD28A3C), // Orange-brown color from your theme
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 30),
            // "Order Successfully" Text
            const Text(
              "Order Successfully",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            // Confirmation Message
            Text(
              "Your Order has been placed Successfully",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50), // Add some space at the bottom

            // Changed button to navigate to Order Tracking Screen
            ElevatedButton(
              onPressed: () {
                // Navigate to the order tracking screen
                Navigator.pushNamed(context, '/order_tracking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Example button color
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Track Order", // Changed button text
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10), // Optional: Add space for another button if needed
            TextButton(
              onPressed: () {
                // Navigate back to the home screen and remove all other routes
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              child: const Text(
                "Back to Home",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
