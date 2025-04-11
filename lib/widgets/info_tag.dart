import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoTag extends StatelessWidget {
  final String label;
  final String value;

  const InfoTag({required this.label, required this.value, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
