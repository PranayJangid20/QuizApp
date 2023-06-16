class Question {
  String? id;
  String? question;
  List? options;
  String? correctAnswer;
  String? explanation;
  String answer = '';

  Question(
      {this.id,
        this.question,
        this.options,
        this.correctAnswer,
        this.explanation});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    options = json['options'];
    correctAnswer = json['correctAnswer'];
    explanation = json['explanation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['options'] = this.options;
    data['correctAnswer'] = this.correctAnswer;
    data['explanation'] = this.explanation;
    return data;
  }
}
