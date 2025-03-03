import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sportsmate/utils/theme.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  String _selectedMetric = 'goals';
  String _selectedPlayer = '';
  final List<String> _metrics = ['goals', 'assists', 'tackles', 'blocks'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Analytics'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('players')
                        .orderBy('name')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final players = snapshot.data!.docs;
                      if (_selectedPlayer.isEmpty && players.isNotEmpty) {
                        _selectedPlayer = players.first.id;
                      }

                      return DropdownButtonFormField<String>(
                        value: _selectedPlayer,
                        decoration: const InputDecoration(
                          labelText: 'Select Player',
                          border: OutlineInputBorder(),
                        ),
                        items: players.map((player) {
                          final data = player.data() as Map<String, dynamic>;
                          return DropdownMenuItem(
                            value: player.id,
                            child: Text(data['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPlayer = value!;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedMetric,
                    decoration: const InputDecoration(
                      labelText: 'Select Metric',
                      border: OutlineInputBorder(),
                    ),
                    items: _metrics.map((metric) {
                      return DropdownMenuItem(
                        value: metric,
                        child: Text(metric.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMetric = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedPlayer.isNotEmpty
                ? _buildPerformanceChart()
                : const Center(child: Text('Select a player to view performance')),
          ),
          const SizedBox(height: 16),
          _buildPerformanceSummary(),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('performance')
          .where('player_id', isEqualTo: _selectedPlayer)
          .orderBy('date')
          .limitToLast(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final performances = snapshot.data!.docs;
        if (performances.isEmpty) {
          return const Center(child: Text('No performance data available'));
        }

        final List<FlSpot> spots = [];
        for (var i = 0; i < performances.length; i++) {
          final data = performances[i].data() as Map<String, dynamic>;
          spots.add(FlSpot(i.toDouble(), data[_selectedMetric].toDouble()));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < performances.length) {
                        final data = performances[value.toInt()].data() as Map<String, dynamic>;
                        final date = (data['date'] as Timestamp).toDate();
                        return Text(
                          '${date.month}/${date.day}',
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppTheme.primaryColor,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceSummary() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('performance')
          .where('player_id', isEqualTo: _selectedPlayer)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final performances = snapshot.data!.docs;
        if (performances.isEmpty) {
          return const SizedBox.shrink();
        }

        // Calculate averages
        final Map<String, double> averages = {};
        for (final metric in _metrics) {
          final total = performances.fold<double>(
            0,
            (sum, perf) => sum + (perf.data() as Map<String, dynamic>)[metric],
          );
          averages[metric] = total / performances.length;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance Summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: _metrics.map((metric) {
                  return Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              metric.toUpperCase(),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              averages[metric]?.toStringAsFixed(1) ?? '0',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                            ),
                            Text(
                              'avg per game',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
