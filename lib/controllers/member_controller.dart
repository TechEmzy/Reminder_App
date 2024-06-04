// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:lighthouse_church/models/members.dart';

// class MemberController extends GetxController {
//   var memberList = <Member>[].obs;

//   final String apiUrl =
//       'https://localhost/churchanniversaryreminer/public/members/'; // Update with your server address

//   @override
//   void onInit() {
//     getMembers();
//     super.onInit();
//   }

//   void getMembers() async {
//     try {
//       var response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         var jsonData = response.body;
//         memberList.value =
//             (jsonData as List).map((data) => Member.fromJson(data)).toList();
//       } else {
//         print('Failed to load members: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error loading members: $e');
//     }
//   }
// }





// // import 'package:lighthouse_church/db/db_helper.dart';
// // import 'package:get/get.dart';
// // import '../models/members.dart';

// // // Define a controller class for managing members
// // class MemberController extends GetxController {
// //   @override
// //   void onReady() {
// //     // Call the getMembers method when the controller is ready
// //     getMembers();
// //     super.onReady();
// //   }

// //   // Define an observable list to store members
// //   var memberList = <Member>[].obs;

// //   // Define a method to add a new member to the database
// //   Future<int> addMember({Member? member}) async {
// //     // Use the DBHelper class to insert the member into the database
// //     return await DBHelper.insert(member);
// //   }

// //   // Define a method to retrieve all members from the database
// //   void getMembers() async {
// //     // Use the DBHelper class to query all members from the database
// //     List<Map<String, dynamic>> members = await DBHelper.query();

// //     // Convert the list of maps to a list of Member objects using the Member.fromJson method
// //     memberList.assignAll(members.map((data) => Member.fromJson(data)).toList());
// //   }
// // }
