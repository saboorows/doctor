import 'dart:convert';

import 'package:doctor/core/custom_form_field.dart';
import 'package:doctor/core/custom_snackbar.dart';
import 'package:doctor/dashboard_patient/widgets/avatar_image.dart';
import 'package:doctor/doctor_dashboard/appointments/save_consult/save_consult.dart';
import 'package:doctor/doctor_dashboard/appointments/success_screen.dart';
import 'package:doctor/doctor_dashboard/custom_widgtes/app_bar.dart';
import 'package:doctor/doctor_dashboard/more_tab/assistent/rating_bar.dart';
import 'package:doctor/model/model_assistence.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddAssistent extends StatefulWidget {
  const AddAssistent({Key? key, required this.button, required this.doctor_id})
      : super(key: key);
  final button;
  final doctor_id;

  @override
  _AddAssistentState createState() => _AddAssistentState();
}

class _AddAssistentState extends State<AddAssistent> {
  final TextEditingController _startDateController =
      new TextEditingController();
  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerMobile = new TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  bool isAssistentAdded = false;
  String? symptoms = 'Morning Empty Stomach';
  var symptomsList = [
    "Morning Empty Stomach",
    "Morning After Breakfast",
    "Before Launch",
    "After Launch",
    "Evening",
    "Before Dinner",
    "After Dinner",
    "Before Sleep",
  ];

  String? status = 'Active';
  var statusList = [
    "Active",
    "Left",
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          isleading: false,
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   bottomOpacity: 0.0,
      //   elevation: 0.0,
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           Text(
      //             'Dr. Abhishekh',
      //             style: TextStyle(
      //               fontSize: 14.0,
      //               color: Colors.black,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           Text(
      //             'MBBS',
      //             style: TextStyle(
      //               fontSize: 14.0,
      //               color: Colors.black,
      //               fontWeight: FontWeight.w500,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: AvatarImagePD(
      //         "https://images.unsplash.com/photo-1537368910025-700350fe46c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
      //         radius: 35,
      //         height: 40,
      //         width: 40,
      //       ),
      //     ),
      //   ],
      //   titleSpacing: 0.00,
      //   title: Image.asset(
      //     'assets/img_2.png',
      //     width: 150,
      //     height: 90,
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: Colors.blue,
              title: Text("Add Assistent"),
            ),
            SizedBox(
              height: 450,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 10,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormField(
                            controlller: _controllerName,
                            errorMsg: 'Enter Assistent Name',
                            labelText: 'Assistent Name',
                            readOnly: false,
                            icon: Icons.person,
                            textInputType: TextInputType.text),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerMobile,
                            errorMsg: 'Enter Your Mobile',
                            labelText: 'Mobile',
                            readOnly: false,
                            icon: Icons.phone_android,
                            textInputType: TextInputType.number),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Theme(
                          data: new ThemeData(
                            primaryColor: Colors.redAccent,
                            primaryColorDark: Colors.red,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 18.0, right: 18.0, bottom: 15),
                            padding: const EdgeInsets.only(left: 10.0),
                            decoration: myBoxDecoration(),
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            //          <// --- BoxDecoration here
                            child: DropdownButton(
                                // Initial Value
                                menuMaxHeight:
                                    MediaQuery.of(context).size.height,
                                value: status,
                                dropdownColor: Colors.white,
                                focusColor: Colors.blue,
                                isExpanded: true,
                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),
                                // Array list of items
                                items: statusList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (spec) {
                                  if (mounted) {
                                    setState(() {
                                      status = spec.toString();
                                    });
                                  }
                                  print('------------------${spec}');
                                }),
                          ),
                        ),
                        CustomFormField(
                            controlller: _controllerAddress,
                            errorMsg: 'Ente Full Address',
                            labelText: 'Address',
                            readOnly: false,
                            icon: Icons.person,
                            textInputType: TextInputType.text),
                        Divider(
                          color: Colors.black12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .87,
                            height: 50,
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  _add(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    textStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                child: isAssistentAdded
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text(
                                        widget.button,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<String> addAssistent(ModelAssistent? model) async {
    print('${model?.assistantName}');
    var APIURL =
        'https://cabeloclinic.com/website/medlife/php_auth_api/add_assistant_api.php';
    http.Response response = await http
        .post(Uri.parse(APIURL), body: model?.toJson())
        .then((value) => value)
        .catchError(
            (error) => print("doctore assistenet Failed to add: $error"));
    var data = jsonDecode(response.body);
    print("getRegistration DATA: ${data}");
    return data[0]['assistant_name'];
  }

  _add(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isAssistentAdded = true;
      });
      String assistant_name = await addAssistent(ModelAssistent(
        assistantName: _controllerName.text.toString(),
        number: _controllerMobile.text.toString(),
        address: _controllerAddress.text.toString(),
        doctorId: widget.doctor_id,
        status: status,
      ));
      if (assistant_name == _controllerName.text) {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Added Successfully !',
            color: Colors.green);
        setState(() {
          isAssistentAdded = false;
        });
        Navigator.pop(context);
      } else {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Failed to Registration !',
            color: Colors.red);
      }
    }
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black26),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }
}