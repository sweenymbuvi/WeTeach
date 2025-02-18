import 'package:flutter/material.dart';
import 'package:we_teach/presentation/shared/widgets/my_button.dart';

class BottomButtonLayout extends StatelessWidget {
  final Widget content;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const BottomButtonLayout({
    super.key,
    required this.content,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: content,
            ),
            Positioned(
              bottom: constraints.maxHeight * 0.04, // Adjustable spacing
              left: 16,
              right: 16,
              child: CustomButton(
                text: buttonText,
                onPressed: onButtonPressed,
              ),
            ),
          ],
        );
      },
    );
  }
}
