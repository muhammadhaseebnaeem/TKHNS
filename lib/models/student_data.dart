class StudentMarks {
  final String courseName;
  final String totalMarks;
  final String obtainedMarks;
  final String grade;

  StudentMarks({
    required this.courseName,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.grade,
  });
}

class StudentAttendance {
  final String courseName;
  final String totalLectures;
  final String attendedLectures;
  final String percentage;

  StudentAttendance({
    required this.courseName,
    required this.totalLectures,
    required this.attendedLectures,
    required this.percentage,
  });
}

class StudentData {
  final String name;
  final String rollNo;
  final List<StudentMarks> marks;
  final List<StudentAttendance> attendance;

  StudentData({
    required this.name,
    required this.rollNo,
    required this.marks,
    required this.attendance,
  });
}
