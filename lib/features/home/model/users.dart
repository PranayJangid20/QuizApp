class Result {
  int time;
  String score;
  String actTime;

  Result({required this.time, required this.score, required this.actTime});

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      time: map['time'] as int,
      score: map['score'] as String,
      actTime: map['actTime'] as String,
    );
  }
}

