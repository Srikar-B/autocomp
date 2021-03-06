import 'package:autocomplete/employee/db_service.dart';
import 'package:autocomplete/employee/employee.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Auto completer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String field = 'name';
  var faker = Faker();
  List<Employee> fakeRecords = [];
  List<Employee> matchedRecords = [];
  bool recloading = false;
  void createFakeRecords() async {
    var start = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      recloading = true;
    });
    for (int i = 0; i < 9999; i++) {
      Employee emp = Employee(
          eid: i,
          name: faker.person.name(),
          email: faker.internet.email(),
          occupation: faker.job.title(),
          company: faker.company.name(),
          uName: faker.internet.userName());
      fakeRecords.add(emp);
    }
    // add each record to the db
    var resp = await saveEmployee(fakeRecords);

    // fakeRecords.forEach((element) async {
    //   var resp = await saveEmployee(element);
    //   print(resp);
    // });

    setState(() {
      recloading = false;
    });
    var end = DateTime.now().millisecondsSinceEpoch;
    print((end - start).toString() + " milliseconds");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteDB();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(onChanged: (val) async {
              if (val.trim().isNotEmpty) {
                var records = await getOfflineEmployees(val.trim(), field);
                setState(() {
                  matchedRecords = records;
                });
              }
            }),
            DropdownButton(
                value: field,
                items: [
                  DropdownMenuItem(
                    child: Text('name'),
                    value: 'name',
                  ),
                  DropdownMenuItem(
                    child: Text('company'),
                    value: 'company',
                  ),
                  DropdownMenuItem(
                    child: Text('email'),
                    value: 'email',
                  ),
                  DropdownMenuItem(
                    child: Text('occupation'),
                    value: 'occupation',
                  ),
                ],
                onChanged: (val) {
                  setState(() {
                    matchedRecords = [];
                    field = val;
                  });
                }),
            Expanded(
              child: ListView.builder(
                  itemCount: matchedRecords.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title:
                          Text(matchedRecords[i].toMap()[field] ?? 'no text'),
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!recloading) {
              deleteDB();
              createFakeRecords();
            }
          },
          tooltip: 'Add 1K records',
          child: recloading
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Icon(Icons.book_outlined)),
    );
  }
}
