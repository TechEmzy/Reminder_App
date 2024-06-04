// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:lighthouse_church/db/db_helper.dart';
import 'package:lighthouse_church/pages/add_member_bar.dart';
import 'package:lighthouse_church/pages/home.dart';
import 'package:lighthouse_church/pages/login_page.dart';
import 'package:lighthouse_church/pages/member_page.dart';
import 'package:lighthouse_church/services/theme_services.dart';
import 'components/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Church Anniversary Reminder',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => Home(selectedIndex: 0)),
        GetPage(name: '/addMemberPage', page: () => const AddMemberPage()),
        GetPage(name: '/memberPage', page: () => MemberPage(selectedIndex: 2)),
        // GetPage(name: '/memberPage', page: () => MemberPage(selectedIndex: 2)),
      ],
    );
  }
}



// import 'package:lighthouse_church/db/db_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lighthouse_church/services/theme_services.dart';
// import 'package:lighthouse_church/pages/login_page.dart';
// import 'package:lighthouse_church/pages/home.dart';
// import 'package:lighthouse_church/pages/add_member_bar.dart';
// import 'package:lighthouse_church/pages/member_page.dart';
// import 'package:get_storage/get_storage.dart';
// import 'components/theme.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await DBHelper.initDb();
//   await GetStorage.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Church Anniversary Reminder',
//       theme: Themes.light,
//       darkTheme: Themes.dark,
//       themeMode: ThemeService().theme,
//       initialRoute: '/memberPage',
//       getPages: [
//         // GetPage(name: '/', page: () => const Loading()),
//         GetPage(name: '/login', page: () => const LoginPage()),
//         GetPage(name: '/home', page: () => const Home()),
//         GetPage(name: '/addMemberPage', page: () => const AddMemberPage()),
//         GetPage(name: '/memberPage', page: () => MemberPage()),
//         // GetPage(name: '/memberPage', page: () => const MemberPage()),
//       ],
//     );
//   }
// }
