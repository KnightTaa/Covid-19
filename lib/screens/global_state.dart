import 'package:covid19/config/palette.dart';
import 'package:covid19/constants.dart';
import 'package:covid19/screens/details_screen.dart';
import 'package:covid19/widgets/info_card.dart';
import 'package:covid19/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GlobalState extends StatefulWidget {
  @override
  _GlobalStateState createState() => _GlobalStateState();
}

class _GlobalStateState extends State<GlobalState> {

  var global_new_cases;
  var global_total_cases;
  var local_total_number_of_individuals_in_hospitals;
  var global_deaths;
  var global_recovered;
  var local_active_cases;

  Future getCurrent() async {
    http.Response response = await http.get("https://hpb.health.gov.lk/api/get-current-statistical");
    var results = jsonDecode(response.body);
    setState(() {
      this.global_new_cases = results['data']['global_new_cases'];
      this.global_total_cases = results['data']['global_total_cases'];
      this.local_total_number_of_individuals_in_hospitals = results['data']['local_total_number_of_individuals_in_hospitals'];
      this.global_deaths = results['data']['global_deaths'];
      this.global_recovered = results['data']['global_recovered'];
      this.local_active_cases = results['data']['local_active_cases'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryColor,
        elevation: 0.0,
        title: Center(
          child: Text(
            'In World/ලෝකයේ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          _buildBody(screenHeight),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildBody(double screenHeight){
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.03),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                )
            ),
            child: Wrap(
              runSpacing: 20,
              spacing: 20,
              children: [
                InfoCard(
                  title: "නව රෝගීන්",
                  iconColor: Color(0xFFFF8C00),
                  effectedNum: global_new_cases != null ? global_new_cases.toString() : "Loading..",
                  press: (){},
                ),
                InfoCard(
                  title: "සමස්ථ රෝගීන්",
                  iconColor: Color(0xFFFF2D55),
                  effectedNum: global_total_cases != null ? global_total_cases.toString() : "Loading..",
                  press: (){},
                ),
                InfoCard(
                  title: "සමස්ථ මරණ",
                  iconColor: Color(0xFF50E3C2),
                  effectedNum: global_deaths != null ? global_deaths.toString() : "Loading..",
                  press: (){},
                ),
                InfoCard(
                  title: "සමස්ථ සුවය \nලැබූවන්",
                  iconColor: Color(0xFF5856D6),
                  effectedNum: global_recovered != null ? global_recovered.toString() : "Loading..",
                  press: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailsScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preventions',
                    style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildPrevention(),
                  SizedBox(height: 40,),
                  buildHelpCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row buildPrevention() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PreventionCard(
          svgSrc: "assets/images/hand_wash.svg",
          title: "Wash Hands",
        ),
        PreventionCard(
          svgSrc: "assets/images/use_mask.svg",
          title: "Use Masks",
        ),
        PreventionCard(
          svgSrc: "assets/images/Clean_Disinfect.svg",
          title: "Clean Disinfect",
        ),
      ],
    );
  }
  Container buildHelpCard(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          GestureDetector(
            onTap: (){
              showModalBottomSheet(
                isScrollControlled: true,
                  context: context,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context){
                  return Container(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
                          child: Container(
                            height: 8.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.all(const Radius.circular(8.0))
                            ),
                          ),
                        ),
                        Text(
                          'වැළැක්වීමේ උපදෙස්',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset("assets/images/1.jpg"),
                        ),

                      ],
                    ),
                  );
                  }
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.4,
                top: 20,
                right: 20,
              ),
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFAD9FE4),
                      Color(0xFF473F97),
                    ]
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "සේවා ස්ථානය කොවිඩ්-19",
                      style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text: "\nරෝගයෙන් ආරක්ෂා \nකරගැනීමට",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SvgPicture.asset("assets/images/nurse.svg"),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SvgPicture.asset("assets/images/virus.svg"),
          ),
        ],
      ),
    );
  }
}
class PreventionCard extends StatelessWidget {
  final String svgSrc;
  final title;
  const PreventionCard({
    Key key, this.svgSrc, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(svgSrc),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .body2
              .copyWith(
              color: kPrimaryColor
          ),
        ),
      ],
    );
  }
}