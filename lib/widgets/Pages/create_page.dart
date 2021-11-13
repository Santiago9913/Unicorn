import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/profile/main_profile_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../custom_input_text.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key, required this.user}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();

  final User user;
}

class _CreatePageState extends State<CreatePage> {
  String name = "";

  //String secondName = "";
  //String email = "";
  //String password = "";
  String uid = "";
  late AndroidDeviceInfo androidInfo;
  String error = "";
  String dropdownValue = 'Colombia';
  String dropdownValue1 = '1';
  String dropdownValue2 = '1';
  String dropdownValue3 = '1';
  String dropdownValue4 = '1';
  String dropdownValue5 = '1';
  String dropdownValue6 = '1';
  String dropdownValue7 = 'Bank funding';

  String bannerPicUrl = "";
  String profilePicUrl = "";

  final ImagePicker _picker = ImagePicker();

  bool _checked = false;
  bool enable = false;

  TextEditingController nameController = TextEditingController();

  //TextEditingController secondNameController = TextEditingController();
  //TextEditingController emailController = TextEditingController();
  //TextEditingController passwordController = TextEditingController();


  var fields = {"name": 0, "secondName": 0, "email": 0, "password": 0};

  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  void noEmptyFields() {
    int sum = 0;
    for (int v in fields.values) {
      sum += v;
    }

    if (sum == 4 && enable == false) {
      setState(() {
        enable = !enable;
      });
    } else if (sum != 4 && enable == true) {
      setState(() {
        enable = !enable;
      });
    }
  }

  void checkOrder(){

    enable = true;

    if(dropdownValue1 == dropdownValue2)
      {
        enable = false;
      }
    if(dropdownValue1 == dropdownValue3)
    {
      enable = false;
    }
    if(dropdownValue1 == dropdownValue4)
    {
      enable = false;
    }
    if(dropdownValue1 == dropdownValue5)
    {
      enable = false;
    }
    if(dropdownValue1 == dropdownValue6)
    {
      enable = false;
    }
    if(dropdownValue2 == dropdownValue3)
    {
      enable = false;
    }
    if(dropdownValue2 == dropdownValue4)
    {
      enable = false;
    }
    if(dropdownValue2 == dropdownValue5)
    {
      enable = false;
    }
    if(dropdownValue2 == dropdownValue6)
    {
      enable = false;
    }
    if(dropdownValue3 == dropdownValue4)
    {
      enable = false;
    }
    if(dropdownValue3 == dropdownValue5)
    {
      enable = false;
    }
    if(dropdownValue3 == dropdownValue6)
    {
      enable = false;
    }
    if(dropdownValue4 == dropdownValue5)
    {
      enable = false;
    }
    if(dropdownValue4 == dropdownValue6)
    {
      enable = false;
    }
    if(dropdownValue5 == dropdownValue6)
    {
      enable = false;
    }

  }

  Future<AndroidDeviceInfo> getAndroidInfo(DeviceInfoPlugin device) async {
    AndroidDeviceInfo aDevice = await device.androidInfo;
    return aDevice;
  }

  //createUserWithEmailAndPassword() async {
  // try {
  //Future<UserCredential> userCredential = FirebaseAuth.instance
  //.createUserWithEmailAndPassword(email: email, password: password);

  //UserCredential credentilas = await userCredential;
//uid = credentilas.user!.uid;
  //}

  _imgFromCamera(String name) async {
    // var status = await Permission.camera.status;

    // if (await Permission.camera.isDenied) {
    //   await Permission.camera.request();
    // }

    // if (await Permission.camera.isGranted) {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      String storagePath = 'users/${widget.user.getUserUID}';
      String filePath = image.path;
      String fileName = name;

      String url = ""; //await FirebaseStorageController.uploadImageToStorage(
      //storagePath, filePath, fileName);

      setState(() {
        if (name == 'profile') {
          profilePicUrl = url;
          widget.user.setProfilePicture(url);
        } else if (name == 'banner') {
          bannerPicUrl = url;
          widget.user.setBannerPicture(url);
        }
      });
    }
    // }
  }

  _imgFromGallery(String name) async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      String storagePath = 'users/${widget.user.getUserUID}';
      String filePath = image.path;
      String fileName = name;

      String url = ""; //await FirebaseStorageController.uploadImageToStorage(
      //storagePath, filePath, fileName);

      setState(() {
        if (name == 'profile') {
          profilePicUrl = url;
          widget.user.setProfilePicture(url);
        } else if (name == 'banner') {
          bannerPicUrl = url;
          widget.user.setBannerPicture(url);
        }
      });
    }
  }

  void _showPicker(context, String name) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery(name);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera(name);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.getName;
    bannerPicUrl = widget.user.getBannerPicURL;
    profilePicUrl = widget.user.getProfilePicURL;
  }

  @override
  void dispose() {
    nameController.dispose();
    //secondNameController.dispose();
    //emailController.dispose();
    //passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: 1.sw,
          height: 0.89.sh,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 1.sw,
                  padding: const EdgeInsets.only(left: 16, top: 2),
                  child: const Text(
                    "Create Your Page",
                    style: TextStyle(
                        fontFamily: "Geometric Sans-Serif",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                CustomInputText(
                  labelName: "Name",
                  password: false,
                  textController: nameController,
                  getText: (val) {
                    name = val;
                    if (name != "") {
                      fields["name"] = 1;
                    } else {
                      fields["name"] = 0;
                    }
                    noEmptyFields();
                  },
                ),
                Container(
                  width: 1.sw,
                  padding: const EdgeInsets.only(left: 16, top: 14),
                  child: const Text(
                    "Country",
                    style: TextStyle(
                        fontFamily: "Geometric Sans-Serif",
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 25.0, top: 2),
                  child: Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 6),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<String>(
                      hint: const Text('Select a country'),
                      elevation: 5,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      style: TextStyle(color: Colors.black54, fontSize: 17.0),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Argentina',
                        'Bolivia',
                        'Brasil',
                        'Chile',
                        'Colombia',
                        'Ecuador',
                        'Paraguay',
                        'Peru',
                        'Uruguay',
                        'Venezuela'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  width: 1.sw,
                  padding: const EdgeInsets.only(left: 16, top: 14, bottom: 14),
                  child: const Text(
                    "Banner image",
                    style: TextStyle(
                        fontFamily: "Geometric Sans-Serif",
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 0.183.sh,
                          width: 0.8.sw,
                          decoration: bannerPicUrl.isEmpty
                              ? null
                              : BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(bannerPicUrl),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                          child: Center(
                            child: Container(
                              width: 0.8.sw,
                              height: 0.183.sh,
                              color: Colors.grey.withOpacity(0.5),
                              child: IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.camera_alt_outlined),
                                onPressed: () {
                                  _showPicker(context, 'banner');
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 16, top: 14, bottom: 14),
                      child: const Text(
                        "Profile image",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF3D5AF1),
                          radius: 50,
                          child: CircleAvatar(
                            backgroundImage: profilePicUrl.isEmpty
                                ? null
                                : NetworkImage(profilePicUrl),
                            radius: 48,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.camera_alt_outlined),
                                onPressed: () {
                                  _showPicker(context, 'profile');
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: CheckboxListTile(
                        title: Text(
                          "Is your startup using international funding resources (ICO)?",
                          style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.platform,
                        value: _checked,
                        onChanged: (bool? value) {
                          setState(() {
                            _checked = value!;
                          });
                        },
                        activeColor: Color(0xFF3D5AF1),
                        checkColor: Colors.white,
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 16, top: 40, bottom: 14),
                      child: const Text(
                        "Rank the following funding types in order of preference:",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, bottom: 14),
                      child: const Text(
                        "- Bank funding",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50.0, right: 260, top: 0, bottom: 20),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton<String>(
                          hint: const Text('1'),
                          elevation: 5,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          isExpanded: true,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 17.0),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          value: dropdownValue1,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue1 = newValue!;
                            });

                            checkOrder();
                          },
                          items: <String>['1', '2', '3', '4', '5', '6']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, bottom: 14),
                      child: const Text(
                        " - Business angel",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50.0, right: 260, top: 0, bottom: 20),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton<String>(
                          hint: const Text('1'),
                          elevation: 5,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          isExpanded: true,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 17.0),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          value: dropdownValue2,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue2 = newValue!;
                            });

                            checkOrder();
                          },
                          items: <String>['1', '2', '3', '4', '5', '6']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, bottom: 14),
                      child: const Text(
                        " - Venture capital",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50.0, right: 260, top: 0, bottom: 20),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton<String>(
                          hint: const Text('1'),
                          elevation: 5,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          isExpanded: true,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 17.0),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          value: dropdownValue3,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue3 = newValue!;
                            });

                            checkOrder();
                          },
                          items: <String>['1', '2', '3', '4', '5', '6']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, bottom: 14),
                      child: const Text(
                        " - Government",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50.0, right: 260, top: 0, bottom: 20),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton<String>(
                          hint: const Text('1'),
                          elevation: 5,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          isExpanded: true,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 17.0),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          value: dropdownValue4,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue4 = newValue!;
                            });

                            checkOrder();
                          },
                          items: <String>['1', '2', '3', '4', '5', '6']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, bottom: 14),
                      child: const Text(
                        " - Funding",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50.0, right: 260, top: 0, bottom: 20),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton<String>(
                          hint: const Text('1'),
                          elevation: 5,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          isExpanded: true,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 17.0),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          value: dropdownValue5,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue5 = newValue!;
                            });

                            checkOrder();
                          },
                          items: <String>['1', '2', '3', '4', '5', '6']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, bottom: 14),
                      child: const Text(
                        " - Crowdfunding",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50.0, right: 260, top: 0, bottom: 20),
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton<String>(
                          hint: const Text('1'),
                          elevation: 5,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          isExpanded: true,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 17.0),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          value: dropdownValue6,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue6 = newValue!;
                            });

                            checkOrder();
                          },
                          items: <String>['1', '2', '3', '4', '5', '6']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      padding:
                          const EdgeInsets.only(left: 16, top: 20, bottom: 14),
                      child: const Text(
                        "What is the type of financial funding that best suits you as a startup in each sector and at a given stage of development?",
                        style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 25.0, top: 2),
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 6),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton<String>(
                          hint: const Text('Select a country'),
                          elevation: 5,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36.0,
                          isExpanded: true,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 17.0),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          value: dropdownValue7,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue7 = newValue!;
                            });
                          },
                          items: <String>[
                            'Bank funding',
                            'Business angel',
                            'Venture capital',
                            'Government',
                            'Funding',
                            'Crowdfunding'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: ElevatedButton(
                          child: const Text(
                            "Create",
                            style: TextStyle(
                              fontFamily: "Geometric Sans-Serif",
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: const Color(0xFF3D5AF1),
                              fixedSize: Size(0.88.sw, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onSurface: const Color(0xFF3D5AF1)),
                          onPressed: enable ? ()  {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainProfilePage(
                                    user: widget.user,
                                  ),
                                ),
                                (route) => false);

                          } : null ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}