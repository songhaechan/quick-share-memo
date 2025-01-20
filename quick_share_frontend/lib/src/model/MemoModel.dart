class MemoModel {
  late int id;
  late String title;
  late String content;

  MemoModel({
    required this.id,
    required this.title,
    required this.content,
  });

  // JSON을 MemoModel 객체로 변환하는 생성자
  MemoModel.parse(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
  }

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
