import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:estore/constants.dart';
import 'package:estore/screens/edit_user_profile.dart';
import 'package:estore/services/firebase_services.dart';
import 'package:estore/widgets/custom_button.dart';
import 'package:estore/widgets/profile_avatar.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('UserDetails')
                        .doc('displayName')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Color(0xffD50000),
                            image: DecorationImage(
                                image: AssetImage("assets/image2-dark.png"),
                                fit: BoxFit.cover),
                          ),
                          accountName: Text(
                            _firebaseServices.getCurrentUserName() ??
                                "Display Name",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          accountEmail:
                          Text('${_firebaseServices.getCurrentEmail()}'),
                          currentAccountPicture: Avatar(),
                        );
                      } else {
                        return UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Color(0xffD50000),
                            image: DecorationImage(
                                image: AssetImage("assets/image2-dark.png"),
                                fit: BoxFit.cover),
                          ),
                          accountName: StreamBuilder<Object>(
                              stream: FirebaseFirestore.instance
                                  .collection('UserDetails')
                                  .doc('displayName')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return Text(
                                  "${_firebaseServices.getCurrentUserName()}",
                                  style: TextStyle(fontSize: 20.0),
                                );
                              }),
                          accountEmail:
                          Text('${_firebaseServices.getCurrentEmail()}'),
                          currentAccountPicture: Avatar(),
                        );
                      }
                    }),
                ListTile(
                  dense: true,
                  title: Text(
                    "Welcome to eStore",
                    style: TextStyle(fontSize: 20.0, color: Color(0xff062100)),
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUserProfile()),
                    );
                  },
                  dense: true,
                  title: Text("Profile", style: Constants.regularDarkText),
                  leading: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    showAboutDialog(
                        context: context,
                        applicationName: 'eStore',
                        applicationVersion: 'Version 1.0',
                        applicationLegalese:
                            'eStore is a Self-Checkout Mobile Application.');
                  },
                  dense: true,
                  title: Text("About App", style: Constants.regularDarkText),
                  leading: Icon(
                    Icons.info,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CustomBtn(
              text: "Logout",
              onPressed: () {
                confirmationAlert(context);
                // setState(() {
                //   confirmationAlert(context);
                // });
              },
              outlineBtn: true,
            ),
          ),
        ],
      ),
    );
  }
}

confirmationAlert(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
            title: Text("Logout?"),
            content: Text("Do you want to Logout?"),
            actions: [
              TextButton(
                child: Text(
                  "No",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ));
}
