import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/screens/viewDocs/image_tile.dart';
import 'package:zippyhealth/models/imageDataP.dart';
import 'package:zippyhealth/shared/loading.dart';

class ImageGridPrescriptions extends StatefulWidget {
  @override
  _ImageGridPrescriptionsState createState() => _ImageGridPrescriptionsState();
}

class _ImageGridPrescriptionsState extends State<ImageGridPrescriptions> {
  @override
  Widget build(BuildContext context) {
    final prescriptionImages = Provider.of<List<ImageDataP>>(context);
    if (prescriptionImages == null) {
      return Loading();
    } else {
      return GridView.builder(
          itemCount: prescriptionImages.length ?? 0,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return ImageGridItem(
              date: prescriptionImages[index].date,
              fileName: prescriptionImages[index].imageName,
              imagePath: prescriptionImages[index].imagePath,
              uid: prescriptionImages[index].uid,
            );
          });
    }
  }
}
