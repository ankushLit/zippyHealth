import 'package:flutter/material.dart';
import 'package:zippyhealth/screens/viewDocs/image_item.dart';

class ImageGridPrescriptions extends StatelessWidget {
  Widget makeImageGrid() {
    return GridView.builder(
      itemCount: 6,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return GridTile(child: ImageGridItem(index));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
