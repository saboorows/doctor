import 'dart:convert';
import 'package:doctor/doctor_dashboard/custom_widgtes/app_bar.dart';
import 'package:doctor/doctor_dashboard/home_tab/search_patient_cared.dart';
import 'package:doctor/doctor_dashboard/home_tab/verify_number_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SearchAppointments extends StatefulWidget {
  const SearchAppointments({Key? key, required this.userData}) : super(key: key);
  final userData;

  @override
  _SearchAppointmentsState createState() => _SearchAppointmentsState();
}

class _SearchAppointmentsState extends State<SearchAppointments> {
  var dataPatients;
  bool dataF = true;
  bool dataF2 = false;
  int status = 0;
  bool membersF = true;

  Future<void> searchPatients(String mobile) async {
    print('...ch............................}');
    setState(() {
      dataF2 = true;
      status = 1;
    });
    var API =
        'https://cabeloclinic.com/website/medlife/php_auth_api/search_patient_members_api.php';
    Map<String, dynamic> body = {'mobile': mobile};
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to searchPatients: $error"));
    print('...ch............................${response.body}');
    if (response.statusCode == 200) {
      print('..1111....${response.body}');
      dataPatients = jsonDecode(response.body.toString());
      if (dataPatients[0]['status'] == '1') {
        setState(() {
          dataF = false;
          dataF2 = false;
          status = 2;
        });
        if (dataPatients[0]['members'].length > 0) {
          setState(() {
            membersF = false;
          });
        }
      } else if (dataPatients[0]['status'] == '0') {
        setState(() {
          status = 3;
        });
      }
      print('..111111111222222222222....${dataPatients.length ?? 0}');
    } else {}
  }

  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  DateTime selectedDate = DateTime.now();

  TextEditingController _controllerMobile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          isleading: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24, // Changing Drawer Icon Size
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              title: Text("Book Appointment"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => VerifyOtp()));
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Column(
                children: [
                  new TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _controllerMobile,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        labelText: 'search patient with registerd mobile',
                        prefixText: ' ',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        suffixStyle: const TextStyle(color: Colors.green)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .2,
                      child: ElevatedButton(
                          onPressed: () {
                            searchPatients(_controllerMobile.text);
                          },
                          child: Text('Search')),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            status == 0
                ? Text('')
                : status == 1
                    ? Text('Searching....')
                    : status == 2
                        ? Text('')
                        : status == 3
                            ? Text('Data Not Found')
                            : Text('oops something wrong please try again '),
            status != 2
                ? Center(child: Text(''))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: dataPatients.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchPatientCard(
                          name: "Name :",
                          button: 'Book Appointment',
                          appointment_no: dataPatients[0]['Patient_name'] ?? '',
                          patient_id: dataPatients[0]['patient_id'] ?? '',
                          doctor_id: widget.userData['user_id'] ?? '',
                          member_id: '',
                          booking_type: 'Self',
                          address: dataPatients[0]['Patient_name'] ?? '',
                          due_payment: '200',
                          age: dataPatients[0]['age'] ?? '',
                          date: dataPatients[0]['age'] ?? '',
                          gender: dataPatients[0]['gender'] ?? '',
                          patient_name: dataPatients[0]['age'] ?? '',
                          received_payment: '200',
                          total_fees: '400',
                        ),
                      );
                    }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            membersF
                ? Center(child: Text(''))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: dataPatients[0]['members'].length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchPatientCard(
                          name: 'Relative Name :',
                          button: 'Book Appointment',
                          appointment_no: dataPatients[0]['members'][index]['name'] ?? '',
                          patient_id: dataPatients[0]['patient_id'] ?? '',
                          doctor_id: widget.userData['user_id'] ?? '',
                          member_id: dataPatients[0]['members'][index]['member_id'] ?? '',
                          booking_type: dataPatients[0]['members'][index]['relation'] ?? '',
                          address: dataPatients[0]['members'][index]['relation'] ?? '', due_payment: '200',
                          age: dataPatients[0]['members'][index]['age'] ?? '',
                          date: dataPatients[0]['members'][index]['age'] ?? '',
                          gender: dataPatients[0]['members'][index]['gender'] ?? '',
                          patient_name: dataPatients[0]['members'][index]['name'] ?? '',
                          received_payment: '200',
                          total_fees: '400',
                        ),
                      );
                    })
          ],
        ),
      ),
    );
  }

  Container accountItems(
          String item, String charge, String dateString, String type,
          {Color oddColour = Colors.white}) =>
      Container(
        decoration: BoxDecoration(color: oddColour),
        padding:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(item, style: TextStyle(fontSize: 16.0)),
                Text(charge, style: TextStyle(fontSize: 16.0))
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dateString,
                    style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                Text(type, style: TextStyle(color: Colors.grey, fontSize: 14.0))
              ],
            ),
          ],
        ),
      );
}
