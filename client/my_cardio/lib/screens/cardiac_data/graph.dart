import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:graphic/graphic.dart';
//import 'package:bezier_chart/bezier_chart.dart';

import 'package:intl/intl.dart';

import '../../models/measurement.dart';

/*
class _MyData {
  final DateTime date;
  final double value;

  _MyData({
    required this.date,
    required this.value,
  });
}

List<_MyData> _generateData(int max) {
  final random = math.Random();

  return List.generate(
    31,
    (index) => _MyData(
      date: DateTime(2022, 1, index + 1),
      value: random.nextDouble() * max,
    ),
  );
}

class Graph extends StatefulWidget {
  final int datatype;
  final List<Measurement> measurements;
  const Graph({Key? key, required this.datatype, required this.measurements})
      : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  late List<_MyData> _data;

  @override
  void initState() {
    _data = _generateData(10000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: _scrollGraph(),
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height * 0.5,
      ),
    );
  }

  Widget _scrollGraph() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        width: MediaQuery.of(context).size.height * 2,
        child: _graph(),
      ),
    );
  }

  Widget _graph() {
    final spots = _data
        .asMap()
        .entries
        .map((element) => FlSpot(
              element.key.toDouble(),
              element.value.value,
            ))
        .toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            dotData: FlDotData(show: false),
            color: Colors.blue,
          ),
        ],
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                final date = _data[value.toInt()].date;

                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Transform.rotate(
                    angle: -math.pi / 4,
                    child: Text(DateFormat.MMMd().format(date)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      swapAnimationDuration: Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }
}

*/

//*

class Graph extends StatefulWidget {
  final int datatype;
  final List<Measurement> measurements;
  const Graph({Key? key, required this.datatype, required this.measurements})
      : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 350,
      height: 300,
      color: colorscheme.primary,

      // Chart
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.all(5),
          width: MediaQuery.of(context).size.height * 2,
          child: Chart(
            data: widget.measurements,
            variables: {
              'instante': Variable(
                accessor: (Measurement datum) =>
                    DateTime.parse(datum.instante.toString().substring(0, 10)),
              ),
              'valor': Variable(
                accessor: (Measurement datum) => datum.valor,
              ),
            },
            elements: [
              LineElement(
                  shape: ShapeAttr(value: BasicLineShape(smooth: false)))
            ],
            coord: RectCoord(color: colorscheme.onPrimary),
            axes: [
              Defaults.horizontalAxis,
              Defaults.verticalAxis,
            ],
            selections: {
              'touchMove': PointSelection(
                on: {
                  GestureType.scaleUpdate,
                  GestureType.tapDown,
                  GestureType.longPressMoveUpdate
                },
                dim: Dim.x,
              )
            },
            tooltip: TooltipGuide(
              followPointer: [false, true],
              align: Alignment.topLeft,
              offset: const Offset(-20, -20),
            ),
            crosshair: CrosshairGuide(followPointer: [false, true]),
          ),
        ),
      ),
    );
  }
}

//*/
