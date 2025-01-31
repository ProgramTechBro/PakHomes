import 'package:flutter/material.dart';
import 'package:pakhomes/uploadproperty.dart';

import 'editprofile.dart';
class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}):super(key: key);
  @override
  State<LandingPage> createState() => _LandingPageState();
}
class _LandingPageState extends State<LandingPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF007BFF),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu,color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Correctly uses the local context
              },
            );
          },
        ),
        title: Text('PakHomes',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to profile page or show user info
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
                // Navigate to editprofile page
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage("gs://pakhomes-6a9f4.firebasestorage.app/user_profile_pictures"),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Header Section
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Options
            ListTile(
              leading: Icon(Icons.message, color: Colors.blue),
              title: Text('Message'),
              onTap: () {
                // Define what happens on tap
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.orange),
              title: Text('History'),
              onTap: () {
                // Define what happens on tap
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {
                // Define what happens on tap
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                              : null,
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
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      // Define the action when the filter icon is pressed
                      Navigator.pushNamed(context, 'filterform');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: 10, // or the length of your property list
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: PropertyCard(
                      onTap: () {
                        // Action when tapping on a specific property
                        Navigator.pushNamed(
                            context, 'property_page');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadProperty()),
            );
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          icon: Icon(Icons.upload),
          label: Text("Upload Property"),
        )
    );
  }
}
class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xff48e256),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text("Active"),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_outlined,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc6c8f3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.link_outlined,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc6c8f3),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "\$250,000",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Green Field Island, Western \nByepass",
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      const Icon(Icons.bookmark_outline),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.deepOrangeAccent,
                        size: 18,
                      ),
                      Text(
                        "Off sixway roundabout, byepass (5.1KM)",
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(
                        Icons.king_bed_outlined,
                      ),
                      SizedBox(width: 4),
                      Text("3 bedrooms"),
                      SizedBox(width: 16),
                      Icon(Icons.bathtub),
                      SizedBox(width: 4),
                      Text("2 baths"),
                      SizedBox(width: 16),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}