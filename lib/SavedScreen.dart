import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/Property.dart';
import 'Controller/Provider/PropertyProvider.dart';
import 'Widgets/Propertycard.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PropertyProvider>(context, listen: false).loadSavingProperties();
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Saved Properties",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<PropertyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingSavedProperties) {
            return _buildShimmerList(screenHeight);
          }
          final savedProperties = provider.getSavedPropertiesForCurrentUser();
          return savedProperties.isEmpty
              ? const Center(child: Text("No saved properties"))
              : ListView.builder(
            itemCount: savedProperties.length,
            itemBuilder: (context, index) {
              return _buildPropertyCard(savedProperties[index],
                  screenHeight, screenWidth, provider);
            },
          );
        },
      ),
    );
  }

  /// **Shimmer Effect for Loading**
  Widget _buildShimmerList(double screenHeight) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: screenHeight * 0.5,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  /// **Property Card with Remove (Unsave) Feature**
  Widget _buildPropertyCard(Property property, double screenHeight,
      double screenWidth, PropertyProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyCard(
              property: property,
              screenHeight: screenHeight,
              screenWidth: screenWidth),
          SizedBox(height: screenHeight * 0.02),
          /// **Title & Price**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(property.projectTitle ?? "No Title",
                  style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold)),
              Text("\$${property.price ?? 0}",
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),

          /// **Address**
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            child: Text(property.location ?? "No Address",
                style: const TextStyle(color: Colors.grey)),
          ),
          SizedBox(height: screenHeight * 0.02),

          /// **Remove (Unsave) Button**
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //     icon: const Icon(Icons.delete, color: Colors.red),
          //     onPressed: () => provider.toggleSaveProperty(context, property),
          //   ),
          // ),

          /// **Property Features**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFeatureContainer(Icons.bed, "3 Beds"),
              _buildFeatureContainer(Icons.bathtub, "3 Baths"),
              _buildFeatureContainer(Icons.square_foot, "${property.areaSize ?? '0'} sqft"),
            ],
          ),
          SizedBox(height: screenHeight*0.02),
        ],
      ),
    );
  }
  Widget _buildFeatureContainer(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          SizedBox(width: 5),
          Text(label, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
