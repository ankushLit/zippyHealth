import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/screens/viewDocs/image_tile.dart';
import 'package:zippyhealth/models/imageDataR.dart';
import 'package:zippyhealth/shared/loading.dart';
import 'package:zippyhealth/shared/pop_up_delete.dart';

class ImageGridReports extends StatefulWidget {
  @override
  _ImageGridReportsState createState() => _ImageGridReportsState();
}

class _ImageGridReportsState extends State<ImageGridReports> {
  final PopupDelete _popupDelete = PopupDelete();
  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    final reportImages = Provider.of<List<ImageDataR>>(context);
    if (reportImages == null) {
      return Loading();
    } else {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: Text(
                'Reports',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          GridView.builder(
              padding: EdgeInsets.only(top: 70),
              itemCount: reportImages.length ?? 0,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTapDown: _storePosition,
                  onLongPress: () {
                    print("long press of $index");
                    _popupDelete.showPopupMenu(
                        index,
                        reportImages[index].imagePath,
                        reportImages[index].docId,
                        reportImages[index].uid,
                        context,
                        _tapPosition,
                        'reports');
                  },
                  child: ImageGridItem(
                    date: reportImages[index].date,
                    fileName: reportImages[index].imageName,
                    uid: reportImages[index].uid,
                    imagePath: reportImages[index].imagePath,
                  ),
                );
              }),
        ],
      );
    }
  }
}
