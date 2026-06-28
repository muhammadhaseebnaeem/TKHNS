import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class ApiService {
  final String _baseUrl = 'https://flexstudent.nu.edu.pk';
  String? _sessionId;

  // Set the session ID (called after login)
  void setSessionId(String sessionId) {
    _sessionId = sessionId;
  }

  // Helper method to create authenticated headers
  Map<String, String> _getHeaders() {
    return {
      if (_sessionId != null) 'Cookie': 'ASP.NET_SessionId=$_sessionId',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
    };
  }

  // Example method to fetch marks
  Future<String?> fetchMarks(String semId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Student/StudentMarks?semid=20$semId'),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return response.body; // HTML string to be parsed
      }
      return null;
    } catch (e) {
      print('Error fetching marks: $e');
      return null;
    }
  }

  // Example method to fetch attendance
  Future<String?> fetchAttendance(String semId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Student/StudentAttendance?semid=20$semId'),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return response.body; // HTML string to be parsed
      }
      return null;
    } catch (e) {
      print('Error fetching attendance: $e');
      return null;
    }
  }
}
