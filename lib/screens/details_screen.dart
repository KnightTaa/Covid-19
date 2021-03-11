import 'package:covid19/config/palette.dart';
import 'package:covid19/constants.dart';
import 'package:covid19/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  var local_total_cases;
  var local_deaths;
  var local_recovered;
  var local_active_cases;

  Future getCurrent() async {
    http.Response response = await http.get("https://hpb.health.gov.lk/api/get-current-statistical");
    var results = jsonDecode(response.body);
    setState(() {
      this.local_total_cases = results['data']['local_total_cases'];
      this.local_deaths = results['data']['local_deaths'];
      this.local_recovered = results['data']['local_recovered'];
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
      appBar: buildDetailsAppBar(context),
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
                  title: "සමස්ථ රෝගීන්",
                  iconColor: Color(0xFFFF8C00),
                  effectedNum: local_total_cases != null ? local_total_cases.toString() : "Loading..",
                  press: (){},
                ),
                InfoCard(
                  title: "සමස්ථ මරණ",
                  iconColor: Color(0xFFFF2D55),
                  effectedNum: local_deaths != null ? local_deaths.toString() : "Loading..",
                  press: (){},
                ),
                InfoCard(
                  title: "සමස්ථ සුවය \nලැබූවන්",
                  iconColor: Color(0xFF50E3C2),
                  effectedNum: local_recovered != null ? local_recovered.toString() : "Loading..",
                  press: (){},
                ),
                InfoCard(
                  title: "ප්‍රතිකාර ලබන \nරෝගීන්",
                  iconColor: Color(0xFF5856D6),
                  effectedNum: local_active_cases != null ? local_active_cases.toString() : "Loading..",
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
                    'වැළැක්වීමේ උපදෙස්',
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
          title: "දෑත් \nපිරිසිදු \nකරන්න",
        ),
        PreventionCard(
          svgSrc: "assets/images/use_mask.svg",
          title: "මුව \nආවරණයක් \nපළඳින්න",
        ),
        PreventionCard(
          svgSrc: "assets/images/Clean_Disinfect.svg",
          title: "මතුපිට \nපිරිසිදු \nකරන්න",
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
          Container(
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
                    Color(0xFF473F97)
                  ]
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "වෛද්‍ය උපදෙස් සදහා 1999 අමතන්න.",
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

  AppBar buildDetailsAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        iconSize: 28,
        onPressed: (){
          Navigator.pop(context);
        },
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
