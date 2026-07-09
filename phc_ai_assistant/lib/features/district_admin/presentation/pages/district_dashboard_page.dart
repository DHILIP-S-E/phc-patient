import 'package:flutter/material.dart';
import 'package:phc_ai_assistant/core/network/api_client.dart';
import '../widgets/dynamic_sidebar.dart';

class DistrictDashboardPage extends StatefulWidget {
  const DistrictDashboardPage({super.key});

  @override
  State<DistrictDashboardPage> createState() => _DistrictDashboardPageState();
}

class _DistrictDashboardPageState extends State<DistrictDashboardPage> {
  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final data = await _apiClient.get('/district/dashboard');
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('District Command Center'),
        backgroundColor: Colors.blue[900],
      ),
      drawer: const DynamicSidebar(role: 'DISTRICT_ADMIN'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error\nMake sure the Node.js backend is running!'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'District Scope: ${_dashboardData!['district_id']}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildKpiCard('Today\'s OPD Footfall', _dashboardData!['kpis']['total_footfall'].toString(), Colors.green),
                          _buildKpiCard('Critical Stockouts', _dashboardData!['kpis']['critical_stockouts'].toString(), Colors.red),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Mocking Vertex AI Widget Integration
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          border: Border.all(color: Colors.amber),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.auto_awesome, color: Colors.amber),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Vertex AI Alert: Predicted surge in waterborne diseases in Block A. Recommending proactive dispatch of ORS from District Warehouse.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  Widget _buildKpiCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
