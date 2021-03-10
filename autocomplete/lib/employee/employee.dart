// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

class Employee {
  Employee({
    this.eid,
    this.name,
    this.email,
    this.occupation,
    this.uName,
    this.company,
  });

  int eid;
  String name;
  String email;
  String occupation;
  String uName;
  String company;

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        eid: json["eid"] == null ? null : json["eid"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        occupation: json["occupation"] == null ? null : json["occupation"],
        uName: json["uName"] == null ? null : json["uName"],
        company: json["company"] == null ? null : json["company"],
      );

  Map<String, dynamic> toMap() => {
        "eid": eid == null ? null : eid,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "occupation": occupation == null ? null : occupation,
        "uName": uName == null ? null : uName,
        "company": company == null ? null : company,
      };
  factory Employee.fromRawJson(String str) =>
      Employee.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        eid: json["eid"] == null ? null : json["eid"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        occupation: json["occupation"] == null ? null : json["occupation"],
        uName: json["uName"] == null ? null : json["uName"],
        company: json["company"] == null ? null : json["company"],
      );

  Map<String, dynamic> toJson() => {
        "eid": eid == null ? null : eid,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "occupation": occupation == null ? null : occupation,
        "uName": uName == null ? null : uName,
        "company": company == null ? null : company,
      };
}
