import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetPage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const NoInternetPage({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/J88XwoWS9U.json', height: 100), // Animation for no internet
          SizedBox(height: 20),
          Text(errorMessage),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry, // Retry button
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
