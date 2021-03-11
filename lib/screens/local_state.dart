import 'package:covid19/config/palette.dart';
import 'package:covid19/constants.dart';
import 'package:covid19/screens/details_screen.dart';
import 'package:covid19/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocalState extends StatefulWidget {
  @override
  _LocalStateState createState() => _LocalStateState();
}

class _LocalStateState extends State<LocalState> {

  var local_new_cases;
  var local_total_cases;
  var local_total_number_of_individuals_in_hospitals;
  var local_deaths;
  var local_new_deaths;
  var local_recovered;
  var local_active_cases;
  var total_pcr_testing_count;
  var update_date_time;

  Future getCurrent() async {
    http.Response response = await http.get("https://hpb.health.gov.lk/api/get-current-statistical");
    var results = jsonDecode(response.body);
    setState(() {
      this.local_new_cases = results['data']['local_new_cases'];
      this.local_total_cases = results['data']['local_total_cases'];
      this.local_total_number_of_individuals_in_hospitals = results['data']['local_total_number_of_individuals_in_hospitals'];
      this.local_deaths = results['data']['local_deaths'];
      this.local_new_deaths = results['data']['local_new_deaths'];
      this.local_recovered = results['data']['local_recovered'];
      this.local_active_cases = results['data']['local_active_cases'];
      this.total_pcr_testing_count = results['data']['total_pcr_testing_count'];
      this.update_date_time = results['data']['update_date_time'];
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
            'In Sri Lanka/ශ්‍රී ලංකාවේ',
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
                  effectedNum: local_new_cases != null ? local_new_cases.toString() : "0",
                ),
                InfoCard(
                  title: "නව මරණ",
                  iconColor: Color(0xFFFF2D55),
                  effectedNum: local_new_deaths != null ? local_new_deaths.toString() : "0",
                ),
                InfoCard(
                  title: "සැක සහිත \nරෝගීන්",
                  iconColor: Color(0xFF50E3C2),
                  effectedNum: local_total_number_of_individuals_in_hospitals != null ? local_total_number_of_individuals_in_hospitals.toString() : "Loading..",
                ),
                InfoCard(
                  title: "ප්‍රතිකාර ලබන \nරෝගීන්",
                  iconColor: Color(0xFF5856D6),
                  effectedNum: local_active_cases != null ? local_active_cases.toString() : "Loading..",
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
                    'COVID-19 තත්ත්ව වාර්තාව',
                    style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    update_date_time != null ? update_date_time.toString() : "Loading",
                    style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1
                    ),
                  ),
                  SizedBox(height: 10,),
                  buildPrevention(),
                  SizedBox(height: 25,),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF9C00).withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset("assets/images/running.svg", height: 30, width: 30,),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "සමස්ථ PCR පරීක්ෂණ ගණන",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: kTextColor),
                                  children: [
                                    TextSpan(
                                        text: total_pcr_testing_count != null ? total_pcr_testing_count.toString() : "Loading..",
                                      style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailsScreen();
                            },
                          ),
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
                              Color(0xFF60BE93),
                              Color(0xFF1B8D59),
                            ]
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "සමස්ථ රෝගීන් පිළිබඳ \nදැන ගැනීමට ->",
                                style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
                              ),
                              TextSpan(
                                text: "",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
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





