import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final String id;
  final String imageUrl;
  final String fillStatus;
  final int isFull;
  final int isOpen;
  bool clicked = false;

  ImageModel(this.id, this.imageUrl, this.fillStatus, this.isFull, this.isOpen,
      {this.clicked});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'fillStatus': fillStatus,
      'isFull': isFull,
      'isOpen': isOpen,
    };
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      map['id'].toString(),
      map['url'],
      map['fill_status'],
      map['is_full'],
      map['is_lid_open'],
      clicked: false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageModel.fromJson(String source) =>
      ImageModel.fromMap(json.decode(source));

  static ImageModel fromSnapshot(DocumentSnapshot snap) {
    return ImageModel(
      snap['id'],
      snap['imageUrl'],
      snap['fillStatus'],
      snap['isFull'],
      snap['isOpen'],
      clicked: false,
    );
  }

  @override
  List<Object> get props => [id, imageUrl, fillStatus, isFull, isOpen, clicked];
}
