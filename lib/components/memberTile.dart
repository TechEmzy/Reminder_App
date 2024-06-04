// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../components/theme.dart';

// class MemberTile extends StatelessWidget {
//   // const MemberTile({super.key});
//   final Member? member;
//   MemberTile(this.member);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.only(bottom: 12),
//       child: Container(
//         padding: EdgeInsets.all(16),
//         //width: SizeConfig.screenwidth * 0.78,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: _getBGClr(member?.color ?? 0),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     member?.surname ?? "",
//                     style: GoogleFonts.lato(
//                       textStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.access_time_rounded,
//                         color: Colors.grey[200],
//                         size: 18,
//                       ),
//                       SizedBox(width: 4),
//                       Text(
//                         "${member?.birthday} - ${member?.weddinganniversary}",
//                         style: GoogleFonts.lato(
//                           textStyle: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey[100],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     member?.phone ?? "",
//                     style: GoogleFonts.lato(
//                       textStyle: TextStyle(
//                         fontSize: 15,
//                         color: Colors.grey[100],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               height: 60,
//               width: 0.5,
//               color: Colors.grey[200]!.withOpacity(0.7),
//             ),
//             RotatedBox(
//               quarterTurns: 3,
//               child: Text(
//                 member!.isCompleted == 1 ? "COMPLETED" : "TODO",
//                 style: GoogleFonts.lato(
//                   textStyle: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _getBGClr(int no) {
//     switch (no) {
//       case 0:
//         return blueClr;
//       case 1:
//         return pinkClr;
//       case 2:
//         return yellowClr;
//       default:
//         return blueClr;
//     }
//   }
// }
