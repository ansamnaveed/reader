import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class Reader extends StatefulWidget {
  final String title;
  final String file;

  const Reader({Key key, this.title, this.file}) : super(key: key);

  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  ReceivePort _port = ReceivePort();
  String id;
  DownloadTaskStatus status;
  int progress;
  String dStatus;
  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {
        id = data[0];
        status = data[1];
        progress = data[2];
      });

      if (status == DownloadTaskStatus.complete) {
        setState(() {
          dStatus = 'Complete';
        });
      }
      if (status == DownloadTaskStatus.failed) {
        setState(() {
          dStatus = 'Failed';
        });
      }
      if (status == DownloadTaskStatus.running) {
        setState(() {
          dStatus = 'Running';
        });
      }
      if (status == DownloadTaskStatus.canceled) {
        setState(() {
          dStatus = 'Canceled';
        });
      }
      // print(progress);
      // print(dStatus);
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    createFolder();
    super.initState();
  }

  createFolder() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final folderName = 'Balochi_docs';
      final path = Directory('/storage/emulated/0/Download/$folderName');
      if ((await path.exists())) {
      } else {
        path.create();
      }
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: 30,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          actions: [
            IconButton(
              color: Colors.black,
              onPressed: dStatus == 'Complete'
                  ? null
                  : dStatus == 'Running'
                      ? null
                      : dStatus == 'Canceled'
                          ? () {
                              downloadFile(widget.file);
                            }
                          : () {
                              downloadFile(widget.file);
                            },
              icon: dStatus == 'Complete'
                  ? Icon(
                      Icons.download_done_rounded,
                      color: Colors.green,
                    )
                  : dStatus == 'Failed'
                      ? Icon(
                          Icons.warning_rounded,
                          color: Colors.yellow,
                        )
                      : dStatus == 'Canceled'
                          ? Icon(
                              Icons.download_rounded,
                              color: Colors.black,
                            )
                          : dStatus == 'Running'
                              ? Text(
                                  "$progress%",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              : Icon(Icons.download_rounded),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: PDF(swipeHorizontal: true, enableSwipe: true).cachedFromUrl(
            widget.file,
            placeholder: (progress) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (error) => Center(child: Text(error.toString())),
          ),
        ),
      ),
    );
  }

  Future downloadFile(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final folderName = 'Balochi_docs';
      final path = Directory('/storage/emulated/0/Download/$folderName');
      if ((await path.exists())) {
      } else {
        path.create();
      }
      await FlutterDownloader.enqueue(
        fileName: '${widget.title}.baf',
        saveInPublicStorage: true,
        url: url,
        savedDir: '/storage/emulated/0/Download',
        showNotification: true,
        openFileFromNotification: false,
      );
    }
  }
}
