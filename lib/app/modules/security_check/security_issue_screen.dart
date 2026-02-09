import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/models/security_check/security_check_model.dart';

class SecurityIssuesScreen extends StatelessWidget {
  final SecurityIssueType issueType;
  const SecurityIssuesScreen({super.key, required this.issueType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              Text(
                issueType.message,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                issueType.description,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Resolution: ${issueType.resolution}",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: GradientButton(
                  onPressed: () {
                    // Exit the app
                    Future.delayed(const Duration(milliseconds: 300), () {
                      SystemNavigator.pop();
                    });
                  },
                  title: "Exit App",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
