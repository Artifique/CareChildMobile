import 'package:accessability/Modele/enfant_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Pages/conseil_page.dart';
import 'package:accessability/Pages/conseil_parent_page.dart';
import 'package:accessability/Pages/ressources_page.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Progression extends StatefulWidget {
  final Enfant enfant;
  final Utilisateur? parent;

  // ignore: use_super_parameters
  const Progression({Key? key, required this.enfant, required this.parent}) : super(key: key);


  @override
  // ignore: library_private_types_in_public_api
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progression> {
  Utilisateur? currentUser;
   final UtilisateurService _utilisateurService = UtilisateurService();
   @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }
    void _fetchCurrentUser() async {
    Utilisateur? user = await _utilisateurService.getCurrentUtilisateur();
    if (user != null) {
      setState(() {
        currentUser = user;
        if (kDebugMode) {
          print(currentUser?.nom);
        }
      });
    }
  }
  void _navigateToConseilPage(BuildContext context) {
    String? role = currentUser?.role;

    if (role == 'PARENT') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConseilParent(enfant: widget.enfant, parent: widget.parent),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AjouterConseilPage(enfant: widget.enfant, parent: widget.parent),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildTopSection(context),
                  const SizedBox(height: 20),
                  _buildSleepHeartSection(),
                  const SizedBox(height: 20),
                  _buildWorkoutProgressSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xff0B8FAC),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('images/garcon.png'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.enfant.nom,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.enfant.typeHandicap,
                  style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(
                  context,
                  "Conseils",
                  () {
                    _navigateToConseilPage(context);
                  },
                ),
                _buildButton(
                  context,
                  "Ressources",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RessourcesPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("1350", "Point stabilité"),
                _buildStatCard("680", "Point stress"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xff0B8FAC), width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xff0B8FAC),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSleepHeartSection() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xff0B8FAC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              const Text(
                "Niveau de colère",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 65, color: Colors.red, width: 10)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 80, color: Colors.grey, width: 10)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 30, color: Colors.amber, width: 10)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 45, color: Colors.purple, width: 10)]),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Lun');
                              case 1:
                                return const Text('Mar');
                              case 2:
                                return const Text('Mer');
                              case 3:
                                return const Text('Jeu');
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutProgressSection() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Progrès de l'enfant",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black54, width: 1),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 20),
                        FlSpot(1, 40),
                        FlSpot(2, 60),
                        FlSpot(3, 80),
                        FlSpot(4, 70),
                        FlSpot(5, 90),
                        FlSpot(6, 100),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}