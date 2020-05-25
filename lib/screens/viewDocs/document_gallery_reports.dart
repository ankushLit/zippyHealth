import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/screens/viewDocs/image_tile.dart';
import 'package:zippyhealth/models/imageDataR.dart';
import 'package:zippyhealth/shared/loading.dart';

class ImageGridReports extends StatefulWidget {
  @override
  _ImageGridReportsState createState() => _ImageGridReportsState();
}

class _ImageGridReportsState extends State<ImageGridReports> {
  @override
  Widget build(BuildContext context) {
    final reportImages = Provider.of<List<ImageDataR>>(context);
    if (reportImages == null) {
      return Loading();
    } else {
      return GridView.builder(
          itemCount: reportImages.length ?? 0,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return ImageGridItem(
              date: reportImages[index].date,
              fileName: reportImages[index].imageName,
            );
          });
    }
  }
}
