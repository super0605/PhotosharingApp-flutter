import 'package:flutter/material.dart';

BoxDecoration tabSelectionDecoration(bool isSelected) => BoxDecoration(
      borderRadius: BorderRadius.circular(0),
      border: Border.all(color: Colors.black54),
      color: isSelected ? Colors.blue.shade300 : Colors.transparent,
    );
