import 'package:flutter/material.dart';

class ImageGridItem extends StatelessWidget {
  final String fileName;
  final String imagePath;
  final String date;
  ImageGridItem({this.fileName, this.date, this.imagePath});
  @override
  Widget build(BuildContext context) {
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
