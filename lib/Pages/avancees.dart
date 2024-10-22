import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Avancee extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AvanceeState createState() => _AvanceeState();
}

class _AvanceeState extends State<Avancee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Metrics',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMetricCard(
                    icon: Icons.local_fire_department,
                    value: '500 Cal',
                    label: 'Calories',
                    progress: 0.4,
                    lastUpdate: '3m',
                    color: Colors.purple,
                  ),
                  _buildMetricCard(
                    icon: Icons.monitor_weight,
                    value: '58 kg',
                    label: 'Weight',
                    progress: null,
                    lastUpdate: '3m',
                    color: Colors.deepPurple,
                  ),
                  _buildMetricCard(
                    icon: Icons.local_drink,
                    value: '750 ml',
                    label: 'Water',
                    progress: null,
                    lastUpdate: '3m',
                    color: Colors.blue,
                  ),
                  _buildMetricCard(
                    icon: Icons.directions_walk,
                    value: '9,890',
                    label: 'Steps',
                    progress: 0.8,
                    lastUpdate: '22h',
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildDietInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    double? progress,
    required String lastUpdate,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 30, color: color),
              if (progress != null)
                CircularProgressIndicator(
                  value: progress,
                  color: color,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            'Last update $lastUpdate',
            style: const TextStyle(fontSize: 12, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _buildDietInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '2158 of 2850 Cal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add more calories to your diet',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressBar(label: 'Proteins', value: 0.56, color: Colors.orange),
              _buildProgressBar(label: 'Fats', value: 1.42, color: Colors.red),
              _buildProgressBar(label: 'Carbs', value: 0.9, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              width: 60,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 60 * value,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${(value * 100).toInt()}%',
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}
