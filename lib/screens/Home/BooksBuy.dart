import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movison/widgets/mycart.dart';

class Product {
  final String imageUrl;
  final String name;
  final double price;
  final String type;
  final String userId;
  final String description;
  final String id;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.type,
    required this.userId,
    required this.description,
    required this.id,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      type: data['type'] ?? '',
      userId: data['userId'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
class BuyList extends StatelessWidget {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
       final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        appBar: AppBar(
          centerTitle: true,
          title: Text(
                  "Books For Buy",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
        ),
        body: Stack(children: [
          
           Positioned.fill(
            top: 0,
            child: FutureBuilder<QuerySnapshot>(
              future: productsCollection.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                List<Product> products = snapshot.data!.docs
                    .map((DocumentSnapshot document) =>
                        Product.fromFirestore(document))
                    .where((product) => product.type.toLowerCase() == 'buy')
                    .toList();

                // Sort products by name
                products.sort((a, b) {
                  return a.name.compareTo(b.name);
                });

                if (products.isNotEmpty) {
                  return ListView.builder(
                    itemCount: (products.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      int startIndex = index * 2;
                      int endIndex = (index + 1) * 2;
                      if (endIndex > products.length) {
                        endIndex = products.length;
                      }

                      List<Product> rowProducts =
                          products.sublist(startIndex, endIndex);

                      // If this is the last row and it contains only one product, align it to the left
                      if (rowProducts.length == 1 &&
                          endIndex == products.length) {
                        return ProductCardRow(
                          products: rowProducts,
                          addToCart: addToCart,
                          alignLeft: true,
                        );
                      } else {
                        return ProductCardRow(
                          products: rowProducts,
                          addToCart: addToCart,
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: Text(''),
                  );
                }
              },
            ),
          ),
        ]));
  }
  Future<void> addToCart(BuildContext context, Product product) async {
    try {
      // Check if the product is already in the cart
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('id', isEqualTo: product.id)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        // If the product is already in the cart, show a tooltip
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} is already in your cart.'),
          ),
        );
        //Navigator.of(context).push(MaterialPageRoute(builder:(context)=> CartScreen()));
      } else {
        // If the product is not in the cart, add it to Firestore
        await FirebaseFirestore.instance.collection('cart').add({
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'ProductId': product.userId,
          'Description': product.description,
          'userId': currentUserId,
          // Add other fields as needed
        });
        print('Added ${product.name} to cart');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to your cart.'),
          ),
        );
        
      }
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

}
class ProductCardRow extends StatelessWidget {
  final List<Product> products;
   final Function(BuildContext, Product) addToCart;
  final bool alignLeft;

  const ProductCardRow({
    Key? key,
    required this.products,
    required this.addToCart,
    this.alignLeft = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          alignLeft ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: products
          .map(
        (product) => Expanded(
          child: ProductCard(product: product, addToCart: addToCart),
        ),
      )
          .followedBy([
        // Add an empty Expanded if there is only one product
        if (products.length == 1) Expanded(child: Container()),
      ]).toList(),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(BuildContext, Product) addToCart;

  const ProductCard({Key? key, required this.product, required this.addToCart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetailScreen when the product is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        
        margin: const EdgeInsets.all(14.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: MediaQuery.of(context).size.width * 0.0028,
            color: const Color(0xFF02B153),
          ),
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.0444,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1396,
              decoration: BoxDecoration(
                image: product.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.fill,
                      )
                    : null, // No image if 'imageUrl' is empty
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            Container(
              width: 10,
              height: 30,
              margin: const EdgeInsets.only(top:15,bottom: 5,left: 15,right: 15),
              child: ElevatedButton(
                onPressed: ()async {
                  // Call addToCart method when the button is pressed
                  await addToCart(context, product);
                  Navigator.of(context).push(MaterialPageRoute(builder:(context)=> CartScreen()),);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text(
                  'Add to Cart',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            SizedBox(
                height: 20,
                width: 100,
                child: Center(
                  child: Text(
                    product.name,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                )),
            Center(
                child: Text(
              '\u{20B9}${product.price}/kg',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            )),
            const SizedBox( 
              height: 4.6,
            )
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String productUserName = '';
  late String profilePic = '';
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  Future<void> fetchUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          productUserName = userSnapshot['name'];
          profilePic = userSnapshot['profilePic'];
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<void> addToCart(BuildContext context, Product product) async {
    try {
      // Check if the product is already in the cart
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('id', isEqualTo: product.id)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        // If the product is already in the cart, show a tooltip
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} is already in your cart.'),
          ),
        );
        //Navigator.of(context).push(MaterialPageRoute(builder:(context)=> CartScreen()));
      } else {
        // If the product is not in the cart, add it to Firestore
        await FirebaseFirestore.instance.collection('cart').add({
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'ProductId': product.userId,
          'Description': product.description,
          'userId': currentUserId,
          // Add other fields as needed
        });
        print('Added ${product.name} to cart');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to your cart.'),
          ),
        );
        
      }
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Call fetchUserName method in initState to fetch user name
    fetchUserName(widget.product.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
       title: Text(
                "Book Details",
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *
                  0.3, // Set a fixed height for the container
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.product.imageUrl),
                  fit: BoxFit.fill,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
              ),
            ),
            Text(
              widget.product.name,
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              'Rs ${widget.product.price.toStringAsFixed(2)}/kg',
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 90,
              endIndent: 90,
            ),
            Text(
              'Description',
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Center(
              child: SizedBox(
                  width: 300,
                  child: Text(
                    widget.product.description,
                    textAlign: TextAlign.center,
                  )),
            ),
             const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
           Text(
              'Book Type : ${widget.product.type}',
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
     SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow),
                    height: 45,
                    width: 170,
                    child:  Center(child: Text("Add to Cart",style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),)),
                  ),
                  onTap: () async{
                    await addToCart(context, widget.product);
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=> CartScreen()),);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}