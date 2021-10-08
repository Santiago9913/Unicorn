import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorn/widgets/main_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key key = const Key("any_key")}) : super(key: key);

  @override
  State createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState  extends State {
  int _currentIndex = 0;
  List _children = [
    PlaceholderWidget(Colors.white, 'You don’t have posts right know. Follow some one to see news on your feed', 'assets/icons/Other04.png'),
    PlaceholderWidget(Colors.deepOrange, 'Hola mundo', 'assets/icons/Other04.png'),
    PlaceholderWidget(Colors.green, "You don’t have pages created. Create one to see them in this", 'assets/icons/Other04.png'),
    PlaceholderWidget(Colors.green, 'Hola mundo', 'assets/icons/Other04.png')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Color.fromRGBO(14, 21, 58, 1)),
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 24),
          color: Color.fromRGBO(14, 21, 58, 1),
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person_pin, color: Colors.white),
              Container(
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(238, 243, 248, 1),
                  boxShadow: [
                    BoxShadow(color: Color.fromRGBO(238, 243, 248, 1), spreadRadius: 3),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Color.fromRGBO(104, 106, 108, 1)),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 220.0,
                        height: 15,
                        child: TextField(
                            cursorColor: Colors.black,
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: 'Search',
                            ),
                            style: TextStyle(color: Color.fromRGBO(104, 106, 108, 1), decoration: TextDecoration.none),
                        )
                    )
                  ],
                ),
              ),
              Icon(Icons.filter_list, color: Colors.white)
            ],
          ),
        ),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(14, 21, 58, 1),
        selectedItemColor: Color.fromRGBO(61, 90, 241, 1),
        unselectedItemColor: Colors.white,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Weekly'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Pages')
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              title: Text('Profile')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final String asset;

  PlaceholderWidget(this.color, this.text, this.asset);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(asset, width: 180, height: 180,),
          Container(
            child: Text(text),
          )
        ],
      ),
    );
  }
}
