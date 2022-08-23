import 'package:doctor/dashboard_patient/widgets/avatar_image.dart';
import 'package:doctor/doctor_dashboard/appointments/save_consult/add_doses.dart';
import 'package:doctor/doctor_dashboard/appointments/save_consult/doses_card.dart';
import 'package:doctor/doctor_dashboard/appointments/save_consult/doses_card_all.dart';
import 'package:doctor/doctor_dashboard/custom_widgtes/app_bar.dart';
import 'package:doctor/doctor_dashboard/more_tab/edit_profile/slidable.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SaveConsultDD extends StatefulWidget {
  const SaveConsultDD(
      {Key? key, required this.appointmentNumber, this.patientName})
      : super(key: key);
  final appointmentNumber;
  final patientName;

  @override
  _SaveConsultDDState createState() => _SaveConsultDDState();
}

class _SaveConsultDDState extends State<SaveConsultDD>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var dataDoses;
  var response2;
  bool dataHomeFlag = true;
bool appDonF=false;



  Future<void> getAllDoses() async {
    var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/all_doses_api.php';
    Map<String, dynamic> body = {
      'appointment_no': widget.appointmentNumber.toString()
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getAPPOINTMENTS $error"));
    if (response.statusCode == 200) {
      dataDoses = jsonDecode(response.body.toString());
      setState(() {
        dataHomeFlag = false;
      });
    } else {}
  }
  Future<void> appointmentsDone() async {
    appDonF=true;
    var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/complete_after_dose_api.php';
    Map<String, dynamic> body = {
      'appointment_no': widget.appointmentNumber.toString()
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to appointmentsDone $error"));
    if (response.statusCode == 200) {
      dataDoses = jsonDecode(response.body.toString());
      setState(() {
        appDonF = false;
      });
      Navigator.pop(context);
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDoses();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(children: <Widget>[
        Text('Medicine Name',
            style: TextStyle(
              height: 3.0,
              fontSize: 20.2,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * .1,
        ),
        Text('Type',
            style: TextStyle(
              height: 3.0,
              fontSize: 20.2,
              fontWeight: FontWeight.bold,
            )),
        Spacer(),
        Text('Dosage Time',
            style: TextStyle(
              height: 3.0,
              fontSize: 20.2,
              fontWeight: FontWeight.bold,
            )),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          isleading: false,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Row(
                      children: [
                        //Tex
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24, // Changing Drawer Icon Size
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                        ),
                        Text(
                          '#${widget.appointmentNumber}  ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ), //
                        Text(
                          '${widget.patientName}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ), // Tex
                      ],
                    ),
                  )),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 20,
                    width: 100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => AddDozesDD(
                                  button: 'Save',
                                  appNo: widget.appointmentNumber))).then((value) => dataHomeFlag=true);
                        },
                        child: Text(
                          'Add Doses',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                )
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(55),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .45,
                          child: Text(
                            'Medicine Name ',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: Text(
                            'Dosage ',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: Center(
                              child: Text(
                            'Duration ',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ))),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .01,
                      ),
                    ],
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              elevation: 4.0,
              backgroundColor: Colors.blue,
              titleSpacing: 0.00,
              floating: true,
              pinned: true,
              snap: true,
            ),
          ];
        },
        body: ListView(
          children: [
            // header(),
            // Divider(
            //   color: Colors.black,
            //   thickness: 1,
            // ),
            dataHomeFlag
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: FutureBuilder(
                    future: getAllDoses(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: dataDoses.length,
                          itemBuilder: (context, index) {
                            return DosesCardForAll(
                              doseId: dataDoses[index]['id'],
                              index: index,
                              button: 'button',
                              medicineName: dataDoses[index]['pills_name'],
                              medicineType: dataDoses[index]['pills_type'],
                              medicinePower: dataDoses[index]['pills_power'],
                              medicinDoses: dataDoses[index]['pills_dose'],
                              image:
                                  'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=940&q=80',
                              medicineRepetationPerDay:
                              dataDoses[index]['pills_timing'],
                              medicineRepedationLongTime:
                              dataDoses[index]['pills_repeat_timing'],
                              notes: dataDoses[index]['note'],
                            );
                          });
                    },
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * .5,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    appointmentsDone();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  child: appDonF?Center(child: CircularProgressIndicator(),):Text(
                    'Done',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              color: Colors.green,
              height: 50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Old Appointments',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}