import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movison/screens/Home/ProductModel.dart';
import 'package:movison/widgets/myBuyCart.dart';

class BuyList extends StatefulWidget {
  @override
  State createState() => _ProductListState();
}
class FilterBottomSheet extends StatefulWidget {
  final Function(String, String,String, double, double) onApplyFilters;

  FilterBottomSheet({required this.onApplyFilters});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedCategory = 'SPPU';
  String selectedBrand = 'CS';
  String selectedsem = 'I';
  double minPrice = 0.0;
  double maxPrice = 5000.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Center(child: Text('Filters'))),
          ListTile(
            title: Text('University'),
            trailing: SizedBox(
              width: 150, // Set a fixed width for the trailing widget
              child: DropdownButton<String>(
                value: selectedCategory,
                items: ['SPPU', 'Mumbai', 'BATU', 'Other'].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Branch'),
            trailing: SizedBox(
              width: 150, // Set a fixed width for the trailing widget
              child: DropdownButton<String>(
                value: selectedBrand,
                items: ['CS', 'IT', 'ENTC', 'Mec', 'Civil'].map((brand) {
                  return DropdownMenuItem(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBrand = value!;
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Semester'),
            trailing: SizedBox(
              width: 150, // Set a fixed width for the trailing widget
              child: DropdownButton<String>(
                value: selectedsem,
                items: ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII'].map((sem) {
                  return DropdownMenuItem(
                    value: sem,
                    child: Text(sem),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedsem = value!;
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Min Price'),
            trailing: SizedBox(
              width: 200, // Set a fixed width for the trailing widget
              child: Slider(
                value: minPrice,
                min: 0,
                max: 5000,
                divisions: 100,
                label: minPrice.round().toString(),
                onChanged: (value) {
                  setState(() {
                    minPrice = value;
                  });
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Max Price'),
            trailing: SizedBox(
              width: 200, // Set a fixed width for the trailing widget
              child: Slider(
                value: maxPrice,
                min: 0,
                max: 5000,
                divisions: 100,
                label: maxPrice.round().toString(),
                onChanged: (value) {
                  setState(() {
                    maxPrice = value;
                  });
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onApplyFilters(selectedCategory, selectedBrand, selectedsem, minPrice, maxPrice);
              Navigator.pop(context);
            },
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
class _ProductListState extends State {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  String searchQuery = '';
  List<Product> filteredProducts = [];
  String selectedCategory = '';
  String selectedBrand = '';
  String selectedsem='';
  double minPrice = 0.0;
  double maxPrice = 1000.0;
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Books for Buy"),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),),
            actions: [ 
              GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FilterBottomSheet(
                      onApplyFilters: (category, brand,sem, min, max) {
                        setState(() {
                          selectedCategory = category;
                          selectedBrand = brand;
                          selectedsem=sem;
                          minPrice = min;
                          maxPrice = max;
                        });
                      },
                    );
                  },
                );
              },
              child: Container(
                height: 20,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration( 
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(width: 1)
                ),
                child: Text("Filters",style: GoogleFonts.inter( 
color: Color.fromARGB(255, 248, 173, 34)
                ),),),
            ),
            const SizedBox( 
              width: 30,
            )
            ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow,
          onPressed: (){
             Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CartBuyScreen()),
                    );
        }, child:SvgPicture.asset("assets/icons/shopping_cart.svg"),),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              decoration: BoxDecoration(
                  //color: const Color.fromARGB(255, 245, 194, 116),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  border: Border.all(width: 1.5)),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search....",
                  prefixIcon:const Icon(Icons.search),
                  suffix:  IconButton(onPressed: (){
                    showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FilterBottomSheet(
                      onApplyFilters: (category, brand,sem, min, max) {
                        setState(() {
                          selectedCategory = category;
                          selectedBrand = brand;
                          selectedsem=sem;
                          minPrice = min;
                          maxPrice = max;
                        });
                      },
                    );
                  },
                                  );
                  }, icon: Icon(Icons.sort)),
                  border: InputBorder.none,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: productsCollection.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const  Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator())
                      );
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
      product.type.toLowerCase() == 'buy' && // Only include products of type 'rent'
      (product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
      product.type.toLowerCase().contains(searchQuery.toLowerCase())  ||
      product.univercity.toLowerCase().contains(searchQuery.toLowerCase())||
      product.branch.toLowerCase().contains(searchQuery.toLowerCase()) ||
        product.sem.toLowerCase().contains(searchQuery.toLowerCase())) &&
                          (selectedCategory.isEmpty || product.univercity == selectedCategory) &&
                          (selectedBrand.isEmpty || product.branch == selectedBrand) &&
                          (selectedsem.isEmpty || product.sem == selectedsem) &&
                          (product.price >= minPrice && product.price <= maxPrice))
  .toList();

                  if (filteredProducts.isNotEmpty) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        childAspectRatio: 0.8, // Aspect ratio of the items
                        //crossAxisSpacing: 10, // Spacing between columns
                        mainAxisSpacing: 5, // Spacing between rows
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: filteredProducts[index],
                          addToCart: addToCart,
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No products found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart(BuildContext context, Product product) async {
    try {
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart_Buy')
          .where('id', isEqualTo: product.id)
          .where('userId', isEqualTo: currentUserId)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} is already in your cart.'),
          ),
        );
      } else {
        await FirebaseFirestore.instance.collection('cart_Buy').add({
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
            right: 10.0,
            top: 10,
            left: 10),
        child: SizedBox(
          width: 180,
          height: 200, // Provide a fixed width here
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16), // Adjust border radius as needed
              // You can also set other properties like border color and width here
              // For example:
              side: const BorderSide(color: Colors.grey, width: 2),
            ),
            elevation: 4,
           // margin: const EdgeInsets.all(10),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                      height: 40,
                      width: 250,
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
                ),
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
                  '\u{20B9}${product.price}',
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
          .collection('cart_Buy')
          .where('userId', isEqualTo: currentUserId)
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
        await FirebaseFirestore.instance.collection('cart_Buy').add({
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
            const SizedBox(
              height: 50,
            ),
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
            SizedBox(
              height: 40,
              width: 400,
              child: Center(
                child: Text(
                  widget.product.name,
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Text(
              '\u{20B9} ${widget.product.price.toStringAsFixed(2)}',
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
                    style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
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
            
            const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "University : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.product.univercity,
                style: GoogleFonts.lato(
                   fontWeight: FontWeight.w600,
                fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Branch : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.product.branch,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
         const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Semester : ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.product.sem,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(
              color: Colors.black26,
              thickness: 2,
              height: 20,
              indent: 80,
              endIndent: 80,
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
                    child: Center(
                        child: Text(
                      "Add to Cart",
                      style: GoogleFonts.ubuntu(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )),
                  ),
                  onTap: () async {
                    await addToCart(context, widget.product);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CartBuyScreen()),
                    );
                  },
                )
              ],
            ),
             const SizedBox( 
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
