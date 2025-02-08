import 'package:flutter/material.dart';
import 'package:pakhomes/Controller/Provider/UserProviderLocalStorage.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories = ["Home", "Apartments", "Flats", "Plots"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Consumer<UserProviderLocalData>(
        builder: (context, categoryProvider, child) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  categoryProvider.setSelectedCategory(index);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: categoryProvider.selectedCategoryIndex == index
                        ? Colors.blue
                        : Color(0xFFECECEC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: categoryProvider.selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
