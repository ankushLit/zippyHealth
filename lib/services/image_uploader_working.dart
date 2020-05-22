import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zippyhealth/services/database.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'auth.dart';
import 'package:zippyhealth/shared/constants.dart';
import 'package:zippyhealth/models/image_data_model.dart';

class Uploader extends StatefulWidget {
  final File file;

  const Uploader({Key key, this.file}) : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://zippyhealth-f938e.appspot.com');
  final AuthService _authService = AuthService();

  // StorageUploadTask _uploadTask;

  // void _startUpload(String folder, String fileName) async {
  //   String x = await _authService.getUid();
  //   String filepath = x + '/' + folder + '/${DateTime.now()}.png';
  //   await DatabaseService(uid: x).saveStorageData(fileName, folder);
  //   _uploadTask = _storage.ref().child(filepath).putFile(widget.file);
  //   setState(() {});
  // }

  Future<String> _fileNamePrompt(BuildContext context) {
    TextEditingController _ctrl = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter File name'),
        content: TextField(
          controller: _ctrl,
        ),
        actions: [
          FlatButton(
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              Navigator.of(context).pop(_ctrl.text.toString());
            },
          ),
        ],
      ),
    );
  }

  Future<ImageStorageData> _selectFolderPrompt(
    BuildContext context,
  ) {
    TextEditingController _ctrl = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          bool reportsSelected = false;
          bool prescriptionsSelected = false;
          List<String> folderType = ['prescriptionsImages', 'reportsImages'];
          String selectedFolderType;
          StorageUploadTask _uploadTask;
          final _formKey = GlobalKey<FormState>();

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: _uploadTask != null
                    ? StreamBuilder<StorageTaskEvent>(
                        stream: _uploadTask.events,
                        builder: (context, snapshot) {
                          var event = snapshot?.data?.snapshot;
                          double progressPercent = event != null
                              ? event.bytesTransferred / event.totalByteCount
                              : 0;
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (_uploadTask.isComplete)
                                  Column(
                                    children: [
                                      Text('Uploaded'),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                if (_uploadTask.isPaused)
                                  Column(
                                    children: [
                                      Text('Uploading Paused'),
                                      FlatButton(
                                        onPressed: _uploadTask.resume,
                                        child: Icon(Icons.play_arrow),
                                      ),
                                    ],
                                  ),
                                if (_uploadTask.isInProgress)
                                  Column(
                                    children: [
                                      Text('Uploading'),
                                      Center(
                                          child: SpinKitChasingDots(
                                        color: const Color(0xff48C9B0),
                                        size: 50.0,
                                      )),
                                      FlatButton(
                                        onPressed: _uploadTask.pause,
                                        child: Icon(Icons.pause),
                                      ),
                                    ],
                                  ),
                                // LinearProgressIndicator(
                                //   value: progressPercent,
                                // ),
                                Text(
                                    '${(progressPercent * 100).toStringAsFixed(2)}%')
                              ],
                            ),
                          );
                        })
                    : Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Enter file name',
                                style: TextStyle(
                                    color: _ctrl.text.isEmpty
                                        ? Colors.red
                                        : Colors.teal),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _ctrl,
                                decoration: textInputDecorection.copyWith(
                                    hintText: 'Enter file name'),
                                validator: (val) => val.isEmpty
                                    ? 'Please Enter File Name'
                                    : null,
                                onChanged: (val) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Select file type',
                                style: TextStyle(
                                    color: selectedFolderType != null
                                        ? Colors.teal
                                        : Colors.red),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton.icon(
                                    label: Text('Prescriptions'),
                                    icon: Icon(Icons.list),
                                    color: prescriptionsSelected
                                        ? Colors.teal
                                        : Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        selectedFolderType = folderType[0];
                                        prescriptionsSelected = true;
                                        reportsSelected = false;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FlatButton.icon(
                                    label: Text('Reports'),
                                    icon: Icon(Icons.pages),
                                    color: reportsSelected
                                        ? Colors.teal
                                        : Colors.grey,
                                    onPressed: () {
                                      setState(() {
                                        selectedFolderType = folderType[1];

                                        prescriptionsSelected = false;
                                        reportsSelected = true;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                actions: [
                  _uploadTask == null
                      ? FlatButton(
                          child: Text(
                            'Upload',
                            style: TextStyle(color: Colors.teal),
                          ),
                          onPressed: () async {
                            //_startUpload(selectedFolderType, _ctrl.text);
                            if (_formKey.currentState.validate()) {
                              if (selectedFolderType != null) {
                                String x = await _authService.getUid();
                                String filepath = x +
                                    '/' +
                                    selectedFolderType +
                                    '/${_ctrl.text.toString()}.png';
                                await DatabaseService(uid: x).saveStorageData(
                                    _ctrl.text.toString(), selectedFolderType);
                                _uploadTask = _storage
                                    .ref()
                                    .child(filepath)
                                    .putFile(widget.file);
                                setState(() {});
                              }
                            }
                            // ImageStorageData _imageStorageData = ImageStorageData(
                            //     _ctrl.text.toString(), selectedFolderType);
                            //Navigator.of(context).pop(_imageStorageData);
                          },
                        )
                      : FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Done'),
                        )
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // if (_uploadTask != null) {
    //   return StreamBuilder<StorageTaskEvent>(
    //     stream: _uploadTask.events,
    //     builder: (context, snapshot) {
    //       var event = snapshot?.data?.snapshot;
    //       double progressPercent =
    //           event != null ? event.bytesTransferred / event.totalByteCount : 0;
    //       return Column(
    //         children: <Widget>[
    //           if (_uploadTask.isComplete) Text('Uploaded'),
    //           if (_uploadTask.isPaused)
    //             FlatButton(
    //               onPressed: _uploadTask.resume,
    //               child: Icon(Icons.play_arrow),
    //             ),
    //           if (_uploadTask.isInProgress)
    //             FlatButton(
    //               onPressed: _uploadTask.pause,
    //               child: Icon(Icons.pause),
    //             ),
    //           LinearProgressIndicator(
    //             value: progressPercent,
    //           ),
    //           Text('${(progressPercent * 100).toStringAsFixed(2)}%')
    //         ],
    //       );
    //     },
    //   );
    // } else {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.teal,
      ),
      child: FlatButton.icon(
        // onPressed: () {
        //   _selectFolderPrompt();
        // },
        onPressed: () {
          print('pressed');
          // _selectFolderPrompt(context).then((value) {
          //   ImageStorageData recievedData = value;
          //   print(recievedData.fileName);
          //   _startUpload(recievedData.folder, recievedData.fileName);
          // });
          // _fileNamePrompt(context).then((value) {
          //   setState(() {
          //     fileName = value;
          //   });
          _selectFolderPrompt(context);
          // });
        },
        icon: Icon(
          Icons.cloud_upload,
          color: Colors.white,
        ),
        label: Text(
          'Upload to cloud',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
// }
