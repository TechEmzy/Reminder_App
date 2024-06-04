// class Member {
//   int? id;
//   String? surname;
//   String? firstname;
//   String? othernames;
//   String? department;
//   String? phone;
//   String? gender;
//   String? birthday;
//   String? weddinganniversary;
//   String? email;
//   int? isCompleted;
//   // String? date;
//   String? startTime;
//   String? endTime;
//   int? color;
//   int? remind;
//   String? repeat;

//   Member({
//     this.id,
//     this.surname,
//     this.firstname,
//     this.othernames,
//     this.department,
//     this.phone,
//     this.gender,
//     this.birthday,
//     this.weddinganniversary,
//     this.email,
//     this.isCompleted,
//     // this.date,
//     this.startTime,
//     this.endTime,
//     this.color,
//     this.remind,
//     this.repeat,
//   });

//   Member.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     surname = json['surname'];
//     firstname = json['firstname'];
//     othernames = json['othernames'];
//     department = json['department'];
//     phone = json['phone'];
//     gender = json['gender'];
//     birthday = json['birthday'];
//     weddinganniversary = json['weddinganniversary'];
//     email = json['email'];
//     isCompleted = json['isCompleted'];
//     // date = json['date'];
//     startTime = json['startTime'];
//     endTime = json['endTime'];
//     color = json['color'];
//     remind = json['remind'];
//     repeat = json['repeat'];

//     // Handle null values for non-nullable properties
//     id ??= 0;
//     isCompleted ??= 0;
//     color ??= 0;
//     remind ??= 0;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['surname'] = this.surname;
//     data['firstname'] = this.firstname;
//     data['othernames'] = this.othernames;
//     data['department'] = this.department;
//     data['phone'] = this.phone;
//     data['gender'] = this.gender;
//     data['birthday'] = this.birthday;
//     data['weddinganniversary'] = this.weddinganniversary;
//     data['email'] = this.email;
//     data['isCompleted'] = this.isCompleted;
//     // data['date'] = this.date;
//     data['startTime'] = this.startTime;
//     data['endTime'] = this.endTime;
//     data['color'] = this.color;
//     data['remind'] = this.remind;
//     data['repeat'] = this.repeat;
//     return data;
//   }
// }
