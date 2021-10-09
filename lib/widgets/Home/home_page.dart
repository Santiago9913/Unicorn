import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorn/widgets/Home/home_place_holder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key = const Key("any_key")}) : super(key: key);

  @override
  State createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State {
  int _currentIndex = 0;
  static final List _children = [
    PlaceholderWidget(
      child: Container(
        height: 1.sh,
        width: 1.sw,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/Saly16.png',
              height: 200.h,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 200,
                child: Text(
                  "You don’t have posts right know. Follow some one to see news on your feed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB2B2B2),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    PlaceholderWidget(
      child: Container(
        height: 1.sh,
        width: 1.sw,
        child: Column(),
      ),
    ),
    PlaceholderWidget(
      child: Container(
        height: 1.sh,
        width: 1.sw,
        child: Column(),
      ),
    ),
    PlaceholderWidget(
      child: Container(
        height: 1.sh,
        width: 1.sw,
        child: Column(),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 55.sp,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF0E153A),
          statusBarIconBrightness: Brightness.light,
        ),
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 24),
          color: const Color(0xFF0E153A),
          height: 0.15.sh,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person_pin, color: Colors.white),
              Container(
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(238, 243, 248, 1),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(238, 243, 248, 1),
                        spreadRadius: 3),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        color: Color.fromRGBO(104, 106, 108, 1)),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 220.0,
                        height: 15,
                        child: const TextField(
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
                          style: TextStyle(
                              color: Color.fromRGBO(104, 106, 108, 1),
                              decoration: TextDecoration.none),
                        ))
                  ],
                ),
              ),
              const Icon(Icons.filter_list, color: Colors.white)
            ],
          ),
        ),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(14, 21, 58, 1),
        selectedItemColor: const Color.fromRGBO(61, 90, 241, 1),
        unselectedItemColor: Colors.white,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Weekly',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Pages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Profile',
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }
}
