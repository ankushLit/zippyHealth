import 'package:flutter/material.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrescriptionView extends StatelessWidget {
  final Prescriptions prescription;

  PrescriptionView({this.prescription});

  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 80.0),
        QrImage(
          data: prescription.presId,
          size: 150.0,
        ),
        SizedBox(height: 8.0),
        Container(
          width: 90.0,
          child: new Divider(
            color: const Color(0xff117864),
            thickness: 4.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          prescription.docName,
          style: TextStyle(color: Colors.white, fontSize: 35.0),
        ),
        SizedBox(height: 4.0),
        Text(
          prescription.date,
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
        SizedBox(height: 20.0),
      ],
    );

    final topContent = Align(
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.46,
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: const Color(0xff17A589)),
            child: Center(
              child: topContentText,
            ),
          ),
          Positioned(
            left: 8.0,
            top: 60.0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          )
        ],
      ),
    );
    Widget spacer() {
      return Container(
        width: 5.0,
      );
    }

    Widget line() {
      return Container(
        color: const Color(0xff17A589),
        height: 3.0,
        width: 70.0,
      );
    }

    int prescriptionCounter = 0;
    int prescriptionIndex = -5;
    int tabletTimingIndex = 0;
    int dosageIndex = -5;
    final bottomContent = Expanded(
      child: ListView.builder(
          itemCount: ((prescription.tablets.length) ~/ 5).toInt(),
          itemBuilder: (context, index) {
            return Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  leading: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          (++prescriptionCounter).toString(),
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  title: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        prescription.tablets[prescriptionIndex += 5],
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('Dosage: ' + prescription.tablets[dosageIndex += 6]),
                    ],
                  ),
                  subtitle: Column(children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10.0,
                        ),
                        prescription.tablets[tabletTimingIndex =
                                    prescriptionIndex + 2] ==
                                '1'
                            ? Icon(
                                Icons.check_circle,
                                color: const Color(0xff17A589),
                              )
                            : Icon(
                                Icons.radio_button_unchecked,
                                color: const Color(0xff17A589),
                              ),
                        spacer(),
                        line(),
                        spacer(),
                        prescription.tablets[++tabletTimingIndex] == '1'
                            ? Icon(
                                Icons.check_circle,
                                color: const Color(0xff17A589),
                              )
                            : Icon(
                                Icons.radio_button_unchecked,
                                color: const Color(0xff17A589),
                              ),
                        spacer(),
                        line(),
                        spacer(),
                        prescription.tablets[++tabletTimingIndex] == '1'
                            ? Icon(
                                Icons.check_circle,
                                color: const Color(0xff17A589),
                              )
                            : Icon(
                                Icons.radio_button_unchecked,
                                color: const Color(0xff17A589),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ]),
                ));
          }),
    );
    return Scaffold(
      backgroundColor: const Color(0xffD1F2EB),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
