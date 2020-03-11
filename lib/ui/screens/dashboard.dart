import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_images_task/constants/constants.dart';
import 'package:flutter_images_task/enums/notofier_state.dart';
import 'package:flutter_images_task/notifiers/images_notofier.dart';
import 'package:flutter_images_task/ui/common/basic_scaffold.dart';
import 'package:flutter_images_task/ui/common/image_card.dart';
import 'package:flutter_images_task/ui/common/tab_selection.dart';
import 'package:provider/provider.dart';

class ScreenDashboard extends StatefulWidget {
  @override
  _ScreenDashboardState createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard>
    with SingleTickerProviderStateMixin {
  int _pageNo = 1;
  StreamController<String> _errorController = StreamController();
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _errorController?.close();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      appBar: AppBar(
        bottom: TabBar(
          unselectedLabelColor: Colors.white54,
          labelColor: Colors.white,
          tabs: [
            Tab(
              text: 'Color',
            ),
            new Tab(
              text: 'Grayscale',
            )
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [getBody(true), getBody(false)],
      ),
    );
  }

  Widget getBody(bool isColorful) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
        Consumer<ImagesNotifier>(
          builder: (_, notifier, __) {
            if (notifier.list.isEmpty) {
              notifier.getImages(
                _pageNo,
                (e) => _errorController.add(e.message),
              );
            }
            switch (notifier.state) {
              case NotifierState.loaded:
                return getList(notifier, isColorful);
              default:
                return _pageNo == 1
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : getList(notifier, isColorful);
            }
          },
        ),
        SliverToBoxAdapter(
          child: Consumer<ImagesNotifier>(
            builder: (_, notifier, __) {
              return Column(
                children: <Widget>[
                  SizedBox(height: 36),
                  notifier.state == NotifierState.loading
                      ? SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          color: Colors.blue,
                          child: Text('Load More'),
                          onPressed: () => notifier.getImages(
                            ++_pageNo,
                            (e) => _errorController.add(e.message),
                          ),
                        ),
                  SizedBox(height: 36)
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getList(ImagesNotifier notifier, bool isColorful) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ImageCard(
            model: notifier.list[index],
            isGrayscale: !isColorful,
          );
        },
        childCount: notifier.list.length,
      ),
    );
  }
}
