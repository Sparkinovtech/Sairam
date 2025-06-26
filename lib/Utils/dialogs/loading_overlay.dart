import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final String? text;
  const LoadingOverlay({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(text ?? ''),
        ],
      ),
    );
  }
}
