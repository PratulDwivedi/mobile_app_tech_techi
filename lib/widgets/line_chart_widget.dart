import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<dynamic> data;
  final String title;

  const LineChartWidget({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(padding: const EdgeInsets.all(10), child: Text(title, style: const TextStyle( fontSize: 14)),),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (int i = 0; i < data.length; i++)
                      FlSpot(i.toDouble(), (data[i]['value'] as num).toDouble()),
                  ],
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: 1000,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: const Text('0', style: TextStyle(fontSize: 12)),
                        );
                      } else if (value % 1000 == 0) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Text('${value ~/ 1000}K', style: const TextStyle(fontSize: 12)),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx >= 0 && idx < data.length && (data[idx]['name']?.toString().isNotEmpty ?? false)) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: SizedBox(
                            width: 60,
                            child: Text(
                              data[idx]['name'].toString(),
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
            ),
          ),
        ),
      ],
    );
  }
} 