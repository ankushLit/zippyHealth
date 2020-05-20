import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'auth.dart';

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

  StorageUploadTask _uploadTask;

  void _startUpload(String folder) async {
    String x = await _authService.getUid();
    String filepath = x + '/' + folder + '/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filepath).putFile(widget.file);
    });
  }

  void _selectFolderPrompt() {
    showDialog(
        context: context,
        builder: (context) {
          bool reportsSelected = false;
          bool prescriptionsSelected = false;
          List<String> folderType = ['Prescriptions', 'Reports'];
          String selectedFolderType = 'Prescriptions';
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Select Type'),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton.icon(
                      label: Text('Prescriptions'),
                      icon: Icon(Icons.list),
                      color: prescriptionsSelected ? Colors.teal : Colors.grey,
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
                      color: reportsSelected ? Colors.teal : Colors.grey,
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
                actions: [
                  FlatButton(
                    child: Text('Upload'),
                    onPressed: () {
                      _startUpload(selectedFolderType);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;
          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            children: <Widget>[
              if (_uploadTask.isComplete) Text('Uploaded'),
              if (_uploadTask.isPaused)
                FlatButton(
                  onPressed: _uploadTask.resume,
                  child: Icon(Icons.play_arrow),
                ),
              if (_uploadTask.isInProgress)
                FlatButton(
                  onPressed: _uploadTask.pause,
                  child: Icon(Icons.pause),
                ),
              LinearProgressIndicator(
                value: progressPercent,
              ),
              Text('${(progressPercent * 100).toStringAsFixed(2)}%')
            ],
          );
        },
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.teal,
        ),
        child: FlatButton.icon(
          onPressed: () {
            _selectFolderPrompt();
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
}
