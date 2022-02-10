// import 'package:flutter/material.dart';
// import 'package:reader/views/home_screen/main_screen.dart';
// import 'package:reader/views/home_screen/menu_screen.dart';

// class HomeScreen extends StatefulWidget {
//   // const HomeScreen({Key key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _drawerController = ZoomDrawerController();
//   @override
//   Widget build(BuildContext context) {
//     return ZoomDrawer(
//       disableGesture: true,
//       controller: _drawerController,
//       style: DrawerStyle.DefaultStyle,
//       mainScreen: MainScreen(),
//       menuScreen: MenuScreen(),
//       borderRadius: 24.0,
//       slideWidth: MediaQuery.of(context).size.width / 3,
//       openCurve: Curves.decelerate,
//       closeCurve: Curves.bounceIn,
//     );
//   }
// }
