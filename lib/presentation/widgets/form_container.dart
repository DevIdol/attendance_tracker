import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget submitButton;
  final Widget? footer;

  const FormContainer({
    super.key,
    required this.title,
    required this.children,
    required this.submitButton,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  ...children,
                  const SizedBox(height: 24),
                  submitButton,
                  if (footer != null) ...[
                    const SizedBox(height: 16),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
