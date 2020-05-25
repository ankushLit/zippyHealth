import 'package:flutter/material.dart';
import 'package:zippyhealth/screens/viewDocs/document_gallery_prescriptions.dart';
import 'package:zippyhealth/screens/viewDocs/document_gallery_reports.dart';

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  int _currentIndex = 0;

  Widget callPage(int currrentIndex) {
    switch (currrentIndex) {
      case 0:
        return ImageGridPrescriptions();
      case 1:
        return ImageGridReports();

        break;
      default:
        return ImageGridPrescriptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD1F2EB),
      body: callPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (val) {
          setState(() {
            _currentIndex = val;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Prescriptions"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pages),
            title: Text("Reports"),
          ),
        ],
      ),
    );
  }
}
