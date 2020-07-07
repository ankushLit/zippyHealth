import 'package:flutter/material.dart';
import 'package:zippyhealth/services/database.dart';

class PopupDelete {
  showPopupMenu(int index, String imageFileUrl, String docId, String uid,
      BuildContext context, var _tapPosition, String folder) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area.
          Offset.zero & overlay.size // Bigger rect, the entire screen.
          ),
      items: [
        PopupMenuItem(
          child: FlatButton(
            child: Text("Delete"),
            onPressed: () {
              Navigator.pop(context);

              DatabaseService().deleteImage(imageFileUrl).then((value) {
                if (folder == 'prescriptions') {
                  DatabaseService(uid: uid).deletePrescriptions(docId);
                } else {
                  DatabaseService(uid: uid).deleteReports(docId);
                }
              });
              print(index.toString() + ' this index clicked');
            },
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
