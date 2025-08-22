import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class HiddenRepo {

  Future<void> updateHidden({
    required String noteId,
    required bool isFavorite,
    required bool isHidden,
  });

}