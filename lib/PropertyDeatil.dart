// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pakhomes/Model/Property.dart';
//
// import 'ChatScreen.dart';
//
// class PropertyDetailsScreen extends StatefulWidget {
//   final Property property; // Property object
//
//   const PropertyDetailsScreen({Key? key, required this.property}) : super(key: key);
//
//   @override
//   _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
// }
//
// class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
//   String ownerUid = "";
//   String ownerName = "";
//   String ownerImageUrl = "";
//
//   @override
//   void initState() {
//     super.initState();
//     fetchOwnerDetails(); // Fetch owner UID when screen loads
//   }
//
//   Future<void> fetchOwnerDetails() async {
//     String ownerEmail = widget.property.ownerId ?? '';
//
//     if (ownerEmail.isNotEmpty) {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: ownerEmail)
//           .limit(1)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         final ownerData = querySnapshot.docs.first;
//         ownerUid = ownerData.id;
//         ownerName = ownerData['fullName'] ?? 'Unknown';
//         ownerImageUrl = ownerData['imageUrl'] ?? '';
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final List<String> images = List<String>.from(widget.property.images ?? []);
//
//     return Scaffold(
//       appBar: AppBar(
//           title: Text("Property Details",style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// **Image Carousel**
//               CarouselSlider(
//                 items: images.map((image) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(image, fit: BoxFit.cover, width: double.infinity),
//                   );
//                 }).toList(),
//                 options: CarouselOptions(
//                   viewportFraction: 1.0,
//                   height: screenHeight * 0.3,
//                   autoPlay: true,
//                   enlargeCenterPage: true,
//                 ),
//               ),
//               const SizedBox(height: 8),
//
//               /// **Dots Indicator**
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(images.length, (index) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 2),
//                     width: 25,
//                     height: 2,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 16),
//
//               /// **Property Title & Price**
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     widget.property.projectTitle ?? "No Title",
//                     style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "\$${widget.property.price ?? 0}",
//                     style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.green),
//                   ),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.01),
//
//               /// **Address**
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                 child: Text(
//                   widget.property.location ?? "No Address",
//                   style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.01),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Description:",
//                       style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.05),
//                     ),
//                     SizedBox(height: screenHeight*0.005,),
//                     Text(
//                       widget.property.description ?? "No Description",
//                       style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           "ProjectType: ",
//                           style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.04),
//                         ),
//                         SizedBox(width: screenWidth*0.005,),
//                         Text(
//                           widget.property.projectType ?? "No ProjectType",
//                           style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: screenHeight * 0.01),
//                     Row(
//                       children: [
//                         Text(
//                           "City: ",
//                           style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.04),
//                         ),
//                         SizedBox(width: screenWidth*0.005,),
//                         Text(
//                           widget.property.city ?? "No City",
//                           style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: screenHeight * 0.01),
//                     Row(
//                       children: [
//                         Text(
//                           "Area Type: ",
//                           style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.04),
//                         ),
//                         SizedBox(width: screenWidth*0.005,),
//                         Text(
//                           widget.property.areaType ?? "No Area Type",
//                           style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: screenHeight * 0.01),
//                     Row(
//                       children: [
//                         Text(
//                           "Owner Email: ",
//                           style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.04),
//                         ),
//                         SizedBox(width: screenWidth*0.005,),
//                         Text(
//                           widget.property.ownerId ?? "No OwnerId",
//                           style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: screenHeight * 0.01),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildFeatureContainer(Icons.bed, "3 Beds"),
//                         _buildFeatureContainer(Icons.bathtub, "3 Baths"),
//                         _buildFeatureContainer(Icons.square_foot, widget.property.areaSize ?? '0'),
//
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               /// **Property Features**
//               SizedBox(height: screenHeight * 0.02),
//               /// **Chat with Owner Button**
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed:  ownerUid != null ? () => startChatWithOwner(ownerUid!) : null,
//                   icon: const Icon(Icons.chat,color: Colors.white,),
//                   label: const Text("Chat with Owner",style: TextStyle(color: Colors.white),),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     backgroundColor: ownerUid != null ? Colors.blue : Colors.grey, // Disable if UID not loaded
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// **Feature Container Widget**
//   Widget _buildFeatureContainer(IconData icon, String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey[400]!),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 25, color: Colors.grey[700]),
//           const SizedBox(width: 5),
//           Text(label, style: TextStyle(color: Colors.grey[700],)),
//         ],
//       ),
//     );
//   }
//
//   /// **Function to Open Chat Screen**
//   void startChatWithOwner(String ownerUid) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ChatScreen(userId: ownerUid, userName: ownerName, userImage: ownerImageUrl,)),
//     );
//   }
// }
//
//
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pakhomes/Model/Property.dart';
import 'ChatScreen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailsScreen({Key? key, required this.property}) : super(key: key);

  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  String ownerUid = "";
  String ownerName = "";
  String ownerImageUrl = "";
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchOwnerDetails();
  }

  Future<void> fetchOwnerDetails() async {
    String ownerEmail = widget.property.ownerId ?? '';

    if (ownerEmail.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: ownerEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final ownerData = querySnapshot.docs.first;
        setState(() {
          ownerUid = ownerData.id;
          ownerName = ownerData['fullName'] ?? 'Unknown';
          ownerImageUrl = ownerData['imageUrl'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final List<String> images = List<String>.from(widget.property.images ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// **Image Carousel**
              CarouselSlider(
                items: images.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(image, fit: BoxFit.cover, width: double.infinity),
                  );
                }).toList(),
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  height: screenHeight * 0.3,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),

              /// **Dots Indicator**
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 35,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              /// **Property Title & Price**
      Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.property.projectTitle ?? "No Title",
                    style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${widget.property.price ?? 0}",
                    style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),

              /// **Address**
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                child: Text(
                  widget.property.location ?? "No Address",
                  style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description:",
                      style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.05),
                    ),
                    SizedBox(height: screenHeight*0.005,),
                    Text(
                      widget.property.description ?? "No Description",
                      style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "ProjectType: ",
                          style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.04),
                        ),
                        SizedBox(width: screenWidth*0.005,),
                        Text(
                          widget.property.projectType ?? "No ProjectType",
                          style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        Text(
                          "City: ",
                          style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.04),
                        ),
                        SizedBox(width: screenWidth*0.005,),
                        Text(
                          widget.property.city ?? "No City",
                          style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        Text(
                          "Area Type: ",
                          style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.04),
                        ),
                        SizedBox(width: screenWidth*0.005,),
                        Text(
                          widget.property.areaType ?? "No Area Type",
                          style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        Text(
                          "Owner Email: ",
                          style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w600,fontSize: screenWidth*0.04),
                        ),
                        SizedBox(width: screenWidth*0.005,),
                        Text(
                          widget.property.ownerId ?? "No OwnerId",
                          style: TextStyle(color: Colors.grey[800],fontSize: screenWidth*0.04),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFeatureContainer(Icons.bed, "3 Beds"),
                        _buildFeatureContainer(Icons.bathtub, "3 Baths"),
                        _buildFeatureContainer(Icons.square_foot, widget.property.areaSize ?? '0'),

                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              /// **Chat with Owner Button**
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: ownerUid.isNotEmpty ? () => startChatWithOwner(ownerUid) : null,
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text("Chat with Owner", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: ownerUid.isNotEmpty ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureContainer(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 25, color: Colors.grey[700]),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  void startChatWithOwner(String ownerUid) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(userId: ownerUid, userName: ownerName, userImage: ownerImageUrl)),
    );
  }
}
