import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorn/api/api.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/Home/home_place_holder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/widgets/Pages/create_page.dart';
import 'package:unicorn/widgets/Search/search_view.dart';
import 'package:unicorn/widgets/post/post_create_view.dart';
import 'package:unicorn/widgets/post/post_main_widget.dart';
import 'package:unicorn/widgets/profile/main_profile_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.user,
    this.locationAccess,
    this.location,
    this.totalPages,
  }) : super(key: key);

  final User? user;
  final bool? locationAccess;
  final String? location;
  final int? totalPages;

  @override
  State createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool locationGranted = true;
  String selectedValueTrends = "United States";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  

  Api mApi = Api();
  List<DropdownMenuItem<String>> countriesListMenu = <DropdownMenuItem<String>>[];
  List<Widget> inversionsChildrenList = <Widget>[];
  List<Widget> trendsChildrenList = <Widget>[];

  @override
  void initState() {
    super.initState();
    loadCountriesDropdownMenu();
    loadInversions();
    loadTrend(selectedValueTrends);
    if (widget.locationAccess != null) {
      if (widget.locationAccess! && widget.location != "") {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _scaffoldKey.currentState!.showSnackBar(
            SnackBar(
              content: Text(
                  "There are ${widget.totalPages} ${widget.user!.type == "Entrepreneur" ? "startups" : "ventures"} in ${widget.location}"),
              backgroundColor: const Color(0xFF0E153A),
              duration: const Duration(seconds: 10),
            ),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CratePostPage(
                  user: widget.user!,
                ),
              ),
            );
          },
          child: const Icon(Icons.post_add),
          backgroundColor: const Color(0xFF0E153A),
        ),

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
                widget.user!.getProfilePicURL.isEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainProfilePage(
                                user: widget.user!,
                              ),
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    : GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainProfilePage(
                                user: widget.user!,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(widget.user!.getProfilePicURL),
                          radius: 16,
                        ),
                      ),
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
                      const Icon(
                        Icons.search,
                        color: Color.fromRGBO(104, 106, 108, 1),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 220.0,
                        height: 15,
                        child: TextField(
                          cursorColor: Colors.black,
                          maxLines: 1,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (String input) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(input: input, user: widget.user!,),
                              ),
                            );
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Search',
                          ),
                          style: const TextStyle(
                            color: Color.fromRGBO(104, 106, 108, 1),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        body: IndexedStack(
          children: [
            PlaceholderWidget(
              child: Container(
                // color: const Color(0xFFC4C4C4),
                color: Colors.white,
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
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Other09.png',
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
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Other18.png',
                      height: 200.h,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          "You don’t have pages created. Create one to see them in this",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFB2B2B2),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        child: const Text(
                          "Create Page",
                          style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          elevation: 0,
                          primary: const Color(0xFF0E153A),
                          fixedSize: Size(0.3.sw, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePage(
                                user: widget.user!,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            PlaceholderWidget(
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: ListView(
                  children: inversionsChildrenList,
                ),
              ),
            ),
            PlaceholderWidget(
              child: SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButtonFormField(
                        menuMaxHeight: 400,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF0E153A), width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF0E153A), width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Color(0xFF0E153A),
                        ),
                        dropdownColor: Color(0xFF0E153A),
                        value: selectedValueTrends,
                        items: countriesListMenu,
                        onChanged: (String? newValue){
                          loadTrend(newValue!);
                          setState(() {
                            selectedValueTrends = newValue;
                          });
                        },
                      ),
                      SizedBox(
                          height: 0.65.sh,
                          width: 1.sw,
                          child: ListView(
                            children: trendsChildrenList,
                          )
                      )
                    ],
                  ),
                )
              ),
            ),
          ],
          index: _currentIndex,
        ), // new
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF0E153A),
            selectedItemColor: const Color(0xFF3D5AF1),
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
                icon: Icon(Icons.precision_manufacturing),
                label: 'Industries',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Trends',
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadCountriesDropdownMenu () {
    mApi.getCountries().then((countries) {
      List<DropdownMenuItem<String>> mCountries = <DropdownMenuItem<String>>[];
      for (int i = 0; i < countries.length; i++) {
        mCountries.add(
            DropdownMenuItem(
                child: Text(
                  countries[i].name,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                value: countries[i].name
            )
        );
      }
      setState(() {
        countriesListMenu = mCountries;
      });
    });
  }

  void loadTrend (String country) {
    mApi.getTrends(country).then((trends) {
      List<Widget> mTrends = [];
      for (int i = 0; i < trends.length; i++) {
        var mName = trends[i].name;
        var mFunding = trends[i].funding.toString();
        var mStartups = trends[i].startups.toString();
        var mItem = Card(
            elevation: 4,
            margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Wrap(
                    spacing: 7,
                    direction: Axis.vertical,
                    children: [
                      Text(
                        'Trend: ' + mName,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Funding: \$' + mFunding),
                      Text('Amount of Startups: ' + mStartups)
                    ]
                )
            )
        );
        mTrends.add(mItem);
      }
      setState(() {
        trendsChildrenList = mTrends;
      });
    });
  }

  void loadInversions () {
    mApi.getInversion().then((industries) {
      List<Widget> mInversions = [];
      for (int i = 0; i < industries.length; i++) {
        var mName = industries[i].name;
        var mFunding = industries[i].funding.toString();
        var mStartups = industries[i].startups.toString();
        var mItem = Card(
            elevation: 4,
            margin: EdgeInsets.fromLTRB(14, 7, 14, 7),
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Wrap(
                    spacing: 7,
                    direction: Axis.vertical,
                    children: [
                      Text(
                        'Industry: ' + mName,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Funding: \$' + mFunding),
                      Text('Amount of Startups: ' + mStartups)
                    ]
                )
            )
        );
        mInversions.add(mItem);
      }
      setState(() {
        inversionsChildrenList = mInversions;
      });
    });
  }

  void onTabTapped(int index) {
    setState(() {
        _currentIndex = index;
      },
    );
  }
}
