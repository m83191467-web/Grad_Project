import 'package:flutter/material.dart';

import 'map_screen.dart';
class PassengerScreen extends StatelessWidget {
  const PassengerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F5F5),


      // ==============================
      // APP BAR
      // لاحقاً:
      // - عرض صورة واسم الراكب من Firebase
      // - إشعارات الرحلات
      // ==============================

      appBar: AppBar(

        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

        title: const Text("Navio"),

        centerTitle: true,

        actions: [

          IconButton(
            onPressed: () {

              // TODO:
              // صفحة الإشعارات من Firebase

            },

            icon: const Icon(Icons.notifications_none),

          )

        ],

      ),




      // ==============================
      // DRAWER
      // لاحقاً:
      // جلب بيانات المستخدم:
      // الاسم
      // الصورة
      // البريد
      // رقم الهاتف
      // من Firestore
      // ==============================


      drawer: Drawer(

        child: ListView(

          children: const [


            DrawerHeader(

              decoration: BoxDecoration(
                color: Colors.black,
              ),


              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  CircleAvatar(

                    radius: 35,

                    child: Icon(
                      Icons.person,
                      size:35,
                    ),

                  ),



                  SizedBox(height:10),



                  Text(
                    "اسم الراكب",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),



                  Text(
                    "example@gmail.com",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),



                  // TODO:
                  // إضافة بيانات Firebase هنا


                ],

              ),

            ),





            ListTile(

              leading: Icon(Icons.person),

              title:
              Text("الملف الشخصي"),

              // TODO:
              // صفحة تعديل بيانات المستخدم

            ),




            ListTile(

              leading:
              Icon(Icons.history),

              title:
              Text("الرحلات السابقة"),

              // TODO:
              // عرض الرحلات من Firestore


            ),




            ListTile(

              leading:
              Icon(Icons.payment),

              title:
              Text("طرق الدفع"),

              // TODO:
              // ربط الدفع الإلكتروني


            ),





            ListTile(

              leading:
              Icon(Icons.settings),

              title:
              Text("الإعدادات"),

            ),




            ListTile(

              leading:
              Icon(Icons.logout),

              title:
              Text("تسجيل الخروج"),

              // TODO:
              // Firebase Auth signOut

            ),


          ],

        ),

      ),





      body: Padding(

        padding:
        const EdgeInsets.all(16),



        child: Column(


          crossAxisAlignment:
          CrossAxisAlignment.start,



          children: [





            const Text(

              "مرحباً 👋",

              style:
              TextStyle(

                fontSize:26,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            const SizedBox(height:5),




            const Text(

              "إلى أين تريد الذهاب؟",

              style:
              TextStyle(

                color:Colors.grey,

              ),

            ),




            const SizedBox(height:20),





            // ==============================
            // البحث عن الوجهة
            // لاحقاً:
            // Google Places API
            // اختيار المكان من الخريطة
            // ==============================


            TextField(

              decoration:
              InputDecoration(

                hintText:
                "ابحث عن الوجهة",

                prefixIcon:
                const Icon(Icons.search),


                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(15),

                ),

              ),

            ),




            const SizedBox(height:20),





            // ==============================
            // مكان الخريطة
            //
            // الخطوة القادمة:
            //
            // Google Maps Flutter
            // GPS Location
            // Current Location
            // Marker
            // Polyline
            // حساب المسافة
            //
            // ==============================


            // TODO: هنا ح نضع Google Maps + GPS
            Expanded(
              child: MapScreen(),
            ),




            const SizedBox(height:20),




            // ==============================
            // زر حساب السعر
            //
            // لاحقاً:
            //
            // يأخذ:
            // - المسافة KM
            // - سعر البنزين
            // - تكلفة التشغيل
            // - نوع المركبة
            //
            // ويرسلها لنموذج الذكاء الاصطناعي
            //
            // ==============================


            SizedBox(

              width:
              double.infinity,


              height:
              55,



              child:
              ElevatedButton.icon(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.black,


                  foregroundColor:
                  Colors.white,

                ),



                onPressed: () {


                  // TODO:
                  // فتح شاشة حساب السعر


                },



                icon:
                const Icon(
                  Icons.directions_bus,
                ),



                label:
                const Text(

                  "احسب سعر الرحلة",

                  style:
                  TextStyle(

                    fontSize:18,

                  ),

                ),

              ),

            ),



            const SizedBox(height:15),



          ],


        ),


      ),

    );

  }

}