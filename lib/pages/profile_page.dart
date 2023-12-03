import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/components/my_drawer.dart';
import 'package:mini_ecommerce/components/password_dialog.dart';
import 'package:mini_ecommerce/components/profile_detail.dart';
import 'package:mini_ecommerce/components/profile_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String userEmail = currentUser!.email as String;
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final controller = TextEditingController();
    final oldPasswordcontroller = TextEditingController();
    final newPasswordcontroller = TextEditingController();
    final confirmPasswordcontroller = TextEditingController();

    void showMessage(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            message,
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.w400, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    Future saveProfileDetail(String field) async {
      if (controller.text.trim().isNotEmpty) {
        await userCollection
            .doc(currentUser.email)
            .update({field: controller.text.trim()}).whenComplete(
                () => Navigator.pop(context));

        controller.clear();
      } else {
        showMessage('Field is empty, please enter something!');
      }
    }

    Future savePassword() async {
      if (newPasswordcontroller.text.isEmpty ||
          confirmPasswordcontroller.text.isEmpty) {
        showMessage('All fields are required!');
      } else if (newPasswordcontroller.text != confirmPasswordcontroller.text) {
        showMessage('Password and confirm password are different!');
      } else {
        showDialog(
          context: context,
          builder: (context) => Center(
            child: Lottie.asset('assets/animations/loading.json'),
          ),
        );

        try {
          final cred = EmailAuthProvider.credential(
              email: userEmail, password: oldPasswordcontroller.text);

          await currentUser
              .reauthenticateWithCredential(cred)
              .then((value) =>
                  currentUser.updatePassword(newPasswordcontroller.text))
              .whenComplete(() {
            Navigator.pop(context);
            Navigator.pop(context);
          });

          oldPasswordcontroller.clear();
          newPasswordcontroller.clear();
          confirmPasswordcontroller.clear();
          showMessage('Change password successfully');
        } on FirebaseAuthException catch (e) {
          oldPasswordcontroller.clear();
          newPasswordcontroller.clear();
          confirmPasswordcontroller.clear();
          showMessage(e.code);
        }
      }
    }

    void editField(String field) {
      showDialog(
          context: context,
          builder: (context) => ProfileDialog(
              onSave: () => saveProfileDetail(field),
              onCancel: () {
                Navigator.pop(context);
                controller.clear();
              },
              controller: controller,
              field: field));
    }

    void changePassword(String field) {
      showDialog(
          context: context,
          builder: (context) => PasswordDialog(
              onSave: () => savePassword(),
              onCancel: () {
                Navigator.pop(context);
                oldPasswordcontroller.clear();
                newPasswordcontroller.clear();
                confirmPasswordcontroller.clear();
              },
              oldPasswordcontroller: oldPasswordcontroller,
              newPasswordcontroller: newPasswordcontroller,
              confirmPasswordcontroller: confirmPasswordcontroller,
              field: field));
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart_page'),
                icon: const Icon(Icons.shopping_cart))
          ],
        ),
        drawer: MyDrawer(
          onSignOut: signOut,
          onSettingTap: () => Navigator.pushNamed(context, '/setting_page'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data();

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Detail',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  ProfileDetail(
                    text: userData?['username'],
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),
                  ProfileDetail(
                    text: userData?['address'],
                    sectionName: 'address',
                    onPressed: () => editField('address'),
                  ),
                  ProfileDetail(
                    text: '**********',
                    sectionName: 'password',
                    onPressed: () => changePassword('password'),
                  ),
                ],
              );
            } else {
              return Text('Error ${snapshot.hasError}');
            }
          },
        ));
  }
}
