import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movison/screens/Home/Availablebooks.dart';
import 'package:movison/screens/Home/addbooks.dart';
import 'package:movison/size_config.dart';
import 'package:movison/theme/color.dart';
import 'package:movison/utils/data.dart';
import 'package:movison/widgets/category_box.dart';
import 'package:movison/widgets/constants.dart';
import 'package:movison/widgets/custom_navigation_bar.dart';
import 'package:movison/widgets/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black87,
      body: Body(),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          //_buildCategories(),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "Featured",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(
            height: 0, // Adjust the height based on your preference
          ),

          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Books",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textColor),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: AppColor.darker),
                ),
              ],
            ),
          ),
          // _buildRecommended(),
          AvailableBooks(),
        ],
      ),
    );
  }

  _buildCategories() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categories.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CategoryBox(
              selectedColor: Colors.white,
              data: categories[index],
              onTap: () {
                _onCategoryTap(categories[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onCategoryTap(Map<String, dynamic> categoryData) {
    // Navigate to the corresponding category page based on the category name
    switch (categoryData["name"]) {
      case "Rent":
        // Navigate to the "All" category page
        Navigator.pushNamed(context, '/all_rent');
        break;
      case "Add Info":
        Navigator.pushNamed(context, '/add_student_details');
        break;
      case "TimeLeft":
        Navigator.pushNamed(context, '/book_purchase_details');
        break;

      // Add cases for other categories as needed
      default:
        // Navigate to a default page or handle accordingly
        break;
    }
  }
}

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    return _buildCategories();
  }

  Widget _buildCategories() {
    return Container(
        padding: const EdgeInsets.all(20),
        width: getProportionateScreenWidth(310),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(23, 54, 110, 55),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            categories.length,
            growable: false,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CategoryBox(
                selectedColor: Colors.white,
                data: categories[index],
                onTap: () {
                  _onCategoryTap(categories[index]);
                },
              ),
            ),
          ),
        ));
  }
}

void _onCategoryTap(Map<String, dynamic> categoryData) {
  // Navigate to the corresponding category page based on the category name
  switch (categoryData["name"]) {
    case "Rent":
      // Navigate to the "All" category page
      //Navigator.pushNamed(context, '/all_rent');
      break;
    case "Add Info":
      //Navigator.pushNamed(context, '/add_student_details');
      break;
    case "TimeLeft":
      //Navigator.pushNamed(context, '/book_purchase_details');
      break;

    // Add cases for other categories as needed
    default:
      // Navigate to a default page or handle accordingly
      break;
  }
}

//

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        //onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(242),
          height: getProportionateScreenWidth(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFFFFFFF).withOpacity(0.1),
                        const Color(0xFFFFFFFF).withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const Color primaryColor = Color(0xFF2967FF);
const Color grayColor = Color(0xFF8D8D8E);

const double defaultPadding = 16.0;

class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius:
              const BorderRadius.all(Radius.circular(defaultPadding))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(10)),
            //HomeHeader(),
            CustomAppBar(),
            SizedBox(height: getProportionateScreenWidth(30)),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: SizedBox(
                height: 160,
                // width: 500,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: banner.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Image.asset(
                          banner[index],
                          //width: 300,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 40,
                      );
                    }),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(30)),
            CategorySection(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo2.png', // Replace with the path to your PNG image
          width: getProportionateScreenWidth(50),
          height: getProportionateScreenHeight(40),
          color: AppColor.textColor,
        ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MoViSon",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "New Business World",
                style: TextStyle(
                  color: AppColor.labelColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const ProductEntryScreen(),
                  ));
            },
            icon: Icon(Icons.add_card)),
        ChatWithUs(),
      ],
    );
  }
}

class ChatWithUs extends StatelessWidget {
  const ChatWithUs({
    Key? key,
    this.onTap,
    this.size = 5,
  }) : super(key: key);

  final GestureTapCallback? onTap;

  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.appBarColor,
          border: Border.all(
            color: Colors.grey.withOpacity(.3),
          ),
        ),
        child: _buildIcon(),
      ),
    );
  }

  Widget _buildIcon() {
    return SvgPicture.asset(
      "assets/icons/customer_support.svg",
      width: 20,
      height: 25,
    );
  }
}

class BoxForCategories extends StatelessWidget {
  const BoxForCategories({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
