import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newp/widgets/timerservice.dart';
import 'package:provider/provider.dart';

class timecontroller extends StatefulWidget {
  @override
  State<timecontroller> createState() => _timecontrollerState();
}

class _timecontrollerState extends State<timecontroller> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<timerservice>(context);
    return Container(
        //width: 100,
        height: 100,
        child: Container(
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  provider.timerplaying
                      ? Provider.of<timerservice>(context, listen: false)
                          .pause()
                      : Provider.of<timerservice>(context, listen: false)
                          .start();
                },
                child: IconButton(
                  icon: provider.timerplaying
                      ? Icon(Icons.pause_circle_outline_outlined,
                          color: Colors.white, size: 140)
                      : Icon(Icons.play_circle_outlined,
                          color: Colors.white, size: 140),
                  onPressed: null,
                ))));
  }
}
