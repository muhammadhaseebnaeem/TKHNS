class GradeCalculator {
  /// Calculates the total gained marks out of the total absolute marks.
  /// For example, if a student got 8/10 in Quiz 1 and 15/20 in Midterm,
  /// the total gained is 23/30.
  static double calculateTotalGainedMarks(List<Map<String, dynamic>> assessments) {
    double totalGained = 0;
    for (var assessment in assessments) {
      // Assuming assessment map has 'obtained' and 'weightage'
      double obtained = double.tryParse(assessment['obtained'].toString()) ?? 0;
      totalGained += obtained;
    }
    return totalGained;
  }

  /// Calculates the estimated GPA based on the total gained marks and standard university grading scales.
  /// This is an estimate since final curves/relative grading might apply.
  static double estimateGpa(double percentage) {
    if (percentage >= 86) return 4.00;
    if (percentage >= 82) return 3.67;
    if (percentage >= 78) return 3.33;
    if (percentage >= 74) return 3.00;
    if (percentage >= 70) return 2.67;
    if (percentage >= 66) return 2.33;
    if (percentage >= 62) return 2.00;
    if (percentage >= 58) return 1.67;
    if (percentage >= 54) return 1.33;
    if (percentage >= 50) return 1.00;
    return 0.00; // Fail
  }
}
