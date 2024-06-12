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
class AllProductsList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<AllProductsList> {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  String searchQuery = '';
  List<Product> filteredProducts = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
     
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 40,
          decoration: BoxDecoration(
            //color: const Color.fromARGB(255, 245, 194, 116),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(width: 1.5)
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search....",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<QuerySnapshot>(
            future: productsCollection.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              List<Product> products = snapshot.data!.docs
                  .map((DocumentSnapshot document) =>
                      Product.fromFirestore(document))
                  .toList();

              filteredProducts = products
                  .where((product) =>
                      product.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      product.type
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                  .toList();

              if (filteredProducts.isNotEmpty) {
                return ListView.builder(
                  itemCount: filteredProducts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: filteredProducts[index],
                      addToCart: addToCart,
                    );
                  },
                );
              } else {
                return Text('No products found');
              }
            },
          ),
        ),
      ],
    );
  }

  void addToCart(BuildContext context, Product product) async {
    try {
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('id', isEqualTo: product.id)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} is already in your cart.'),
          ),
        );
      } else {
        await FirebaseFirestore.instance.collection('cart').add({
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'ProductId': product.userId,
          'Description': product.description,
          'userId': currentUserId,
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

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(BuildContext, Product) addToCart;

  const ProductCard({
    required this.product,
    required this.addToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        ), // Wrap the function call
      child: Padding(
        padding: const EdgeInsets.only(
          //right: 15.0,
          left: 10),
        child: SizedBox(
          width: 180, 
          height: 150,// Provide a fixed width here
          child: Card(
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Adjust border radius as needed
            // You can also set other properties like border color and width here
            // For example:
            side: BorderSide(color: Colors.grey, width: 2),
          ),
            elevation: 4,
            margin: EdgeInsets.all(10),
            child: Column(
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
                 // border: Border.all(width: 2)
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
                  SizedBox(
                  height: 20,
                  width: 100,
                  child: Center(
                    child: Text(
                      product.type,
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
                  ))
              ],
            ),
          ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox( height: 50,),
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
                      side: BorderSide(color: Colors.grey, width: 2),
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
                  onTap: ()async {
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