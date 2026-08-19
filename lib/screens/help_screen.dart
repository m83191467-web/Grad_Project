import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),


      body: const Padding(

        padding: EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),


            SizedBox(height: 20),


            Text(
              "• How can I find nearby buses?",
              style: TextStyle(fontSize: 17),
            ),


            SizedBox(height: 15),


            Text(
              "• How is the fare calculated?",
              style: TextStyle(fontSize: 17),
            ),


            SizedBox(height: 15),


            Text(
              "• How can I contact support?",
              style: TextStyle(fontSize: 17),
            ),

          ],

        ),

      ),

    );

  }
}