import 'package:flutter/material.dart';
import 'package:newp/widgets/timerservice.dart';
import 'package:provider/provider.dart';
import 'timerservice.dart';

class progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerservice>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${provider.rounds}/4',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              '    ${provider.goals}/12',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Rounds',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'Goals',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            )
          ],
        )
      ],
    );
  }
}
