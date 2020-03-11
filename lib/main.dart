import 'package:flutter/material.dart';
import 'package:flutter_images_task/deeplink/bloc.dart';
import 'package:flutter_images_task/notifiers/images_notofier.dart';
import 'package:flutter_images_task/notifiers/single_image_notifier.dart';
import 'package:provider/provider.dart';

import 'deeplink/poc.dart';

void main() => runApp(FlutterImagesTask());

class FlutterImagesTask extends StatefulWidget {
  @override
  _FlutterImagesTaskState createState() => _FlutterImagesTaskState();
}

class _FlutterImagesTaskState extends State<FlutterImagesTask> {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImagesNotifier>(create: (_) => ImagesNotifier()),
        ChangeNotifierProvider<SingleImageNotifier>(
            create: (_) => SingleImageNotifier()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        home: Scaffold(
          body: Provider<DeepLinkBloc>(
            create: (context) => _bloc,
            dispose: (context, bloc) => bloc.dispose(),
            child: PocWidget(),
          ),
        ),
      ),
    );
  }
}
