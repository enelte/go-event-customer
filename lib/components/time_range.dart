import 'package:flutter/material.dart';
import 'package:time_range/src/time_list.dart';
import 'package:time_range/src/util/time_of_day_extension.dart';

class TimeRange extends StatefulWidget {
  final int timeStep;
  final int timeBlock;
  final int minRange;
  final int maxRange;
  final TimeOfDay firstTime;
  final TimeOfDay lastTime;
  final Widget fromTitle;
  final Widget toTitle;
  final double titlePadding;
  final void Function(TimeRangeResult range) onRangeCompleted;
  final TimeRangeResult initialRange;
  final Color borderColor;
  final Color activeBorderColor;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final TextStyle textStyle;
  final TextStyle activeTextStyle;

  TimeRange({
    Key key,
    this.timeBlock,
    this.onRangeCompleted,
    this.firstTime,
    this.lastTime,
    this.minRange = 1,
    this.maxRange = 0,
    this.timeStep = 60,
    this.fromTitle,
    this.toTitle,
    this.titlePadding = 0,
    this.initialRange,
    this.borderColor,
    this.activeBorderColor,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.textStyle,
    this.activeTextStyle,
  })  : assert(
            lastTime.after(firstTime), 'lastTime not can be before firstTime'),
        super(key: key);

  @override
  _TimeRangeState createState() => _TimeRangeState();
}

class _TimeRangeState extends State<TimeRange> {
  TimeOfDay _startHour;
  TimeOfDay _endHour;

  @override
  void initState() {
    super.initState();
    setRange();
  }

  @override
  void didUpdateWidget(TimeRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    setRange();
  }

  void setRange() {
    if (widget.initialRange != null) {
      _startHour = widget.initialRange.start;
      _endHour = widget.initialRange.end;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.fromTitle != null)
          Padding(
            padding: EdgeInsets.only(left: widget.titlePadding),
            child: widget.fromTitle,
          ),
        SizedBox(height: 8),
        TimeList(
          firstTime: widget.firstTime,
          lastTime: widget.lastTime
              .subtract(minutes: widget.timeBlock * widget.minRange),
          initialTime: _startHour,
          timeStep: widget.timeStep,
          padding: widget.titlePadding,
          onHourSelected: _startHourChanged,
          borderColor: widget.borderColor,
          activeBorderColor: widget.activeBorderColor,
          backgroundColor: widget.backgroundColor,
          activeBackgroundColor: widget.activeBackgroundColor,
          textStyle: widget.textStyle,
          activeTextStyle: widget.activeTextStyle,
        ),
        if (widget.toTitle != null)
          Padding(
            padding: EdgeInsets.only(left: widget.titlePadding, top: 8),
            child: widget.toTitle,
          ),
        SizedBox(height: 8),
        TimeList(
          firstTime: _startHour == null
              ? widget.firstTime
                  .add(minutes: widget.timeBlock * widget.minRange)
              : _startHour.add(minutes: widget.timeBlock * widget.minRange),
          lastTime: widget.maxRange != 0
              ? _startHour == null
                  ? widget.firstTime.add(minutes: 60 * widget.maxRange)
                  : toDouble(_startHour.add(minutes: 60 * widget.maxRange)) >
                          toDouble(widget.lastTime)
                      ? widget.lastTime
                      : _startHour.add(minutes: 60 * widget.maxRange)
              : widget.lastTime,
          initialTime: _endHour,
          timeStep: widget.timeBlock,
          padding: widget.titlePadding,
          onHourSelected: _endHourChanged,
          borderColor: widget.borderColor,
          activeBorderColor: widget.activeBorderColor,
          backgroundColor: widget.backgroundColor,
          activeBackgroundColor: widget.activeBackgroundColor,
          textStyle: widget.textStyle,
          activeTextStyle: widget.activeTextStyle,
        ),
      ],
    );
  }

  void _startHourChanged(TimeOfDay hour) {
    setState(() => _startHour = hour);
    _endHour = null;
  }

  void _endHourChanged(TimeOfDay hour) {
    setState(() => _endHour = hour);
    if (_startHour != null)
      widget.onRangeCompleted(TimeRangeResult(_startHour, _endHour));
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}

class TimeRangeResult {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRangeResult(this.start, this.end);
}
