import 'package:flutter/material.dart';

class LocalStatsTotalGrid extends StatefulWidget {
  @override
  _LocalStatsTotalGridState createState() => _LocalStatsTotalGridState();
}

class _LocalStatsTotalGridState extends State<LocalStatsTotalGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: [
          Flexible(
            child: Row(
              children: [
                _buildSateCard("Total Cases", "1.81 M", Colors.orange),
                _buildSateCard("Total Deaths", "10 K", Colors.red),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: [
                _buildSateCard("Recovered", "300 K", Colors.green),
                _buildSateCard("Active", "1.31 M", Colors.lightBlue),
                _buildSateCard("Critical", "N/A", Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Expanded _buildSateCard(String title, String count, MaterialColor color){
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
