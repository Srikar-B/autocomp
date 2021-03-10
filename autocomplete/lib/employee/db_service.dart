import 'package:autocomplete/employee/employee.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:convert';

// DATABASE LEVEL FUNCTIONS

Future<Database> databaseInit() async {
  // deleteDB();
  var path = await databasePath();
  var database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(
        'CREATE TABLE Employees (eid INTEGER UNIQUE, name TEXT,email TEXT,occupation TEXT,company TEXT,uname TEXT)');
    print('DB CREATED');
  });
  return database;
}

Future<String> databasePath() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, 'Employees.db');
  return path;
}

Future<void> deleteDB() async {
  var path = await databasePath();
  await deleteDatabase(path);
  print(' DB DELETED');
}

// STORE EMployee FUNCTION

Future<bool> saveEmployee(List<Employee> fakeRecords) async {
  var db = await databaseInit();
  Batch batch = db.batch();

  for (var rec in fakeRecords) {
    batch.insert("Employees", rec.toMap());
  }
  var resId = await batch.commit(noResult: false);
  // var resId = await db.insert("Employees", employeeObject.toMap());
  // print(employeeObject.name);

  return resId == null ? Future.value(false) : Future.value(true);
}

//  GET A LIST OF OFFLINE records

Future<List<Employee>> getOfflineEmployees(String pattern, String field) async {
  var db = await databaseInit();

  var employees = await db.rawQuery(
      "SELECT $field FROM Employees WHERE $field LIKE '$pattern%'  LIMIT 10 ");
  if (employees.isNotEmpty) {
    // print(employees.length);
    // return employees;
    var offemployees = <Employee>[];
    employees.forEach((element) {
      print(element);
      offemployees.add(Employee.fromMap(element));
    });
    return offemployees;
  }
  return [];
}
