import 'package:flutter/material.dart';

class medicines extends StatefulWidget {
  const medicines({super.key});

  @override
  State<medicines> createState() => _medicinesState();
}

class _medicinesState extends State<medicines> {
  final List<Map<String, String>> categories = [
    {
      'title': 'Covid Essentials',
      'image':
          'https://www.kinetikwellbeing.com/wp-content/uploads/2021/04/F30676_4-700x700.jpg'
    },
    {
      'title': 'Skin Care',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOat5b77xgvwsBWprrWILEXl-DGbMXlr-5bA&s'
    },
    {
      'title': 'Vitamins and Minerals',
      'image':
          'https://rukminid2.flixcart.com/image/750/900/xif0q/vitamin-supplement/0/i/q/60-multivitamin-tablets-for-men-women-with-vitamins-minerals-original-imah6g4fngpayepc.jpeg?q=90&crop=false'
    },
    {
      'title': 'Sexual Wellness',
      'image':
          'data:image/jpeg;base64,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'
    },
    {
      'title': 'Health Food and Drinks',
      'image':
          'https://images.apollo247.in/images/category/adult_nutrition.jpg?tr=q-80,f-webp,w-100,dpr-3,c-at_max%20300w'
    },
    {
      'title': 'Baby Care',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgqIBSrnPjeO-SHD7GofMMoFZmDl_p4YYdgg&s'
    },
    {
      'title': 'Pain Relief',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6jfelVQblvfcSNWB5ZJH_caaMeZVd0ME-Lg&s'
    },
    {
      'title': 'Diabetic Care',
      'image':
          'https://m.media-amazon.com/images/S/aplus-media-library-service-media/48c11b69-86b5-4e8b-b8ed-83a00a740cee.__CR0,0,600,450_PT0_SX600_V1___.png'
    },
    {
      'title': 'Protein and Supplements',
      'image':
          'https://m.media-amazon.com/images/S/aplus-media-library-service-media/f41c9f1c-a710-42b6-8048-488956011725.__CR0,0,970,600_PT0_SX970_V1___.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Pharmacy'),
        // backgroundColor: Color(0xFF272B7C),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery info
            const Text.rich(
              TextSpan(
                text: 'Deliver to - ',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                children: [
                  TextSpan(
                    text: 'Bangalore, 560009',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search Medicines & Health Products',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Categories header
            const Text(
              'Shop Health Products By Categories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Categories grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = categories[index];
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.network(
                          item['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
