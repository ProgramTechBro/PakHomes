import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator; // Added validator field

  const CustomDropdown({
    super.key,
    required this.icon,
    required this.labelText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.validator, // Optional validator parameter
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded border radius
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      value: selectedValue,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 8),
              Text(item),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator, // Use the validator function
      iconEnabledColor: Colors.blue,
    );
  }
}
