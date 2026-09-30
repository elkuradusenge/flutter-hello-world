import 'package:flutter/material.dart';

void main() {
  runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const ProductListPage(),
    );
  }
}

// ------------------------------------------------------------
// PRODUCT MODEL
// ------------------------------------------------------------

class Product {
  final String name;
  final String description;
  final double price;
  final Color color;
  final int rating;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.color,
    required this.rating,
  });
}

// ------------------------------------------------------------
// PRODUCT DATA
// ------------------------------------------------------------

const List<Product> products = [
  Product(
    name: 'Pixel 1',
    description: 'Pixel is the most featureful phone ever',
    price: 800,
    color: Color(0xFF4169E1),
    rating: 1,
  ),
  Product(
    name: 'Laptop',
    description: 'Laptop is most productive development tool',
    price: 2000,
    color: Color(0xFF32CD32),
    rating: 3,
  ),
  Product(
    name: 'Tablet',
    description: 'Tablet is the most useful device for every meeting',
    price: 1500,
    color: Color(0xFFD4C72C),
    rating: 3,
  ),
  Product(
    name: 'Pen Drive',
    description: 'Pen Drive is the most portable storage device',
    price: 100,
    color: Color(0xFFC65A3A),
    rating: 2,
  ),
  Product(
    name: 'Floppy Drive',
    description: 'Floppy Drive is a classic storage device',
    price: 50,
    color: Color(0xFF36B7A5),
    rating: 1,
  ),
];

// ------------------------------------------------------------
// PRODUCT LIST PAGE
// ------------------------------------------------------------

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Navigation'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ProductCard(
            product: product,

            // Open product details when clicked
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(
                    product: product,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------
// PRODUCT CARD
// ------------------------------------------------------------

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 105,
          child: Row(
            children: [
              // ----------------------------------------------
              // PRODUCT IMAGE / COLORED AREA
              // ----------------------------------------------

              Expanded(
                flex: 4,
                child: Container(
                  color: product.color,
                  child: Center(
                    child: Text(
                      product.name.toLowerCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),

              // ----------------------------------------------
              // PRODUCT INFORMATION
              // ----------------------------------------------

              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Expanded(
                        child: Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),

                      Text(
                        'Price: ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 3),

                      // Stars
                      Row(
                        children: List.generate(
                          3,
                          (index) {
                            return Icon(
                              index < product.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 18,
                              color: Colors.redAccent,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PRODUCT DETAILS PAGE
// ------------------------------------------------------------

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.blue,

        // Flutter automatically provides the back button.
      ),
      body: Column(
        children: [
          // ----------------------------------------------
          // LARGE PRODUCT IMAGE
          // ----------------------------------------------

          Container(
            height: 270,
            width: double.infinity,
            color: product.color,
            child: Center(
              child: Text(
                product.name.toLowerCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),

          // ----------------------------------------------
          // PRODUCT DETAILS
          // ----------------------------------------------

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),

                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    product.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    'Price: ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ----------------------------------------
                  // RATING
                  // ----------------------------------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      3,
                      (index) {
                        return Icon(
                          index < product.rating
                              ? Icons.star
                              : Icons.star_border,
                          size: 24,
                          color: Colors.redAccent,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
