import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../models/measurement.dart';

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
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 250, 250),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: _scrollGraph(),
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height * 0.5,
      ),
    );
  }

  // Scrollable widget
  Widget _scrollGraph() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        width: MediaQuery.of(context).size.height * 2,
        child: _graph(),
      ),
    );
  }

  // Graph
  Widget _graph() {
    final spots = widget.measurements
        .asMap()
        .entries
        .map((element) => FlSpot(
              element.key.toDouble(),
              element.value.valor,
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

        // Axis labels
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                final date = widget.measurements[value.toInt()].instante;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Transform.rotate(
                    angle: -math.pi / 4,
                    child: SizedBox(
                      width: 50,
                      child: Text(
                        DateFormat.yMd().add_jm().format(date),
                        style: const TextStyle(fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
