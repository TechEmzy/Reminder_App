import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../consts.dart';
import '../pages/home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  // Define the 'userIcon and keyIcon' property
  final String userIcon = 'assets/icons/user_icon.svg';
  final String keyIcon = 'assets/icons/key_icon.svg';
  final double iconSize = 24.0; // Set a fixed size for the icons

  // Hardcoded username and password
  final String hardcodedUsername = 'admin';
  final String hardcodedPassword = '12345';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [g1, g2],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.030),
            child: OverflowBar(
              overflowSpacing: 20,
              overflowAlignment: OverflowBarAlignment.center,
              children: [
                Image.asset(image1),
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: kWhiteColor.withOpacity(0.7),
                  ),
                ),
                const Text(
                  'Please, Login.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: kWhiteColor,
                  ),
                ),
                SizedBox(height: size.height * 0.024),
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: kInputColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 25.0),
                    filled: true,
                    hintText: "Username",
                    prefixIcon: SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(userIcon, height: iconSize),
                      ),
                    ),
                    fillColor: kWhiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37),
                    ),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: kInputColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 25.0),
                    filled: true,
                    hintText: "Password",
                    prefixIcon: SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(keyIcon, height: iconSize),
                      ),
                    ),
                    fillColor: kWhiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37),
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: size.height * 0.090,
                    decoration: BoxDecoration(
                      color: kButtonColor,
                      borderRadius: BorderRadius.circular(37),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Print entered values for debugging
                    print("Username: ${usernameController.text}");
                    print("Password: ${passwordController.text}");

                    // Check the username and password
                    if (usernameController.text == hardcodedUsername &&
                        passwordController.text == hardcodedPassword) {
                      // Authentication successful, navigate to the home page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Home(selectedIndex: 0)),
                      );
                    } else {
                      // Authentication failed, handle accordingly
                      print("Login failed");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
