import 'dart:convert';

import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';

class ResultSearchModel extends ResultSearch {
  final String image;
  final String title;
  final String content;
  final String type;

  ResultSearchModel({this.title, this.content, this.image, this.type});

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'content': content,
      'type': type,
    };
  }

  static ResultSearchModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ResultSearchModel(
      image: map['avatar_url'],
      title: map['login'],
      content: map['url'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  static ResultSearchModel fromJson(String source) => fromMap(json.decode(source));
}
