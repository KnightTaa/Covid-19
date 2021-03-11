import 'package:covid19/config/palette.dart';
import 'package:covid19/config/styles.dart';
import 'package:covid19/data/data.dart';
import 'package:covid19/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void customLauncher(command) async {
    if(await canLaunch(command)){
      await launch(command);
    }else{
      print('Error');
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          _buildHeader(screenHeight),
          _buildPreventionTips(screenHeight),
          _buildYourOwnTest(screenHeight),
        ],
      ),

    );
  }
  SliverToBoxAdapter _buildHeader(double screenHeight){
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Palette.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),

        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                    'COVID-19',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                ),

              ],
            ),
            SizedBox(height: screenHeight * 0.03,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ඔබට අසනීපයක් දැනෙනවාද?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01,),
                Text(
                  'ඔබට COVID-19 රෝග ලක්ෂණ ඇති බව දැනේ නම්, කරුණාකර උදව් සඳහා වහාම අප අමතන්න',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20
                        ),
                        onPressed: (){
                          customLauncher('tel: 1999');
                        },
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        ),
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Call Now',
                          style: Styles.buttonTextStyle,
                        ),
                      textColor: Colors.white,
                    ),
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20
                      ),
                      onPressed: (){
                        customLauncher('sms: +94011 211 2705');
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      icon: const Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Send SMS',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  SliverToBoxAdapter _buildPreventionTips(double screenHeight){
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'වැළැක්වීමේ උපදෙස්',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: prevention.map((e) => Column(
                children: [
                  Image.asset(
                    e.keys.first,
                    height: screenHeight * 0.1,
                  ),
                  SizedBox(height: screenHeight * 0.015,),
                  Text(
                    e.values.first,
                    style: const TextStyle(
                        fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ))
                .toList(),
            ),
          ],
        ),
      ),
    );
  }
  SliverToBoxAdapter _buildYourOwnTest(double screenHeight){
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        padding: const EdgeInsets.all(10),
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFAD9FE4),
              Color(0xFF473F97)
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/own_test.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'ඔබේම පරීක්ෂණයක් \nකරන්න!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01,),
                Text(
                    'ඔබේම පරීක්ෂණයක් \nකිරීමට උපදෙස් \nඅනුගමනය කරන්න.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
