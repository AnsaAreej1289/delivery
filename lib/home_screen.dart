import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'cart_model.dart'; // Import cart model

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> foodItems = [
    {
      'name': 'Mixed fried meat',
      'image': 'assets/Mixed fried meat.jpg',
      'distance': '2.4 km',
      'rating': 4.9,
      'reviews': '2.2k',
      'price': 18.00,
      'discount': 2.00,
    },
    {
      'name': 'Chicken Skewers',
      'image': 'assets/Chicken Skewers.jpg',
      'distance': '1.2 km',
      'rating': 4.7,
      'reviews': '4.3k',
      'price': 14.99,
      'discount': 1.00,
    },
    {
      'name': 'Grilled Chicken',
      'image': 'assets/Grilled Chicken.jpg',
      'distance': '1.6 km',
      'rating': 4.9,
      'reviews': '2.1k',
      'price': 8.99,
      'discount': 1.00,
    },
    {
      'name': 'Steak Homemade',
      'image': 'assets/Steak Homemade.jpg',
      'distance': '3.4 km',
      'rating': 4.8,
      'reviews': '1.3k',
      'price': 23.00,
      'discount': 3.00,
    },
    {
      'name': 'Fried Chicken',
      'image': 'assets/Fried Chicken.jpg',
      'distance': '1.4 km',
      'rating': 4.9,
      'reviews': '2.1k',
      'price': 11.99,
      'discount': 1.00,
    },
    {
      'name': 'Shawarma Potatoes',
      'image': 'assets/Shawarma Ptatoes.jpg',
      'distance': '4.1 km',
      'rating': 4.5,
      'reviews': '3.3k',
      'price': 9.99,
      'discount': 1.00,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen for changes in the cart item count
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Popular Foods",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          // Cart icon and item count
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/my_cart'); // Navigate to cart screen
                },
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '60+',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.85,
                ),
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  final item = foodItems[index];
                  return FoodItemCard(
                    item: item,
                    onAddToCart: (itemData) {
                      // Add item to cart when button is pressed
                      cart.addItem(CartItem(
                        name: itemData['name'],
                        image: itemData['image'],
                        price: itemData['price'],
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${itemData['name']} added to cart!')),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Button to navigate to Special Offers Screen
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/special_offers');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'View Special Offers',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic>) onAddToCart; // Callback for adding to cart

  const FoodItemCard({super.key, required this.item, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      item['distance'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${item['rating']} (${item['reviews']})',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    // Add to Cart button
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                      onPressed: () {
                        onAddToCart(item);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
