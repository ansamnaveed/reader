import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
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
            "About Us",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Image(
                  image: AssetImage(
                    'assets/images/splash_logo.png',
                  ),
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '       Balochi Academy, Quetta is one of the oldest literary and research bodies, registered with the Government of Balochistan. The Academy is engaged in promoting Balochi Language, since its inception in 1961, the Academy has in its credit publications over more than 500 books in Balochi, Urdu, English, and Persian languages thereby promoting the rich historical and cultural heritage of Balochistan and its people.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '       Balochi Academy’s Mobile application has been developed for free online access to Balochi books from anywhere in the world. This app is supported Android and IOS platforms. In the app, all books of the Academy will be available for reading online and offline.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '       This application is created and launched by Balochi Academy in 2022.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
