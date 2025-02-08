// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Model/Property.dart';
// import '../Controller/Provider/PropertyProvider.dart';
//
// class PropertyCard extends StatelessWidget {
//   final Property property;
//   final double screenHeight;
//   final double screenWidth;
//
//   const PropertyCard({
//     Key? key,
//     required this.property,
//     required this.screenHeight,
//     required this.screenWidth,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PropertyProvider>(
//       builder: (context, provider, child) {
//         return Stack(
//           children: [
//             Container(
//               height: screenHeight * 0.3,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: property.images != null && property.images!.isNotEmpty
//                     ? DecorationImage(image: NetworkImage(property.images!.first), fit: BoxFit.cover)
//                     : null,
//                 color: Colors.grey[300],
//               ),
//             ),
//             Positioned(
//               right: screenWidth * 0.03,
//               bottom: screenHeight * 0.02,
//               child: GestureDetector(
//                 onTap: () => provider.toggleSaveProperty(context,property),
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
//                   child: Container(
//                     key: ValueKey<bool>(
//                         provider.savedProperties[provider.auth.currentUser!.uid]?.any((p) => p.propertyId == property.propertyId) ?? false),
//                     width: screenWidth * 0.1,
//                     height: screenWidth * 0.1,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 4,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       provider.savedProperties[provider.auth.currentUser!.uid]
//                           ?.any((p) => p.propertyId == property.propertyId) ??
//                           false
//                           ? Icons.bookmark
//                           : Icons.bookmark_border,
//                       color: provider.savedProperties[provider.auth.currentUser!.uid]
//                           ?.any((p) => p.propertyId == property.propertyId) ??
//                           false
//                           ? Colors.blue
//                           : Colors.black,
//                       size: screenWidth * 0.06,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/Property.dart';
import '../Controller/Provider/PropertyProvider.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final double screenHeight;
  final double screenWidth;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PropertyProvider>(context, listen: false);

    return Stack(
      children: [
        Container(
          height: screenHeight * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: property.images != null && property.images!.isNotEmpty
                ? DecorationImage(image: NetworkImage(property.images!.first), fit: BoxFit.cover)
                : null,
            color: Colors.grey[300],
          ),
        ),
        Positioned(
          right: screenWidth * 0.03,
          bottom: screenHeight * 0.02,
          child: Selector<PropertyProvider, bool>(
            selector: (context, provider) {
              return provider.savedProperties[provider.auth.currentUser?.uid]
                  ?.any((p) => p.propertyId == property.propertyId) ??
                  false;
            },
            builder: (context, isSaved, child) {
              return GestureDetector(
                onTap: () => provider.toggleSaveProperty(context, property),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: Container(
                    key: ValueKey<bool>(isSaved),
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? Colors.blue : Colors.black,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
