import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pakhomes/firebase_auth_services.dart';
import 'firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
class PropertyPage extends StatelessWidget {
  final String image;
  final String propertyId;
  const PropertyPage({super.key, required this.image, required this.propertyId});

  Future<String> _getImageUrl(String path) async {
    try {
      return await FirebaseStorage.instance.ref(path).getDownloadURL();
    } catch (e) {
      debugPrint('Error fetching image URL: $e');
      return '';
    }
  }

  Future<String> _getVideoUrl(String path) async {
    try {
      return await FirebaseStorage.instance.ref(path).getDownloadURL();
    } catch (e) {
      debugPrint('Error fetching video URL: $e');
      return '';
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('properties').doc(propertyId).get(),  // Fetching based on the document ID or some unique identifier
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return const Scaffold(
                 body: Center(child: CircularProgressIndicator()),
               );
             }
             if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
               return Scaffold(
                 appBar: AppBar(title: const Text('Property Details')),
                 body: const Center(
                   child: Text('Error: Property not found.'),
                 ),
               );
             }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Property not found'));
          }
          Future<String> imageUrl = FirebaseStorage.instance
              .ref('Property_Upload/property_image.jpg') // Relative path
              .getDownloadURL();

          Future<String> videoUrl = FirebaseStorage.instance
              .ref('Property_Upload/property_video.mp4') // Relative path
              .getDownloadURL();
          //Future<String> imageUrl = FirebaseStorage.instance.refFromURL('gs://pakhomes-6a9f4.firebasestorage.app/Property_Upload').getDownloadURL();
         // Future<String> videoUrl = FirebaseStorage.instance.refFromURL('gs://pakhomes-6a9f4.firebasestorage.app/Property_Upload').getDownloadURL();
          // Retrieve property data from the Firestore document
             final property = snapshot.data!;
             final String propertyName = property['name'] ?? 'Unnamed Property';
             final String propertyDescription = property['description'] ?? 'No description available';
             final String propertyLocation = property['location'] ?? 'Location not specified';
             final double propertyPrice = property['price']?.toDouble() ?? 0.0;
             final String propertyImageUrl = property['image_url'] ??'';// 'gs://pakhomes-6a9f4.firebasestorage.app/Property_Upload';
             final String propertyVideoUrl = property['video_url'] ??'';// 'gs://pakhomes-6a9f4.firebasestorage.app/Property_Upload';
             Future<String> getImageUrl(String path) async {
               final ref = FirebaseStorage.instance.ref().child(path);
               String imageUrl = await ref.getDownloadURL();
               return imageUrl;
             }
             Future<String> getVideoUrl(String path) async {
               final ref = FirebaseStorage.instance.ref().child(path);
               String imageUrl = await ref.getDownloadURL();
               return imageUrl;
             }
             if (propertyImageUrl.isNotEmpty) {
               print('Property Image URL: $propertyImageUrl');
             }
             if (propertyVideoUrl.isNotEmpty) {
               print('Property Video URL: $propertyVideoUrl');
             }
             return Scaffold(
               body: CustomScrollView(
                 slivers: [
                   SliverAppBar(
                     expandedHeight: 400,
                     flexibleSpace: FlexibleSpaceBar(
                       background: Stack(
                         fit: StackFit.expand,
                         children: [
                           Image.network(
                             propertyImageUrl,  // Use Firestore image URL
                             fit: BoxFit.cover,
                            ),
                           Positioned(
                             bottom: 20,
                             left: 16,
                             child: Row(
                               children: [
                                 Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                   decoration: BoxDecoration(
                                       color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                                   child: Row(
                                     children: [
                                       const Icon(Icons.star, size: 16, color: Colors.amber),
                                       const SizedBox(width: 4),
                                       Text(
                                         "4.9",
                                         style: theme.textTheme.bodyMedium?.copyWith(
                                           color: Colors.white,
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                                 const SizedBox(width: 8),
                                 Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                   decoration: BoxDecoration(
                                       color: Colors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
                                   child: Row(
                                     children: [
                                       Text(
                                         "Apartment",
                                         style: theme.textTheme.bodyMedium?.copyWith(
                                           color: Colors.white,
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                     leading: IconButton(
                       onPressed: () => Navigator.pop(context),
                       icon: const Icon(Icons.arrow_back_ios_new),
                       style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                     ),
                     actions: [
                       IconButton(
                         onPressed: () {},
                         icon: const Icon(Icons.ios_share),
                         style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                       ),
                       IconButton(
                         onPressed: () {},
                         icon: Icon(
                           Icons.favorite_outlined,
                           color: theme.primaryColor,
                         ),
                         style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                       ),
                     ],
                   ),
                   SliverToBoxAdapter(
                     child: Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                               propertyName,  // Dynamically fetched name
                               style: theme.textTheme.headlineMedium?.copyWith(
                               fontWeight: FontWeight.bold,
                                 ),
                               ),
                               Icon(
                                 Icons.bookmark,
                                 color: Colors.grey[400]!,
                               )
                             ],
                           ),
                           const SizedBox(height: 8),
                           Row(
                             children: [
                               Icon(
                                 Icons.location_on,
                                 size: 20,
                                 color: Colors.deepOrangeAccent,
                               ),
                               SizedBox(width: 4),
                               Text(propertyLocation,),
                             ],
                           ),
                           const SizedBox(height: 16),
                           Text(
                             "Property Description",
                             style: theme.textTheme.labelLarge?.copyWith(
                               fontWeight: FontWeight.bold,
                               fontSize: 18,
                             ),
                           ),
                           const SizedBox(height: 8),
                           Text(
                             propertyDescription,
                             style: theme.textTheme.bodyLarge,
                           ),
                           TextButton(
                             onPressed: () {},
                             child: Row(
                               children: [
                                 Text(
                                   "Show more",
                                   style: theme.textTheme.bodyMedium?.copyWith(
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 const SizedBox(
                                   width: 8,
                                 ),
                                 const Icon(
                                   Icons.arrow_forward_rounded,
                                   size: 24,
                                   color: Colors.black,
                                 )
                               ],
                             ),
                           )
                         ],
                       ),
                     ),
                   )
                 ],
               ),
               floatingActionButton: SizedBox(
                 width: 340,
                 height: 70,
                 child: FloatingActionButton.extended(
                   onPressed: () {},
                   backgroundColor: Colors.black.withAlpha(200),
                   foregroundColor: Colors.white,
                   shape: const StadiumBorder(),
                   label: Row(
                     children: [
                       const SizedBox(width: 5),
                       Text('\$${propertyPrice.toString()}/month',
                           style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white
                           )
                       ),
                       const SizedBox(width: 12),
                       Container(
                         width: 130,
                         height: 50,
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.grey.withOpacity(0.4)
                         ),
                         child: const Row(
                           children: [
                             Icon(Icons.calendar_month_outlined),
                             SizedBox(width: 10),
                             Text("June 23 - 27")
                           ],
                         ),
                       ), const SizedBox(width: 8),
                       CircleAvatar(
                         radius: 25,
                         backgroundColor: theme.primaryColor,
                         child: const Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                       )
                     ],
                   ),
                 ),
         ),
           floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }
    );
  }
}