import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reader/views/home_screen/folder.dart';
import 'package:reader/widgets/const.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 20),
              alignment: Alignment.center,
              child: Image(
                width: MediaQuery.of(context).size.width / 4,
                image: AssetImage('assets/images/splash_logo.png'),
              ),
            ),
            Divider(),
            ListTile(
              onTap: () {
                push(context, FolderContents());
              },
              title: Text(
                'Downloads',
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(
                Icons.download_rounded,
                color: Colors.black,
              ),
              minLeadingWidth: 0,
            ),
            Divider(),
            // ListTile(
            //   minLeadingWidth: 0,
            //   title: Text(
            //     'Settings',
            //     style: TextStyle(color: Colors.black),
            //   ),
            //   leading: Icon(
            //     Icons.settings_outlined,
            //     color: Colors.black,
            //   ),
            // ),
            // Divider(),
            ListTile(
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Exit?'),
                    content: Text('Are you sure to exit?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => SystemNavigator.pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              minLeadingWidth: 0,
              title: Text(
                'Exit',
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
