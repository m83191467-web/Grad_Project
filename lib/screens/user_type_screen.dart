import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'help_screen.dart';


class UserTypeScreen extends StatelessWidget {

  const UserTypeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,


      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,

        automaticallyImplyLeading: false,


        actions: [


          // زر اللغة
          IconButton(

            onPressed: () {

              showDialog(

                context: context,

                builder: (context) {

                  return AlertDialog(

                    title: const Text(
                      "Language",
                    ),


                    content: Column(

                      mainAxisSize:
                      MainAxisSize.min,


                      children: [


                        ListTile(

                          leading:
                          const Text("🇸🇩"),

                          title:
                          const Text("العربية"),


                          onTap: () {

                            Navigator.pop(context);

                          },

                        ),



                        ListTile(

                          leading:
                          const Text("🇬🇧"),

                          title:
                          const Text("English"),


                          onTap: () {

                            Navigator.pop(context);

                          },

                        ),


                      ],

                    ),

                  );

                },

              );

            },


            icon: const Icon(

              Icons.language,

              color: Colors.black,

            ),

          ),



          // زر الدعم
          IconButton(

            onPressed: () {


              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                  const HelpScreen(),

                ),

              );


            },


            icon: const Icon(

              Icons.help_outline,

              color: Colors.black,

            ),

          ),


        ],

      ),



      body: Padding(

        padding: const EdgeInsets.all(24),


        child: Column(

          children: [



            const SizedBox(height: 30),



            Image.asset(

              "assets/images/logo.png",

              width: 120,

            ),



            const SizedBox(height: 30),



            const Text(

              "Welcome to Navio",

              style: TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.bold,

                color: Colors.black,

              ),

            ),



            const SizedBox(height: 10),



            const Text(

              "اختر نوع المستخدم",

              style: TextStyle(

                fontSize: 18,

                color: Colors.grey,

              ),

            ),



            const SizedBox(height: 50),




            // الراكب
            userCard(

              icon: Icons.person_outline,

              title: "Passenger",

              subtitle: "راكب",

              onTap: () {


                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                    const LoginScreen(),

                  ),

                );


              },

            ),




            const SizedBox(height: 20),





            // السائق
            userCard(

              icon: Icons.directions_bus_outlined,

              title: "Driver",

              subtitle: "سائق",

              onTap: () {


                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(

                    content: Text(
                      "Driver screen coming soon",
                    ),

                  ),

                );


              },

            ),




            const Spacer(),




            const Text(

              "Navio © 2026",

              style: TextStyle(

                color: Colors.grey,

              ),

            ),



            const SizedBox(height: 15),



          ],


        ),


      ),


    );


  }





  Widget userCard({

    required IconData icon,

    required String title,

    required String subtitle,

    required VoidCallback onTap,

  }) {


    return InkWell(

      onTap: onTap,


      borderRadius:
      BorderRadius.circular(20),



      child: Container(

        width: double.infinity,


        padding:
        const EdgeInsets.all(20),



        decoration: BoxDecoration(


          color: Colors.white,


          borderRadius:
          BorderRadius.circular(20),



          border: Border.all(

            color: Colors.black12,

          ),



          boxShadow: const [

            BoxShadow(

              color: Colors.black12,

              blurRadius: 10,

              offset: Offset(0, 4),

            ),

          ],


        ),



        child: Row(


          children: [



            CircleAvatar(

              radius: 30,


              backgroundColor:
              Colors.black,


              child: Icon(

                icon,

                color: Colors.white,

                size: 30,

              ),

            ),




            const SizedBox(width: 20),




            Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [


                Text(

                  title,

                  style: const TextStyle(

                    fontSize: 22,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



                Text(

                  subtitle,

                  style: const TextStyle(

                    color: Colors.grey,

                    fontSize: 16,

                  ),

                ),


              ],


            ),




            const Spacer(),




            const Icon(

              Icons.arrow_forward_ios,

              size: 18,

            ),



          ],


        ),


      ),


    );


  }


}