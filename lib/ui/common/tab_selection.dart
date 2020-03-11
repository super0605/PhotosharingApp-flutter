import 'package:flutter/material.dart';
import 'package:flutter_images_task/styles/styles.dart';

class TabSelection extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback callback;

  const TabSelection({Key key, this.isSelected, this.label, this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: tabSelectionDecoration(isSelected),
        child: Text(label),
      ),
    );
  }
}
