import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lighthouse_church/components/theme.dart';
import 'package:lighthouse_church/pages/edit_member_bar.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key, required int selectedIndex}) : super(key: key);

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List<dynamic> _memberList = []; // List to store fetched members

  @override
  void initState() {
    super.initState();
    _fetchMembers(); // Fetch members when the page initializes
  }

  Future<void> _fetchMembers() async {
    try {
      var url =
          Uri.parse('https://reminder-app123.000webhostapp.com/public/members');
      // print('Requesting members from: $url');

      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _memberList = data['data'];
        });
      } else {
        // Handle non-200 status code
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error fetching members: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Members",
                style: headingStyle,
              ),
              SizedBox(height: 10),
              _showMembers(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          // Navigator.pop(context);
          Get.offNamed('/home');
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 25,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.white,
          backgroundImage: const AssetImage(
            "assets/images/profile.png",
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _showMembers() {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          kToolbarHeight -
          kBottomNavigationBarHeight -
          40, // Adjust height as needed
      child: ListView.builder(
        itemCount: _memberList.length,
        itemBuilder: (_, index) {
          var member = _memberList[index];
          return _buildMemberCard(member);
        },
      ),
    );
  }

  Widget _buildMemberCard(member) {
    return GestureDetector(
      onTap: () {
        _showBottomSheet(context, member);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _getColorFromMember(member),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align icon to right
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${member['firstname']} ${member['surname']}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Phone: ${member['phone']}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Birthday: ${member['birthday']}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Wedding Anniversary: ${member['weddinganniversary']}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            // Icon for options
            GestureDetector(
              onTap: () {
                _showBottomSheet(context, member);
              },
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromMember(member) {
    // Check if the 'color' property is null
    if (member['color'] != null) {
      // Get color from member data based on the color column
      String colorString = member['color'];
      switch (colorString) {
        case 'primaryClr':
          return primaryClr;
        case 'pinkClr':
          return pinkClr;
        case 'yellowClr':
          return yellowClr;
        default:
          return blueClr; // Default color if no match
      }
    } else {
      return blueClr; // Default color if 'color' property is null
    }
  }

  String _getColorNameFromMember(member) {
    // Get color name from member data based on the color column
    String colorString = member['color'];
    switch (colorString) {
      case 'primaryClr':
        return 'Primary';
      case 'pinkClr':
        return 'Pink';
      case 'yellowClr':
        return 'Yellow';
      default:
        return 'Unknown'; // Default color name if no match
    }
  }

  _showBottomSheet(BuildContext context, member) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: member['isCompleted'] == 1
            ? MediaQuery.of(context).size.height * 0.30
            : MediaQuery.of(context).size.height * 0.30,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),
            // member.isCompleted == 1
            // ? Container():
            _bottomSheetButton(
              label: "Edit Member",
              onTap: () {
                Get.back();
                Get.to(
                    EditMemberPage(memberId: member['id'], memberData: member));
              },
              clr: primaryClr,
              context: context,
              member: member, // Pass member data
            ),
            // SizedBox(height: 20),
            _bottomSheetButton(
              label: "Delete Member",
              onTap: () {
                _deleteMember(member['id']); // Call delete method
                Get.back(); // Close the bottom sheet after deletion
              },
              clr: pinkClr,
              context: context,
              member: member, // Pass member data
            ),
            SizedBox(height: 15),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.white,
              isClose: true,
              context: context,
              member: member, // Pass member data
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
    required dynamic member, // Add member parameter
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 55,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: isClose == true
                      ? Get.isDarkMode
                          ? Colors.grey[600]!
                          : Colors.grey[300]!
                      : clr),
              borderRadius: BorderRadius.circular(20),
              color: isClose == true ? Colors.transparent : clr,
            ),
            child: Center(
              child: Text(
                label,
                style: isClose
                    ? titleStyle
                    : titleStyle.copyWith(color: Colors.white),
              ),
            )),
      ),
    );
  }

  // Method to delete a member
  void _deleteMember(String memberId) async {
    try {
      var url = Uri.parse(
          'https://reminder-app123.000webhostapp.com/public/members/delete/$memberId');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'memberId': memberId}),
      );
      if (response.statusCode == 200) {
        // If deletion is successful, fetch updated members
        _fetchMembers();
      } else {
        print('Failed to delete member. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting member: $e');
    }
  }
}
