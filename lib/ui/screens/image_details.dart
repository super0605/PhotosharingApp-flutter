import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_images_task/enums/notofier_state.dart';
import 'package:flutter_images_task/models/image_model.dart';
import 'package:flutter_images_task/notifiers/single_image_notifier.dart';
import 'package:flutter_images_task/ui/common/basic_scaffold.dart';
import 'package:flutter_images_task/ui/common/image_card.dart';
import 'package:provider/provider.dart';

class ScreenImageDetails extends StatefulWidget {
  final String id;
  final bool isGrayscale;

  const ScreenImageDetails({Key key, this.id, this.isGrayscale})
      : super(key: key);

  @override
  _ScreenImageDetailsState createState() => _ScreenImageDetailsState();
}

class _ScreenImageDetailsState extends State<ScreenImageDetails> {
  ImageModel model;
  StreamController<String> _errorController = StreamController();
  bool fetched = false;

  @override
  void dispose() {
    _errorController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      appBar: AppBar(title: Text('Image Details')),
      body: Consumer<SingleImageNotifier>(
        builder: (_, notifier, __) {
          if (!fetched) {
            notifier.getImageDetails(widget.id, (e) {
              _errorController.add(e.message);
            });
            fetched = true;
          }
          switch (notifier.state) {
            case NotifierState.loaded:
              return ImageCard(
                model: notifier.model,
                isGrayscale: widget.isGrayscale,
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
