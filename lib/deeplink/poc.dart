import 'package:flutter/material.dart';
import 'package:flutter_images_task/ui/screens/dashboard.dart';
import 'package:flutter_images_task/ui/screens/image_details.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';

class PocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ScreenDashboard();
        } else {
          List<String> arr = snapshot.data.split('/');
          return ScreenImageDetails(
            id: arr[arr.length - 2],
            isGrayscale: arr[arr.length - 1] == '1',
          );
        }
      },
    );
  }
}
