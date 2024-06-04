// import 'package:flutter/material.dart';
// import '../components/theme.dart';
// import 'components/theme.dart';

// class BottomNavigation extends StatefulWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   BottomNavigation({required this.selectedIndex, required this.onItemTapped});

//   @override
//   _BottomNavigationState createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: Colors.blue,
//       unselectedItemColor: Colors.grey,
//       currentIndex: widget.selectedIndex,
//       onTap: widget.onItemTapped,
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_add),
//           label: 'Add Member',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.people),
//           label: 'Members',
//         ),
//       ],
//     );
//   }
// }
