class FeedModel {
  late int id;
  late String date;
  late String title;
  late String content;

  /// JSON 데이터를 FeedModel 객체로 파싱하는 생성자
  /// [json] 파싱할 JSON Map 데이터
  FeedModel.parse(Map json) {
    id = json['id'];
    date = json['date'];
    title = json['title'];
    content = json['content'];
  }
}
