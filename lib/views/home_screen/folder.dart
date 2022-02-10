// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reader/widgets/const.dart';

class FolderContents extends StatefulWidget {
  const FolderContents({Key key}) : super(key: key);

  @override
  _FolderContentsState createState() => _FolderContentsState();
}

class Debouncer {
  int milliseconds;
  VoidCallback action;
  Timer timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class _FolderContentsState extends State<FolderContents> {
  final _debouncer = Debouncer();
  String directory;
  List file;
  List ffile = [];

  @override
  void initState() {
    _listofFiles();
    super.initState();
  }

  void _listofFiles() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final folderName = 'Balochi_docs';
      final path = Directory('/storage/emulated/0/Download');
      if ((await path.exists())) {
      } else {
        path.create();
      }
    }
    setState(() {
      file = io.Directory("/storage/emulated/0/Download")
          .listSync(); //use your folder name insted of resume.
    });

    for (var i = 0; i < file.length; i++) {
      // if (file[i].toString().split(':').first == 'File') {
      //   ffile.add(file[i]);
      // }
      if (file[i]
              .toString()
              .split('Download/')
              .last
              .split("'")
              .first
              .split('.')
              .last ==
          'baf') {
        ffile.add(file[i]);
      }
    }
    print(ffile.length);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        leadingWidth: 30,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Downloads",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ffile == null
          ? Center(
              child: Text('No Data'),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: ffile.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            push(
                              context,
                              Pdfd(
                                  file: ffile[index],
                                  name: ffile[index]
                                      .toString()
                                      .split('Balochi_docs/')
                                      .last
                                      .split('.')
                                      .first),
                            );
                          },
                          leading: Container(
                            padding: EdgeInsets.all(5),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '.pdf',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          title: Text(ffile[index]
                              .toString()
                              .split('Download/')
                              .last
                              .split("'")
                              .first
                              .split('.')
                              .first),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class Pdfd extends StatefulWidget {
  File file;
  String name;
  Pdfd({Key key, this.file, this.name}) : super(key: key);

  @override
  _PdfdState createState() => _PdfdState();
}

class _PdfdState extends State<Pdfd> {
  @override
  void initState() {
    print("${widget.file.path}.pdf");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        leadingWidth: 30,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.name
              .toString()
              .split('Download/')
              .last
              .split("'")
              .first
              .split('.')
              .first,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: PDF(
        swipeHorizontal: true,
      ).fromPath(
        "${widget.file.path}",
      ),
    );
  }
}
