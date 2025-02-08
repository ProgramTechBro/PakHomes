import 'package:flutter/material.dart';

import '../filterform.dart';

class SearchSectionWidget extends StatefulWidget {
  @override
  _SearchSectionWidgetState createState() => _SearchSectionWidgetState();
}

class _SearchSectionWidgetState extends State<SearchSectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: _searchController.text.isEmpty
                  ? Icon(Icons.search, color: Colors.grey)
                  : IconButton(
                icon: Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilterForm()),
            );
          },
        ),
      ],
    );
  }
}
