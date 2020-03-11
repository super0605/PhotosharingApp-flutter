import 'package:flutter/material.dart';
import 'package:flutter_images_task/enums/notofier_state.dart';
import 'package:flutter_images_task/models/failure_model.dart';
import 'package:flutter_images_task/models/image_model.dart';
import 'package:flutter_images_task/services/api_serivce.dart';

class SingleImageNotifier extends ChangeNotifier {
  final _service = ApiService();
  ImageModel model;

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void getImageDetails(String id, Function(Failure) fail) async {
    await _service
        .getImageInfo(id)
        .then((res) => model = res)
        .catchError((e) => fail(e));
    _setState(NotifierState.loaded);
  }
}
