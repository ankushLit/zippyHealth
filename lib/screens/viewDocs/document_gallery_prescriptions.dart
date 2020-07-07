import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/screens/viewDocs/image_tile.dart';
import 'package:zippyhealth/models/imageDataP.dart';
import 'package:zippyhealth/shared/loading.dart';
import 'package:zippyhealth/shared/pop_up_delete.dart';

class ImageGridPrescriptions extends StatefulWidget {
  @override
  _ImageGridPrescriptionsState createState() => _ImageGridPrescriptionsState();
}

class _ImageGridPrescriptionsState extends State<ImageGridPrescriptions> {
  final PopupDelete _popupDelete = PopupDelete();
  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionImages = Provider.of<List<ImageDataP>>(context);
    if (prescriptionImages == null) {
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
                'Prescriptions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          GridView.builder(
              padding: EdgeInsets.only(top: 70),
              itemCount: prescriptionImages.length ?? 0,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTapDown: _storePosition,
                  onLongPress: () {
                    print("long press of $index");
                    _popupDelete.showPopupMenu(
                        index,
                        prescriptionImages[index].imagePath,
                        prescriptionImages[index].docId,
                        prescriptionImages[index].uid,
                        context,
                        _tapPosition,
                        'prescriptions');
                  },
                  child: ImageGridItem(
                    date: prescriptionImages[index].date,
                    fileName: prescriptionImages[index].imageName,
                    imagePath: prescriptionImages[index].imagePath,
                    uid: prescriptionImages[index].uid,
                  ),
                );
              }),
        ],
      );
    }
  }
}
