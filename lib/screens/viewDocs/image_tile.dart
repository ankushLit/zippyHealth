import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:zippyhealth/screens/viewDocs/full_screen_image_photoview.dart';

class ImageGridItem extends StatelessWidget {
  final String fileName;
  final String imagePath;
  final String date;
  final String uid;
  ImageGridItem({this.fileName, this.date, this.imagePath, this.uid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImage(
                imagePath: imagePath,
              ),
            ),
          ),
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: GridTile(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: imagePath,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 159,
                  width: 150,
                ),
                // Image.network(
                //   imagePath,
                //   //fit: BoxFit.scaleDown,
                //   height: 159,
                //   width: 150,
                // ),
                Container(
                  decoration: BoxDecoration(color: Colors.teal),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        fileName,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        date,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
