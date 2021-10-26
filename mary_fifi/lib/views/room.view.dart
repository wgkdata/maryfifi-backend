import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mary_fifi/views/question.view.dart';
import 'package:mary_fifi/views/room_footer.view.dart';
import 'package:mary_fifi/views/room_header.view.dart';
import '../src/constants.dart';
import 'package:badges/badges.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main(){
  Firebase.initializeApp();
  runApp(GetQuestion("question01"));
}

class Room extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Column(
                    children: [
                      RoomHeader(),
                      Question(),
                      SizedBox(height: 10.0),
                      Question(),
                      SizedBox(height: 10.0),
                      GetQuestion('question01'),
                      SizedBox(height: 10.0),
                      RoomFooter(),
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}


class GetQuestion extends StatelessWidget {
  final String documentId;

  GetQuestion(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference questions = FirebaseFirestore.instance.collection('questions');

    return FutureBuilder<DocumentSnapshot>(
      future: questions.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['title']} ${data['description']}");
        }

        return Text("loading");
      },
    );
  }
}
