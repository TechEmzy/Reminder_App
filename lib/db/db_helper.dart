// import 'package:lighthouse_church/models/members.dart';
// import 'package:sqflite/sqflite.dart';

// class DBHelper {
//   static Database? _db;
//   static const int _version = 1;
//   static const String _tableName = "members";

//   // Initialize the database
//   static Future<void> initDb() async {
//     if (_db != null) {
//       return;
//     }
//     try {
//       // Specify the path for the database file
//       String path = '${await getDatabasesPath()}/churchanniversaryreminder.db';

//       // Open the database or create a new one if it doesn't exist
//       _db = await openDatabase(
//         path,
//         version: _version,
//         onCreate: (db, version) {
//           print("Creating a new database");

//           // Define the table structure for members
//           return db.execute("CREATE TABLE $_tableName("
//               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
//               "surname STRING, firstname STRING, othernames STRING, "
//               "department STRING, phone STRING, gender STRING, "
//               "birthday STRING, weddinganniversary STRING, email STRING, "
//               "isCompleted INTEGER, startTime STRING, endTime STRING, "
//               "color INTEGER, remind INTEGER, repeat STRING)");
//         },
//       );
//     } catch (e) {
//       print("Error initializing database: $e");
//     }
//   }

//   // Insert a new member into the database
//   static Future<int> insert(Member? member) async {
//     try {
//       print("Insert function called");

//       // Check for null values before inserting
//       if (member == null) {
//         print("Error: Member is null");
//         return -1;
//       }

//       // Use the database's insert method to add the member
//       return await _db?.insert(_tableName, member.toJson()) ?? 1;
//     } catch (e) {
//       print("Error inserting member: $e");
//       return -1; // Return a specific value to indicate an error
//     }
//   }

//   // Query all members from the database
//   static Future<List<Map<String, dynamic>>> query() async {
//     try {
//       print("Query function called");

//       // Use the database's query method to retrieve all members
//       List<Map<String, dynamic>> result = await _db!.query(_tableName);
//       print("Query result: $result");

//       return result;
//     } catch (e) {
//       print("Error querying members: $e");
//       return []; // Return an empty list to indicate an error
//     }
//   }
// }
