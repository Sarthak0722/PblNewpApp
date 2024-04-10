/*import 'package:flutter/material.dart';
import 'timerservice.dart';
import 'package:provider/provider.dart';

class timercard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerservice>(context);
    final displaytime = (provider.selectedTime ~/ 60).toString();
    final seconds = (provider.currentDuration % 60);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "FOCUS",
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.2,
              height: 170,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(65, 2, 62, 0.5),
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ]),
              child: Center(
                  child: Text(
                displaytime,
                style: const TextStyle(
                    fontSize: 70,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              )),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              ':',
              style: TextStyle(
                  fontSize: 60,
                  color: Color.fromARGB(255, 60, 2, 71),
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(width: 10),
            Container(
              width: MediaQuery.of(context).size.width / 3.2,
              height: 170,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(65, 2, 62, 0.5),
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ]),
              child: Center(
                  child: Text(
                seconds == 0
                    ? "${seconds.round()}0"
                    : seconds.round().toString(),
                style: const TextStyle(
                    fontSize: 70,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              )),
            )
          ],
        )
      ],
    );
  }
}*/
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timerservice.dart';

class timercard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<timerservice>(
      builder: (context, provider, _) {
        final displayMinutes = (provider.currentDuration ~/ 60).toString();
        final displaySeconds =
            (provider.currentDuration % 60).toInt().toString().padLeft(2, '0');

        final displayTime = '$displayMinutes:$displaySeconds';

        final progressPercent =
            provider.currentDuration / provider.selectedTime;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "FOCUS",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildCircularTimerDisplay(
              time: displayTime,
              context: context,
              percentage: progressPercent,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCircularTimerDisplay(
      {required String time,
      required BuildContext context,
      required double percentage}) {
    return Container(
      width: 170,
      height: 170,
      child: CustomPaint(
        foregroundPainter: CircleTimerPainter(
          lineColor: const Color.fromARGB(255, 253, 252, 253),
          completeColor: Colors.transparent,
          completePercent: percentage,
          width: 10.0, // Width of the border
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              fontSize: 40,
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleTimerPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

  CircleTimerPainter(
      {required this.lineColor,
      required this.completeColor,
      required this.completePercent,
      required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = math.min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, line);

    Paint complete = Paint()
      ..color = _calculateCompleteColor()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    double arcAngle = 2 * math.pi * completePercent;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, arcAngle, false, complete);
  }

  Color _calculateCompleteColor() {
    // Adjust the color dynamically based on the percentage of completion
    double red = 255 - (255 * completePercent);
    double green = 0;
    double blue = 255 * completePercent;
    return Color.fromARGB(255, 180, 2, 245);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
