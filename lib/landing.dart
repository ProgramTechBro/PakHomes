import 'package:flutter/material.dart';
import 'package:pakhomes/Widgets/CategoriesList.dart';
import 'package:pakhomes/Widgets/CustomDrawer.dart';
import 'package:pakhomes/Widgets/Propertycard.dart';
import 'package:pakhomes/Widgets/SearchSection.dart';
import 'package:pakhomes/uploadproperty.dart';
import 'package:provider/provider.dart';

import 'Controller/Provider/PropertyProvider.dart';
import 'Controller/Provider/UserProviderLocalStorage.dart';
import 'Model/Property.dart';
import 'PropertyDeatil.dart';
import 'Widgets/FAB.dart';
import 'editprofile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ["Home", "Apartments", "Flats", "Plots"];
  int selectedCategoryIndex = 0;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userProvider = Provider.of<UserProviderLocalData>(context, listen: false);
      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      userProvider.loadUserFromLocal();
      propertyProvider.loadSavedProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF007BFF),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu,color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text('PakHomes',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<UserProviderLocalData>(
              builder: (context, userProvider, child) {
                final user = userProvider.user;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: (user?.imageUrl != null && user!.imageUrl != "NULL" && user.imageUrl!.isNotEmpty)
                        ? NetworkImage(user.imageUrl!)
                        : AssetImage('assets/images/farmer.png') as ImageProvider,
                    onBackgroundImageError: (_, __) {
                      debugPrint("Error loading user image");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Welcome & Search Section**
            Text("Welcome", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blue)),
            Text("Find your property", style: TextStyle(fontSize: 26, color: Colors.black,fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            SearchSectionWidget(),
            SizedBox(height: 15),
            Text("Categories", style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            CategoryList(),
            SizedBox(height: 15),
            /// **Property List Using `StreamBuilder`**
            Expanded(
              child: StreamBuilder<List<Property>>(
                stream: propertyProvider.streamProperties(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerList(screenHeight);
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No properties found",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600)));
                  }

                  List<Property> properties = snapshot.data!;

                  return ListView.builder(
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      return _buildPropertyCard(properties[index], screenHeight, screenWidth);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingAddButton(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadProperty()),
        );
      }),
    );
  }

  /// **Shimmer Effect for Loading**
  Widget _buildShimmerList(double screenHeight) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: screenHeight * 0.5,
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  /// **Property Card UI**
  Widget _buildPropertyCard(Property property, double screenHeight, double screenWidth) {
    return Container(
      //height: screenHeight * 0.6,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        //boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Property Image**
          // Stack(
          //   children: [
          //     Container(
          //       height: screenHeight * 0.3,
          //       width: double.infinity,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         image: property.images != null && property.images!.isNotEmpty
          //             ? DecorationImage(image: NetworkImage(property.images!.first), fit: BoxFit.cover)
          //             : null,
          //         color: Colors.grey[300],
          //       ),
          //     ),
          //     Positioned(
          //       right: screenWidth*0.03,
          //       bottom: screenHeight*0.02,
          //       child: Container(
          //         width: screenWidth * 0.1,
          //         height: screenWidth * 0.1,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           shape: BoxShape.circle,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.3),
          //               spreadRadius: 2,
          //               blurRadius: 4,
          //             ),
          //           ],
          //         ),
          //         child: Icon(
          //           Icons.bookmark,
          //           color: Colors.black,
          //           size: screenWidth * 0.06,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          PropertyCard(property: property, screenHeight: screenHeight, screenWidth: screenWidth),
          SizedBox(height: screenHeight*0.02),
          /// **Title & Price**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(property.projectTitle ?? "No Title", style: TextStyle(fontSize: screenWidth*0.04, fontWeight: FontWeight.bold)),
              Text("\$${property.price ?? 0}", style: TextStyle(fontSize: screenWidth*0.05, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          SizedBox(height: screenHeight*0.01),

          /// **Address**
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
            child: Text(property.location ?? "No Address", style: TextStyle(color: Colors.grey[800])),
          ),
          SizedBox(height: screenHeight*0.02),

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
          Align(
            alignment: Alignment.centerRight, // Align to the right
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsScreen(property: property),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_outward, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Feature Container**
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
