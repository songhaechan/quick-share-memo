class MemoModel {
  late int id;
  late String title;
  late String content;
  late int userId;

  MemoModel(
      {required this.id,
      required this.title,
      required this.content,
      required this.userId});

  // JSON을 MemoModel 객체로 변환하는 생성자
  MemoModel.parse(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    userId = json['userId'];
  }

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'content': content, 'userId': userId};
  }
}
