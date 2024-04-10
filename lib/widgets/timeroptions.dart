import 'package:flutter/material.dart';
import 'package:newp/usage.dart';
import 'package:provider/provider.dart';
import 'timerservice.dart';

class timeroptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerservice>(context);
    return SingleChildScrollView(
      controller: ScrollController(initialScrollOffset: 100),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: selectableTimes.map((time) {
          return InkWell(
            onTap: () => provider.selectTime(double.parse(time)),
            child: Container(
              margin: EdgeInsets.only(left: 10),
              width: 70,
              height: 50,
              child: Center(
                child: Text(
                  (int.parse(time) ~/ 60).toString(),
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              decoration: int.parse(time) == provider.selectedTime
                  ? BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 3,
                        color: Color.fromRGBO(189, 3, 251, 1),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    )
                  : BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Color.fromRGBO(255, 253, 255, 1),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
