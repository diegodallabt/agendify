import 'package:flutter/material.dart';

class AFYButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;

  const AFYButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
      ),
    );
  }
}
