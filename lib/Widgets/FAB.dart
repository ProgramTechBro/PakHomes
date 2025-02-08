import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: Color(0xFF007BFF),
      icon: Icon(Icons.add, color: Colors.white, size: 28),
      label: Text(
        "Add Property",
        style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w600),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6, // Adds depth effect
    );
  }
}
