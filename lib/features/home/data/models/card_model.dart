import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CardModel {
  final String? title;
  final IconData? icon;
  final Color? color;

  CardModel({this.title, this.icon, this.color});
}

List<CardModel> cardList = [
  CardModel(
    title: "All Notes",
    icon: Icons.note_add_outlined,
    color: Colors.grey,
  ),
  CardModel(
    title: "Favourites",
    icon: Icons.star_border_outlined,
    color: Colors.orangeAccent,
  ),
  CardModel(
    title: "Hidden",
    icon: CupertinoIcons.eye_slash,
    color: AppColor.primaryColor,
  ),
  CardModel(title: "Trash", icon: CupertinoIcons.delete, color: Colors.red),
];