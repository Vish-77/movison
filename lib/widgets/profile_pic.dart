import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movison/screens/Account/itprofile.dart';
import 'package:movison/screens/MobileAuth/authprovider.dart' as MovisonAuthProvider ;
import 'package:movison/screens/MobileAuth/usermodel.dart';
import 'package:provider/provider.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State createState()=>_ProfilePic();
}

class _ProfilePic extends State{
   UserModel? u;
  bool isUserLoaded = false;

  void getData() async {
    final ap = Provider.of<MovisonAuthProvider.AuthProvider>(context,
        listen: false); // Use the alias

    await ap.getDataFromSP();
    setState(() {
      u = ap.userModel;
      isUserLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(u!.profilePic),
              radius: 60,
            ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) => const EditProfileScreen(),
    ),);
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
