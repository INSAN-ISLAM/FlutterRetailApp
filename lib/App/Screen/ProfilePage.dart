//import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ratailapp/Widget/AppEevatedButton.dart';
import 'package:ratailapp/Widget/AppTextField.dart';
import 'package:ratailapp/Widget/ProfilePage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _PayMentPageState();
}

class _PayMentPageState extends State<ProfileScreen> {
  final TextEditingController _NameETController = TextEditingController();
  final TextEditingController _WhatsAppETController = TextEditingController();
  final TextEditingController _AddressETController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool m = true;
  String? imgUrl;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> updateProfile() async {
    // if (pickedImage != null) {
    //   List<int> imageBytes = await pickedImage!.readAsBytes();
    //   print(imageBytes);
    //   base64Image = base64Encode(imageBytes);
    //   print(base64Image);
    // }
    //
    // if (pickedImage2 != null) {
    //   List<int> imageBytes = await pickedImage2!.readAsBytes();
    //   print(imageBytes);
    //   base64Image2 = base64Encode(imageBytes);
    //   print(base64Image2);
    //}
    if (pickImage != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref();
        var snapshot = await storageRef.child('newfile');
        String downloadUrl = await snapshot.getDownloadURL();
        setState(() {
          imgUrl = downloadUrl;
        });
        print('Image uploaded: $downloadUrl');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    try {
      final result = FirebaseFirestore.instance.collection('PersonDetails').add({
        'WhatsApp Number': _WhatsAppETController.text,
        'Address': _AddressETController.text,
        'Name': _NameETController.text,
        //  'image': widget.image,
        'Uid': user!.uid,
        'NID Photo': imgUrl ?? '',
        'Selfee photo' : base64Image2 ?? ''
      });
    } catch (e) {
      // Error occurred during signup
      print('Error signing up: $e');
      // showSnackBarMessage(context as BuildContext, 'Registration Failed! Try again', true);
    }
  }
  // Future<void> _uploadImage() async {
  //   if (pickImage != null) {
  //     try {
  //       final storageRef = FirebaseStorage.instance.ref();
  //       final imagesRef = storageRef.child('profile_images/${Path.basename(pickImage!.path)}');
  //       await imagesRef.putFile(pickImage! as File);
  //       String  downloadUrl = await imagesRef.getDownloadURL();
  //       setState(() {
  //         imgUrl = downloadUrl;
  //       });
  //       print('Image uploaded: $downloadUrl');
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  // }
  //



  XFile? pickedImage;
  XFile? pickedImage2;
  String? base64Image;
  String? base64Image2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                UserProfileWidget(),

                const SizedBox(
                  height: 12,
                ),
                AppTextFieldWidget(
                  controller: _NameETController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return ' Wrong  Number ';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                AppTextFieldWidget(
                  controller: _AddressETController,
                  hintText: 'Address ',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return ' Wrong  Number ';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                AppTextFieldWidget(
                  controller: _WhatsAppETController,
                  hintText: ' WhatsApp Number',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return ' Wrong  Number ';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),

                InkWell(
                  onTap: () async {
                    pickImage();
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )),
                        child: const Text('NID Photo'),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              )),
                          child: Text(
                            pickedImage?.name ?? '',
                            maxLines: 1,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () async {
                    pickImage2();
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )),
                        child: const Text('Selfee'),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              )),
                          child: Text(
                            pickedImage2?.name ?? '',
                            maxLines: 1,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: 48,
                  width: 358,
                  child: AppElevatedButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {


                        updateProfile();

                      }
                    },
                    child: Center(
                      child: Text(
                        "Submit",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                            //fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick image from'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      setState(() {});
                    }
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () async {
                    pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {});
                    }
                  },
                  leading: const Icon(Icons.image),
                  title: const Text('Gallery'),
                ),
              ],
            ),
          );
        });
  }

  void pickImage2() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick image from'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    pickedImage2 = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedImage2 != null) {
                      setState(() {});
                    }
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                ),
              ],
            ),
          );
        });
  }
}
