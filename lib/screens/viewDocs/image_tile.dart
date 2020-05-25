import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageGridItem extends StatelessWidget {
  final String fileName;
  final String imagePath;
  final String date;
  final String uid;
  ImageGridItem({this.fileName, this.date, this.imagePath, this.uid});
  @override
  Widget build(BuildContext context) {
    String imageUrlStart;

    // printUrl() async {
    //   StorageReference ref = FirebaseStorage.instance
    //       .ref()
    //       .child(uid + '/' + imagePath + '/' + fileName + '.png');
    //   imageUrlStart = (await ref.getDownloadURL()).toString();
    //   print(imageUrlStart);
    //   return imageUrlStart;
    // }

    // printUrl().then((value) => null);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () => {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => PrescriptionView(prescription: pres),
          //   ),
          // ),
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: GridTile(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  imagePath,
                  //fit: BoxFit.scaleDown,
                  height: 159,
                  width: 150,
                ),
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
    ;
  }
}
