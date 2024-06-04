import 'package:lighthouse_church/components/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lighthouse_church/pages/home.dart';
// import 'package:lighthouse_church/pages/member_page.dart';
import '../components/input_field.dart';
import '../components/theme.dart';
import 'package:http/http.dart' as http;

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
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

  Future<void> _addMemberToDb() async {
    try {
      final url = Uri.parse(
          'https://reminder-app123.000webhostapp.com/public/members/create');

      final colorValue = _getSelectedColorValue();
      print('Selected color value: $colorValue');

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
          'color': colorValue, // Get selected color as string
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          // Member created successfully
          print('Member created successfully');
          Navigator.pop(context); // Close the page
          // Navigate back to home page and set the active bottom nav link to home icon
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(key: UniqueKey(), selectedIndex: 0),
            ),
          );
        } else {
          // Failed to create member
          print('Failed to create member');
        }
      }
    } catch (error) {
      print('Error creating member: $error');
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
                "Add Member",
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
                  MyButton(label: "Create Member", onTap: () => _validateData())
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
        // print(_selectedBirthday);
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
        // print(_selectedWeddinganniversary);
      });
    } else {
      print("No date selected or something went wrong");
    }
  }

  String _getSelectedColorValue() {
    switch (_selectedColor) {
      case 0:
        return 'blueClr'; // Assuming blueClr is a string color value
      case 1:
        return 'pinkClr'; // Assuming pinkClr is a string color value
      case 2:
        return 'yellowClr'; // Assuming yellowClr is a string color value
      default:
        return ''; // Default value or handle error case
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
                  print('Selected color index: $_selectedColor');
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? blueClr
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

  _validateData() {
    if (_surnameController.text.isNotEmpty &&
        _firstnameController.text.isNotEmpty) {
      // add database
      _addMemberToDb();
      Get.back();
    } else if (_surnameController.text.isEmpty ||
        _firstnameController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }
}
