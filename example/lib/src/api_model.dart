import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApiModel {
  final String originalname;
  final String filename;
  final String location;
  ApiModel({
    required this.originalname,
    required this.filename,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'originalname': originalname,
      'filename': filename,
      'location': location,
    };
  }

  factory ApiModel.fromMap(Map<String, dynamic> map) {
    return ApiModel(
      originalname: map['originalname'] as String,
      filename: map['filename'] as String,
      location: map['location'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiModel.fromJson(String source) =>
      ApiModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
