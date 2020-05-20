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

  void _startUpload() async {
    String x = await _authService.getUid();
    String filepath = x + '/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filepath).putFile(widget.file);
    });
  }

  void _selectFolderPrompt() {
    bool reportsSelected = false;
    bool prescriptionsSelected = false;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Select Type'),
              content: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.list),
                    color: prescriptionsSelected ? Colors.teal : Colors.grey,
                    onPressed: () {
                      prescriptionsSelected = true;
                      reportsSelected = false;
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.pages),
                    color: reportsSelected ? Colors.teal : Colors.grey,
                    onPressed: () {
                      prescriptionsSelected = false;
                      reportsSelected = true;
                    },
                  ),
                ],
              ),
            ));
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
