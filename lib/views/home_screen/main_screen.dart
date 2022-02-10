// ignore_for_file: prefer_final_fields, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:reader/views/home_screen/folder.dart';
import 'package:reader/views/home_screen/menu_screen.dart';
import 'package:reader/views/pdfView/pdf_view.dart';
import 'package:reader/widgets/const.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class MainScreen extends StatefulWidget {
  MainScreen() : super();

  @override
  MainScreenState createState() => MainScreenState();
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

class MainScreenState extends State<MainScreen> {
  final _debouncer = Debouncer();

  List<Subject> blist = [];
  List<Subject> bookLists = [];

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

  String url = 'https://ebook.balochiacademy.org/api/getAllFiles';

  Future<List<Subject>> getAllEbookList() async {
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        List<Subject> list = parseAgents(response.body);
        print(response.body);
        return list;
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  static List<Subject> parseAgents(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Subject>((json) => Subject.fromJson(json)).toList();
  }

  @override
  void initState() {
    createFolder();
    super.initState();
    checkConnection();
    getAllEbookList().then(
      (subjectFromServer) {
        setState(
          () {
            blist = subjectFromServer;
            bookLists = blist;
          },
        );
      },
    );
  }

  bool connected;

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connected = false;
      });
    }
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: MenuScreen(),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: connected == false
                ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('No internet connection.'),
                        ElevatedButton(
                          onPressed: () {
                            checkConnection();
                            getAllEbookList().then(
                              (subjectFromServer) {
                                setState(
                                  () {
                                    blist = subjectFromServer;
                                    bookLists = blist;
                                  },
                                );
                              },
                            );
                          },
                          child: Text('Reload'),
                        ),
                        Text('\n'),
                        InkWell(
                            onTap: () {
                              push(
                                context,
                                FolderContents(),
                              );
                            },
                            child: Text('Go to Downloads...'))
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 0),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    scaffoldKey.currentState.openDrawer();
                                  },
                                  icon: Icon(Icons.menu)),
                              Expanded(
                                child: TextField(
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: InkWell(
                                      child: Icon(Icons.search),
                                    ),
                                    isDense: true,
                                    hintText: 'Search for Books.....',
                                  ),
                                  onChanged: (string) {
                                    _debouncer.run(
                                      () {
                                        setState(
                                          () {
                                            bookLists = blist
                                                .where(
                                                  (u) =>
                                                      (u.author_name
                                                          .toLowerCase()
                                                          .contains(
                                                            string
                                                                .toLowerCase(),
                                                          )) ||
                                                      (u.category_name
                                                          .toLowerCase()
                                                          .contains(
                                                            string
                                                                .toLowerCase(),
                                                          )) ||
                                                      (u.title
                                                          .toLowerCase()
                                                          .contains(
                                                            string
                                                                .toLowerCase(),
                                                          )),
                                                )
                                                .toList();
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  getAllEbookList().then(
                                    (subjectFromServer) {
                                      setState(
                                        () {
                                          blist = subjectFromServer;
                                          bookLists = blist;
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.refresh_rounded),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.2,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: bookLists.isEmpty
                                ? SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: SkeletonGridLoader(
                                      builder: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: GridTile(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: 50,
                                                height: 10,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                width: 70,
                                                height: 10,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      items: 12,
                                      itemsPerRow: 3,
                                      period: Duration(seconds: 1),
                                      highlightColor: Colors.grey,
                                      childAspectRatio: 0.6,
                                    ),
                                  )
                                : GridView.builder(
                                    reverse:
                                        bookLists.length < 9 ? false : true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 0.6),
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.all(2.0),
                                    itemCount: bookLists.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String fileLink =
                                          "https://ebook.balochiacademy.org/storage/" +
                                              bookLists[index].url;
                                      String thumbLink =
                                          "https://ebook.balochiacademy.org/storage/" +
                                              bookLists[index].thumb;
                                      String fileName = bookLists[index].title;
                                      List title = fileName.split('.pdf');
                                      return GridTile(
                                        child: SizedBox(
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  push(
                                                    context,
                                                    Reader(
                                                        title: title.first,
                                                        file: fileLink),
                                                  );
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      4,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: thumbLink,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Center(
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Image.asset(
                                                              'assets/images/loading_logo.png'),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if ((bookLists[index].id) % 1 ==
                                                  0)
                                                renderSeparator()
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget renderSeparator() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 10,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/24.jpg'), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(10, 5),
          ),
        ],
      ),
    );
  }
}

class Subject {
  var title;
  var author_name;
  var category_name;
  var url;
  var thumb;
  var id;
  Subject({
    @required this.title,
    @required this.author_name,
    @required this.category_name,
    @required this.url,
    @required this.thumb,
    @required this.id,
  });

  factory Subject.fromJson(Map<dynamic, dynamic> json) {
    return Subject(
      title: json['title'],
      author_name: json['author_name'],
      category_name: json['category_name'],
      url: json['file'],
      thumb: json['thumb'],
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'autor_name': this.author_name,
      'category_name': this.category_name,
      'url': this.url,
      'thumb': this.thumb,
      'id': this.id,
    };
  }
}
