import 'dart:async';
import 'dart:convert';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:lighthouse_church/pages/edit_member_bar.dart';
import 'package:lighthouse_church/pages/member_page.dart';
// import 'package:lighthouse_church/controllers/member_controller.dart';
import 'package:lighthouse_church/services/theme_services.dart';
import 'package:lighthouse_church/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../components/button.dart';
import '../components/theme.dart';
// import '../components/bottom_nav.dart';
import 'add_member_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sms/flutter_sms.dart';

class Home extends StatefulWidget {
  final int selectedIndex;

  const Home({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> _memberList = []; // List to store fetched members
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on the selected index
    switch (index) {
      case 0:
        // Navigate to home page
        break;
      case 1:
        // Navigate to add member page
        Get.to(() => const AddMemberPage());
        break;
      case 2:
        // Navigate to members page
        Get.to(() => MemberPage(selectedIndex: 2));
        break;
      default:
        break;
    }
  }

  late DateTime _selectedDate;
  late NotifyHelper _notifyHelper;

  // DateTime _selectedDate = DateTime.now();
  // final _memberController = Get.put(MemberController());
  // var notifyHelper;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _notifyHelper = NotifyHelper();
    _fetchMembers();
    _notifyHelper.initializeNotification();
    _notifyHelper.requestIOSPermissions();
  }

  Future<void> _fetchMembers() async {
    try {
      var url =
          Uri.parse('https://reminder-app123.000webhostapp.com/public/members');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> newMembers = data['data'];

        // Check if any new members have events on the current date
        newMembers.forEach((member) {
          try {
            final formatter = DateFormat('MM-dd');
            final currentDate = formatter.format(_selectedDate);
            final birthdayDate =
                formatter.format(DateTime.parse(member['birthday']));
            final anniversaryDate =
                formatter.format(DateTime.parse(member['weddinganniversary']));

            if (currentDate == birthdayDate || currentDate == anniversaryDate) {
              // Send notification for the event
              _notifyHelper.displayCelebrationNotification(
                eventName: currentDate == birthdayDate
                    ? 'Birthday'
                    : 'Wedding Anniversary',
                eventDate: currentDate,
              );
            }
          } catch (e) {
            print('Error parsing date: $e');
          }
        });

        setState(() {
          _memberList = newMembers;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  void _checkMemberEvents() async {
    final formatter = DateFormat('MM-dd');
    final currentDate = formatter
        .format(_selectedDate); // Use selected date instead of current date
    print('Current date: $currentDate');
    List<String> recipients = []; // List to store recipient phone numbers
    List<Map<String, String>> events = []; // List to store events
    _memberList.forEach((member) {
      final birthdayDate = formatter.format(DateTime.parse(member['birthday']));
      final anniversaryDate =
          formatter.format(DateTime.parse(member['weddinganniversary']));
      print(
          'Checking member: ${member['name']}, Birthday: $birthdayDate, Anniversary: $anniversaryDate');
      if (currentDate == birthdayDate) {
        recipients.add(member['phone']); // Add phone number to recipients list
        events.add({'eventName': 'Birthday', 'eventDate': currentDate});
      }
      if (currentDate == anniversaryDate) {
        recipients.add(member['phone']); // Add phone number to recipients list
        events.add(
            {'eventName': 'Wedding Anniversary', 'eventDate': currentDate});
      }
    });

    // Print recipients list for debugging
    print('Recipients for notifications: $recipients');

    // Display notifications for collected events
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      _notifyHelper.displayCelebrationNotification(
        eventName: event['eventName']!,
        eventDate: event['eventDate']!,
      );
      // Add a delay of 2 seconds between notifications
      await Future.delayed(Duration(seconds: 2));
    }

    // Populate and process the queue
    await _populateQueue();
    await _processQueue();

    // Send messages to recipients
    await _sendMessage(recipients);
  }

  Future<void> _populateQueue() async {
    try {
      var url = Uri.parse(
          'https://reminder-app123.000webhostapp.com/public/populatequeue');
      print('Sending request to populate queue: $url');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      if (response.statusCode == 200) {
        print('Queue populated successfully');
      } else {
        print(
            'Failed to populate the queue. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error populating the queue: $e');
    }
  }

  Future<void> _processQueue() async {
    try {
      var url = Uri.parse(
          'https://reminder-app123.000webhostapp.com/public/processqueue');
      print('Sending request to process queue: $url');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      if (response.statusCode == 200) {
        print('Queue processed successfully');
      } else {
        print(
            'Failed to process the queue. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error processing the queue: $e');
    }
  }

  Future<void> _sendMessage(List<String> recipients) async {
    try {
      // Check if member list is empty
      if (_memberList.isEmpty) {
        print('Member list is empty.');
        return;
      }

      // Iterate through member list to create personalized messages
      List<String> messages = [];
      _memberList.forEach((member) {
        String name = '${member['firstname']} ${member['surname']}';
        String birthdayMessage = 'Happy Birthday, $name!';
        String anniversaryMessage = 'Happy Anniversary, $name!';
        final formatter = DateFormat('MM-dd');
        final currentDate = formatter.format(_selectedDate);
        final birthdayDate =
            formatter.format(DateTime.parse(member['birthday']));
        final anniversaryDate =
            formatter.format(DateTime.parse(member['weddinganniversary']));

        // Add personalized message to messages list based on current date
        if (currentDate == birthdayDate) {
          messages.add(birthdayMessage);
        } else if (currentDate == anniversaryDate) {
          messages.add(anniversaryMessage);
        }
      });

      // Send messages to recipients
      String result =
          await sendSMS(message: messages.join('\n'), recipients: recipients)
              .catchError((onError) {
        print('Failed to send message: $onError');
      });
      print('Message sent successfully: $result');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          _addMemberBar(),
          _addDateBar(),
          SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: _showMembers(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add Member',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Members',
          ),
        ],
      ),
    );
  }

  // app bar method
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Set the background color
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          // _notifyHelper.displayNotification(
          //   title: "Theme Changed",
          //   body: Get.isDarkMode
          //       ? "Light Theme Activated"
          //       : "Dark Theme Activated",
          // );
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          size: 27,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.white,
          child: SizedBox(
            height: 35, // Set desired height
            width: 35, // Set desired width
            child: Image.asset(
              "assets/images/profile.png",
              fit: BoxFit.cover, // Adjust to fit your needs
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 81,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _addMemberBar() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(
            label: "Add Member",
            onTap: () async {
              await Get.to(() => const AddMemberPage());
              // _memberController.getMembers();
            },
          ),
        ],
      ),
    );
  }

  Widget _showMembers() {
    // Filter members whose birthdays or wedding anniversaries are in the current month
    List<dynamic> currentMonthMembers = _memberList.where((member) {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime currentDate = DateTime.now();
      DateTime? birthday = _parseDate(member['birthday'], dateFormat);
      DateTime? anniversary =
          _parseDate(member['weddinganniversary'], dateFormat);

      // Check if the birthday or anniversary is in the current month
      return (birthday != null && birthday.month == currentDate.month) ||
          (anniversary != null && anniversary.month == currentDate.month);
    }).toList();

    // If the current month has no events, get members for the next month
    if (currentMonthMembers.isEmpty) {
      DateTime nextMonth = DateTime.now().add(Duration(days: 30));
      currentMonthMembers = _memberList.where((member) {
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        DateTime? birthday = _parseDate(member['birthday'], dateFormat);
        DateTime? anniversary =
            _parseDate(member['weddinganniversary'], dateFormat);

        // Check if the birthday or anniversary is in the next month
        return (birthday != null && birthday.month == nextMonth.month) ||
            (anniversary != null && anniversary.month == nextMonth.month);
      }).toList();
    }

    // Sort the members based on the closest date
    currentMonthMembers.sort((a, b) {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime? aBirthday = _parseDate(a['birthday'], dateFormat);
      DateTime? bBirthday = _parseDate(b['birthday'], dateFormat);
      DateTime? aAnniversary = _parseDate(a['weddinganniversary'], dateFormat);
      DateTime? bAnniversary = _parseDate(b['weddinganniversary'], dateFormat);

      // Calculate the difference in days to the closest event for each member
      Duration aClosestDifference = _closestDifference(aBirthday, aAnniversary);
      Duration bClosestDifference = _closestDifference(bBirthday, bAnniversary);

      return aClosestDifference.compareTo(bClosestDifference);
    });

    // Take the first five members from the sorted list
    List<dynamic> filteredMembers = currentMonthMembers.take(10).toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight - 310,
      child: ListView.builder(
        itemCount: filteredMembers.length,
        itemBuilder: (_, index) {
          var member = filteredMembers[index];
          return _buildMemberCard(member);
        },
      ),
    );
  }

// Function to calculate the closest difference to the current date
  Duration _closestDifference(DateTime? birthday, DateTime? anniversary) {
    Duration closestDifference =
        Duration(days: 9999); // Initialize with a large value
    DateTime currentDate = DateTime.now();

    if (birthday != null) {
      Duration birthdayDifference = birthday.difference(currentDate).abs();
      if (birthdayDifference < closestDifference) {
        closestDifference = birthdayDifference;
      }
    }

    if (anniversary != null) {
      Duration anniversaryDifference =
          anniversary.difference(currentDate).abs();
      if (anniversaryDifference < closestDifference) {
        closestDifference = anniversaryDifference;
      }
    }

    return closestDifference;
  }

  DateTime? _parseDate(String? dateString, DateFormat dateFormat) {
    if (dateString != null && dateString.isNotEmpty) {
      try {
        DateTime parsedDate = dateFormat.parse(dateString);
        DateTime currentDate = DateTime.now();

        // Check if the parsed date is in the future
        if (parsedDate.isBefore(currentDate)) {
          // Increment the year to find the next occurrence
          parsedDate =
              DateTime(currentDate.year + 1, parsedDate.month, parsedDate.day);
        }

        return parsedDate;
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    return null;
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
        margin:
            EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Adjust margin
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
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
            SizedBox(height: 15),
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
