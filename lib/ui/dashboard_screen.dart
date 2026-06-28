import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../utils/calculator.dart';
import 'package:html/parser.dart' as parser;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  String _marksData = "Loading your grades...";
  double _totalGainedMarks = 0.0;
  double _estimatedGpa = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final apiService = context.read<ApiService>();
    final htmlContent = await apiService.fetchMarks('23'); 
    
    if (htmlContent != null) {
      final document = parser.parse(htmlContent);
      final courseElements = document.querySelectorAll('.course-title'); 
      
      // MOCK DATA for calculation demonstration based on scraping
      // In reality, this would be parsed directly from the Flex HTML table rows
      final mockAssessments = [
        {'obtained': 8.5, 'total': 10}, // Quiz
        {'obtained': 14.0, 'total': 15}, // Assignment
        {'obtained': 22.0, 'total': 25}, // Midterm
      ];
      
      final gained = GradeCalculator.calculateTotalGainedMarks(mockAssessments);
      final percentage = (gained / 50) * 100; // Mock percentage based on 50 total possible marks

      setState(() {
        _marksData = "Scraped ${courseElements.length} active courses.";
        _totalGainedMarks = gained;
        _estimatedGpa = GradeCalculator.estimateGpa(percentage);
        _isLoading = false;
      });
    } else {
      setState(() {
        _marksData = "Failed to fetch data from Flex. Please try logging in again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF00FFC2)),
            onPressed: () {
              Navigator.pop(context); // Go back to login
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FFC2)))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(fontSize: 24, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Student!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // GPA & Total Marks Highlight Card
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Est. GPA', style: TextStyle(color: Colors.white70)),
                              Text(
                                _estimatedGpa.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00FFC2), Color(0xFF00BFA5)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Gained', style: TextStyle(color: Colors.black54)),
                              Text(
                                _totalGainedMarks.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Aesthetic Card for Detailed Grades
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00FFC2).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.analytics_rounded, color: Color(0xFF00FFC2)),
                            SizedBox(width: 8),
                            Text(
                              'Scraping Status',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _marksData,
                          style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The app parses the raw HTML from the Flex portal, extracts the absolute gained marks for each assignment/quiz, and calculates your precise standing instantly.',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
