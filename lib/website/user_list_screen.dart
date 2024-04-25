import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'dart:io';
import '../datamodel/user_datamodel.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Hospita Database'),
      ),
      body: Container(
        height: 300,
        width: double.infinity,
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            List<UserDataModel> list = snapshot.data;
            if (snapshot.hasData) {
              return Container(
                  height: 300,
                  width: 300,
                  child: GridView.builder(
                    controller: new ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (_) => PDF().cachedFromUrl(
                                  list[index].fileLink!,
                                  placeholder: (progress) =>
                                      Center(child: Text('$progress %')),
                                  errorWidget: (error) =>
                                      Center(child: Text(error.toString())),
                                ),
                              ));
                        },
                        child: Card(
                          shadowColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            color: Colors.grey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  text: new TextSpan(
                                    text: 'Id : ',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: list[index].id!,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: new TextSpan(
                                    text: 'Hospital : ',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: list[index].hospitalName!,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: new TextSpan(
                                    text: 'Blood Pressure : ',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: list[index].bloodPressure!,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: new TextSpan(
                                    text: 'Oxygen Level : ',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: list[index].oxygenLvl!,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: new TextSpan(
                                    text: 'Patient Age : ',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: list[index].patientAge!,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: new TextSpan(
                                    text: 'Temprature : ',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: list[index].temperature!,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 5 / 3
                        // crossAxisSpacing: 5.0,
                        // mainAxisSpacing: 5.0,
                        ),
                  ));
            } else {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future fetchData() async {
    List<UserDataModel> list = [];
    final ref = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await ref.child('users/').get();
    //  print(snapshot.value.toString());
    Map<dynamic, dynamic> lists = snapshot.value as Map<dynamic, dynamic>;
    //  print(lists.values.toList());
    lists.forEach((key, value) {
      print(value.toString());
      UserDataModel data = UserDataModel.fromJson({
        'oxygen_lvl': value['oxygen_lvl'],
        'temperature': value['temperature'],
        'file_link': value['file_link'],
        'blood_pressure': value['blood_pressure'],
        'id': value['id'],
        'patient_age': value['patient_age'],
        'hospital_name': value['hospital_name'],
        'age': value['age']
      });
      print(data.id);
      list.add(data);
    });
    return list;
  }
}
