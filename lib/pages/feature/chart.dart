import 'package:buhuiwangshi/service/matter.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 图表组件
class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 256,
      child: Padding(
        padding: EdgeInsets.fromLTRB(28, 16, 28, 0),
        child: _ChartContent(),
      ),
    );
  }
}

/// 图表内容组件
class _ChartContent extends StatelessWidget {
  const _ChartContent();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailyMatterStats>>(
      future: MatterService.getLastSevenDaysStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return LineChart(
            LineChartData(
              borderData: _buildBorderData(),
              lineBarsData: _buildLineBarsData(snapshot.data!),
              titlesData: _buildTitlesData(),
              lineTouchData: _buildLineTouchData(),
              gridData: _buildGridData(context),
              minX: 0,
              maxX: 6,
            ),
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 2,
        ),
      ),
    );
  }

  /// 构建线条数据
  List<LineChartBarData> _buildLineBarsData(List<DailyMatterStats> stats) {
    final now = DateTime.now();
    return [
      _getLineChartBarData(
        color: const Color(0xff376DF7),
        spots: stats.map((stat) {
          final daysFromNow = now.difference(stat.date).inDays;
          return FlSpot(
              6 - daysFromNow.toDouble(), stat.completedCount.toDouble());
        }).toList(),
      ),
      _getLineChartBarData(
        color: const Color(0xffFFB6F6),
        spots: stats.map((stat) {
          final daysFromNow = now.difference(stat.date).inDays;
          return FlSpot(
              6 - daysFromNow.toDouble(), stat.incompleteCount.toDouble());
        }).toList(),
      ),
    ];
  }

  // 将日期转换为对应的星期几数字（1-7，其中1代表周一，7代表周日）
  double _getWeekdayNumber(DateTime date) {
    int weekday = date.weekday;
    return weekday.toDouble();
  }

  /// 构建标题数据
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      // 底部标题
      bottomTitles: AxisTitles(
        // 图例
        axisNameWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xff376DF7), '已完成事项'),
            const SizedBox(width: 32),
            _buildLegendItem(const Color(0xffFFB6F6), '未完成事项'),
          ],
        ),
        // 侧边标题
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final now = DateTime.now();
            final date = now.subtract(Duration(days: (6 - value).toInt()));
            return Text(
              _getWeekdayFromDate(date),
              style: TextStyle(color: labelColor(), fontSize: 12),
            );
          },
          interval: 1,
        ),
      ),
      // 左侧标题
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: TextStyle(color: labelColor(), fontSize: 12),
            );
          },
        ),
      ),
      // 顶部标题（不显示）
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      // 右侧标题（不显示）
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  /// 构建触摸数据
  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            String label = spot.barIndex == 0 ? '已完成' : '未完成';
            return LineTooltipItem(
              '$label: ${spot.y.toInt()}',
              const TextStyle(color: Colors.white, fontSize: 12),
            );
          }).toList();
        },
      ),
    );
  }

  /// 构建网格数据
  FlGridData _buildGridData(BuildContext context) {
    return FlGridData(
      show: true,
      drawHorizontalLine: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: containerColor(context),
          strokeWidth: 1,
          dashArray: const [5, 10],
        );
      },
      horizontalInterval: 1,
      verticalInterval: 1,
    );
  }

  /// 构建图例项
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: labelColor(), fontSize: 12),
        ),
      ],
    );
  }

  /// 获取线条图表数据
  LineChartBarData _getLineChartBarData({
    required Color color,
    required List<FlSpot> spots,
  }) {
    return LineChartBarData(
        spots: spots,
        barWidth: 2,
        color: color,
        preventCurveOverShooting: true,
        belowBarData: BarAreaData(
          show: true,
          color: color.withOpacity(0.2),
        ),
        dotData: const FlDotData(show: false));
  }

  /// 根据日期获取星期几
  String _getWeekdayFromDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return '今天';
    }

    switch (date.weekday) {
      case 1:
        return '周一';
      case 2:
        return '周二';
      case 3:
        return '周三';
      case 4:
        return '周四';
      case 5:
        return '周五';
      case 6:
        return '周六';
      case 7:
        return '周日';
      default:
        return '';
    }
  }
}
