import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart'; // Import CartModel to get total price
import 'order_confirmation_screen.dart'; // Import OrderConfirmationScreen

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // State variables to manage selected payment method and card details
  String _selectedPaymentMethod = 'VISA'; // Default to VISA to match the black card
  Map<String, dynamic> _currentCardDetails = {
    // Initial details reflecting the plain black VISA card (image_47afa7.png)
    'cardHolderName': "", // Empty as per the plain card image
    'cardNumber': "", // Empty as per the plain card image
    'expiryDate': "", // Empty as per the plain card image
    'cardColor': Colors.black, // Conceptual color for a black card
    'cardImage': null, // No logo on the plain black card
    'cardHolderImage': 'assets/master_card.jpg', // The plain black VISA card background
  };

  // Controllers for "Add New Card" dialog
  final TextEditingController _newCardNumberController = TextEditingController();
  final TextEditingController _newExpiryDateController = TextEditingController();
  final TextEditingController _newCardHolderNameController = TextEditingController();

  @override
  void dispose() {
    _newCardNumberController.dispose();
    _newExpiryDateController.dispose();
    _newCardHolderNameController.dispose();
    super.dispose();
  }

  // Function to show the "Add New Card" dialog
  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Card"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _newCardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _newExpiryDateController,
                  decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: _newCardHolderNameController,
                  decoration: const InputDecoration(labelText: 'Card Holder Name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Save Card"),
              onPressed: () {
                setState(() {
                  _currentCardDetails = {
                    'cardHolderName': _newCardHolderNameController.text.isEmpty ? "NEW CARD HOLDER" : _newCardHolderNameController.text.toUpperCase(),
                    'cardNumber': _newCardNumberController.text.isEmpty ? "XXXX XXXX XXXX XXXX" : _newCardNumberController.text,
                    'expiryDate': _newExpiryDateController.text.isEmpty ? "MM/YY" : _newExpiryDateController.text,
                    'cardColor': Colors.blueGrey, // Default color for new cards
                    'cardImage': 'assets/Mastercard.jpg', // Default to Mastercard logo for new cards
                    'cardHolderImage': 'assets/master_card.jpg', // Default to black VISA background for new cards
                  };
                  _selectedPaymentMethod = 'New Card'; // Update selected method
                });
                // Clear controllers after saving
                _newCardNumberController.clear();
                _newExpiryDateController.clear();
                _newCardHolderNameController.clear();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New card added!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context); // Access CartModel for total price

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen (MyCartScreen)
          },
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping to Section
            const Text(
              "Shipping to",
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/location.png', // Updated to location.png
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.map, color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Home",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "387 W. Grey St. Utica,\nPennsylvania 57867",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Change address functionality')),
                      );
                    },
                    child: const Text(
                      "Change",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Payment Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Manage payment methods')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPaymentOption(
                  label: 'Add new',
                  bgColor: _selectedPaymentMethod == 'Add new' ? Colors.blue.withOpacity(0.1) : Colors.grey[200],
                  icon: Icons.add,
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Add new';
                    });
                    _showAddCardDialog();
                  },
                ),
                _buildPaymentOption(
                  label: 'VISA',
                  bgColor: _selectedPaymentMethod == 'VISA' ? Colors.blue.withOpacity(0.1) : Colors.white,
                  imageUrl: 'assets/visa_card.jpg', // Assuming this is a generic VISA card image
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'VISA';
                      _currentCardDetails = {
                        'cardHolderName': "", // Empty as per the plain card image
                        'cardNumber': "", // Empty as per the plain card image
                        'expiryDate': "", // Empty as per the plain card image
                        'cardColor': Colors.black, // Example color for generic VISA
                        'cardImage': null, // No logo on the plain black card
                        'cardHolderImage': 'assets/master_card.jpg', // Use plain black VISA background for VISA option
                      };
                    });
                  },
                ),
                _buildPaymentOption(
                  label: 'PayPal',
                  bgColor: _selectedPaymentMethod == 'PayPal' ? Colors.blue.withOpacity(0.1) : Colors.white,
                  imageUrl: 'assets/paypal.jpg',
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'PayPal';
                      _currentCardDetails = {
                        'cardHolderName': "PAYPAL USER",
                        'cardNumber': "N/A", // PayPal doesn't have a card number
                        'expiryDate': "N/A",
                        'cardColor': Colors.indigo,
                        'cardImage': 'assets/paypal.jpg',
                        'cardHolderImage': 'assets/paypal.jpg', // Assuming paypal.jpg can be background
                      };
                    });
                  },
                ),
                _buildPaymentOption(
                  label: 'Mastercard',
                  bgColor: _selectedPaymentMethod == 'Mastercard' ? Colors.blue.withOpacity(0.1) : Colors.white,
                  imageUrl: 'assets/Mastercard.jpg', // This is the red Mastercard logo
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Mastercard';
                      _currentCardDetails = {
                        'cardHolderName': "CARD HOLDER", // Generic placeholder
                        'cardNumber': "", // Removed card number for Mastercard as requested previously
                        'expiryDate': "XX/XX", // Generic placeholder
                        'cardColor': Colors.red, // Solid red background for Mastercard
                        'cardImage': 'assets/Mastercard.jpg', // Standard Mastercard logo for overlay
                        'cardHolderImage': null, // No specific background image, will use cardColor
                      };
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Credit Card Display
            _buildCreditCard(
              cardHolderImage: _currentCardDetails['cardHolderImage'], // Use the selected card's background image
              cardHolderName: _currentCardDetails['cardHolderName'],
              cardNumber: _currentCardDetails['cardNumber'],
              expiryDate: _currentCardDetails['expiryDate'],
              cardColor: _currentCardDetails['cardColor'],
              cardImage: _currentCardDetails['cardImage'], // This will be used for the logo on the card
            ),
            const SizedBox(height: 24),

            // Total Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${cart.totalPrice.toStringAsFixed(2)}", // Dynamically get total from cart
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Confirm Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to OrderConfirmationScreen
                  Navigator.pushNamed(context, '/order_confirmation');
                  cart.clearCart(); // Clear cart after order confirmation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD28A3C), // Match card color
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Confirm Order",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated _buildPaymentOption to include onTap callback and handle selection
  Widget _buildPaymentOption({
    required String label,
    required Color? bgColor,
    IconData? icon,
    String? imageUrl,
    required VoidCallback onTap, // Added onTap callback
  }) {
    return GestureDetector(
      onTap: onTap, // Use the onTap callback
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedPaymentMethod == label ? Colors.blue : Colors.grey[300]!, // Highlight selected
            width: _selectedPaymentMethod == label ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: Colors.grey[700])
              : (imageUrl != null
              ? Image.asset(imageUrl, width: 50, height: 30, fit: BoxFit.contain)
              : Text(label, style: TextStyle(color: Colors.grey[700]))),
        ),
      ),
    );
  }

  // Updated _buildCreditCard to accept cardImage path
  Widget _buildCreditCard({
    required String cardHolderName,
    required String cardNumber,
    required String expiryDate,
    required Color cardColor, // This color is now less relevant if using image background
    required String? cardImage, // Made nullable for cases like PayPal
    required String? cardHolderImage, // Made nullable for cases like solid color background
  }) {
    // Debugging print statement to check the cardNumber value
    debugPrint('Building Credit Card with Card Number: $cardNumber');

    return Container(
      height: 200, // Fixed height for the card
      width: double.infinity, // Full width
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        // Use image if cardHolderImage is provided, otherwise use solid color
        color: cardHolderImage == null ? cardColor : null,
        image: cardHolderImage != null ? DecorationImage(
          image: AssetImage(cardHolderImage), // Use the full card image here
          fit: BoxFit.cover,
        ) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: cardImage != null ? Image.asset(
              cardImage, // Use the dynamic cardImage here
              width: 60,
              color: Colors.white, // Make logo white for visibility on dark cards
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink(); // Hide if error
              },
            ) : const SizedBox.shrink(), // Hide if no image provided
          ),
          const SizedBox(height: 10),
          Text(
            cardNumber,
            style: const TextStyle(
              color: Colors.white, // Set text color to white
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CARD HOLDER",
                    style: TextStyle(color: Colors.white70, fontSize: 10), // Set text color to white70
                  ),
                  Text(
                    cardHolderName,
                    style: const TextStyle(
                      color: Colors.white, // Set text color to white
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "EXPIRES",
                    style: TextStyle(color: Colors.white70, fontSize: 10), // Set text color to white70
                  ),
                  Text(
                    expiryDate,
                    style: const TextStyle(
                      color: Colors.white, // Set text color to white
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
