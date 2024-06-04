import 'package:lighthouse_church/components/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lighthouse_church/pages/member_page.dart';
import '../components/input_field.dart';
import '../components/theme.dart';
import 'package:http/http.dart' as http;

class EditMemberPage extends StatefulWidget {
  final String memberId; // Pass the member ID to edit
  final dynamic memberData; // Member data to populate form fields
  const EditMemberPage(
      {Key? key, required this.memberId, required this.memberData})
      : super(key: key);

  @override
  State<EditMemberPage> createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _othernamesController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = "None";
  List<String> genderList = ["None", "Male", "Female"];
  DateTime _selectedBirthday = DateTime.now();
  DateTime _selectedWeddinganniversary = DateTime.now();
  final TextEditingController _emailController = TextEditingController();
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers and other variables with member data
    _surnameController.text = widget.memberData['surname'];
    _firstnameController.text = widget.memberData['firstname'];
    _othernamesController.text = widget.memberData['othernames'];
    _departmentController.text = widget.memberData['department'];
    _phoneController.text = widget.memberData['phone'];
    _selectedGender = widget.memberData['gender'];

    // Parse date strings with try-catch to handle invalid formats
    try {
      _selectedBirthday = _parseDate(widget.memberData['birthday']);
      _selectedWeddinganniversary =
          _parseDate(widget.memberData['weddinganniversary']);
    } catch (e) {
      print('Error parsing date: $e');
      // Handle error, set default values or show an error message
    }

    _emailController.text = widget.memberData['email'];
  }

  DateTime _parseDate(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      try {
        // Parse date string with the appropriate format
        return DateFormat('yyyy-MM-dd').parse(dateString);
      } catch (e) {
        print('Error parsing date: $e');
        // Handle error, return current date or throw exception
      }
    }
    // Return current date as fallback if parsing fails
    return DateTime.now();
  }

  Future<void> _updateMemberInDb() async {
    try {
      final url = Uri.parse(
          'https://reminder-app123.000webhostapp.com/public/members/edit/${widget.memberId}');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'surname': _surnameController.text.toUpperCase(),
          'firstname': _firstnameController.text.toUpperCase(),
          'othernames': _othernamesController.text.toUpperCase(),
          'department': _departmentController.text,
          'phone': _phoneController.text,
          'gender': _selectedGender,
          'birthday': DateFormat('yyyy-MM-dd').format(_selectedBirthday),
          'weddinganniversary':
              DateFormat('yyyy-MM-dd').format(_selectedWeddinganniversary),
          'email': _emailController.text,
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          // Member edited successfully
          print('Member edited successfully');
          Navigator.pop(context); // Close the page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MemberPage(selectedIndex: 0)),
          );
        } else {
          // Failed to edit member
          print('Failed to edit member');
        }
      }
    } catch (error) {
      print('Error editing member: $error');
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
                "Edit Member",
                style: headingStyle,
              ),
              MyInputField(
                title: "Surname",
                hint: "Enter member surname here",
                controller: _surnameController,
              ),
              MyInputField(
                title: "First Name",
                hint: "Enter member first name here",
                controller: _firstnameController,
              ),
              MyInputField(
                title: "Other Names",
                hint: "Enter member other name here",
                controller: _othernamesController,
              ),
              MyInputField(
                  title: "Department",
                  hint: "Enter member department here",
                  controller: _departmentController),
              MyInputField(
                  title: "Phone",
                  hint: "Enter member phone number here",
                  controller: _phoneController),
              MyInputField(
                title: "Gender",
                hint: _selectedGender,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  items: genderList.map<DropdownMenuItem<String>>(
                    (String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!,
                            style: const TextStyle(color: Colors.grey)),
                      );
                    },
                  ).toList(),
                ),
              ),
              MyInputField(
                title: "Birthday",
                hint: DateFormat.yMd().format(_selectedBirthday),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getBirthdayFromUser();
                  },
                ),
              ),
              MyInputField(
                title: "Wedding Anniversary",
                hint: DateFormat.yMd().format(_selectedWeddinganniversary),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getWeddinganniversaryFromUser();
                  },
                ),
              ),
              MyInputField(
                title: "Email",
                hint: "Enter member email here",
                controller: _emailController,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                      label: "Update Member", onTap: () => _updateMemberInDb())
                ],
              ),
              const SizedBox(height: 50.0),
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
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
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

  _getBirthdayFromUser() async {
    DateTime currentDate = DateTime.now();
    DateTime firstDate = DateTime(1900); // Set an appropriate start date
    DateTime lastDate = currentDate.add(
        const Duration(days: 365 * 150)); // Allow users up to 150 years old

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedBirthday) {
      setState(() {
        _selectedBirthday = pickedDate;
      });
    }
  }

  _getWeddinganniversaryFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2121),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedWeddinganniversary = pickerDate;
      });
    } else {
      print("No date selected or something went wrong");
    }
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
