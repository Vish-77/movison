
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movison/screens/Account/account.dart';
import 'package:movison/screens/Home/AllCategoryPage.dart';
import 'package:movison/widgets/constants.dart';
import 'package:movison/widgets/enums.dart';
import 'package:movison/widgets/icon_but_with_cnt.dart';
import 'package:movison/widgets/mycart.dart';


class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  ("assets/icons/home1.svg"),
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {},
               // onPressed: () =>
                   // Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              // IconButton(
              //   icon: SvgPicture.asset("assets/icons/Bell.svg"),
              //
              //   onPressed: () {
              //     //Navigator.of(context).push(MaterialPageRoute(builder:(context)=> AddProduct()),);/// put Search class after done
              //     //Navigator.pushNamed(context, Notifications.routeName);//// notification screen
              //     Navigator.of(context).push(MaterialPageRoute(builder:(context)=> Notifications()),);
              //   },
              //
              // ),
             
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/profile1.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : kPrimaryColor,
                ),
                //onPressed: () {},
               onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder:(context)=> AccountPage()),),
              ),
            ],
          )),
    );
  }
}

