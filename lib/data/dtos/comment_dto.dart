import '../../model/comment/comment.dart';

class CommentDto {
  static const String textKey = 'text';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    assert(json[textKey] is String);
    return Comment(id: id, text: json[textKey]);
  }

  static Map<String, dynamic> toJson(String text) {
    return {textKey: text};
  }
}