import 'dart:convert';

import 'package:doctor/doctor_dashboard/appointments/next_card.dart';
import 'package:doctor/doctor_dashboard/appointments/pause_appointmentCard.dart';
import 'package:doctor/doctor_dashboard/custom_widgtes/appointment_card.dart';
import 'package:doctor/doctor_dashboard/custom_widgtes/appointment_card_with_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PauseAppointmentsDD extends StatefulWidget {
  const PauseAppointmentsDD({Key? key, required this.doctorId})
      : super(key: key);
  final doctorId;

  @override
  _PauseAppointmentsDDState createState() => _PauseAppointmentsDDState();
}

class _PauseAppointmentsDDState extends State<PauseAppointmentsDD> {
  var dataAppointments;
  var response2;
  bool dataHomeFlag = true;

  Future<void> getAllAppointments() async {
    var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/pending_appointment_api.php';
    Map<String, dynamic> body = {'doctor_id': widget.doctorId};
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getAPPOINTMENTS $error"));
    if (response.statusCode == 200) {
      dataAppointments = jsonDecode(response.body.toString());
      setState(() {
        dataHomeFlag = false;
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('wwwwww${widget.doctorId}');
    getAllAppointments();
  }

  final popupMenu = new PopupMenuButton(
    child: new ListTile(
      title: new Text('Doge or lion?'),
      trailing: const Icon(Icons.more_vert),
    ),
    itemBuilder: (_) => <PopupMenuItem<String>>[
      new PopupMenuItem<String>(child: new Text('Doge'), value: 'Doge'),
      new PopupMenuItem<String>(child: new Text('Lion'), value: 'Lion'),
    ],
    onSelected: (v) {},
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          dataHomeFlag
              ? Center(
            child: CircularProgressIndicator(),
          )
              : FutureBuilder(
            future: getAllAppointments(),
            builder: (context, snapshot) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: dataAppointments.length ?? 0,
                  itemBuilder: (context, index) {
                    return PauseAppointmentCard(
                      button: 'Reactive Consult',
                      appointment_no:
                      dataAppointments[index]['appointment_no'] ?? '',
                      booking_type:
                      dataAppointments[index]['booking_type'] ?? '',
                      address: dataAppointments[index]['address'] ?? '',
                      due_payment:
                      dataAppointments[index]['due_payment'] ?? '',
                      age: dataAppointments[index]['age'] ?? '',
                      date: dataAppointments[index]['date'] ?? '',
                      gender: dataAppointments[index]['gender'] ?? '',
                      patient_name:
                      dataAppointments[index]['patient_name'] ?? '',
                      received_payment: dataAppointments[index]
                      ['received_payment'] ??
                          '',
                      total_fees:
                      dataAppointments[index]['total_fees'] ?? '',
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
