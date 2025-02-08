
import 'package:flutter/material.dart';
import 'package:pakhomes/Commons/CommonFunctions.dart';
import 'package:pakhomes/Controller/Services/AddPropertyServices.dart';
import 'package:pakhomes/Model/Property.dart';
import 'package:provider/provider.dart';
import 'Controller/Provider/AddPropertyProvider.dart';
import 'Controller/Provider/FormProvider.dart';
import 'Controller/Provider/ImageHandleProvider.dart';
import 'Controller/Provider/LocationProvider.dart';
import 'LocationScreen.dart';
import 'Widgets/CustomDropdown.dart';
import 'Widgets/CustomTextField.dart';
import 'Widgets/ImagePreview.dart';
class UploadProperty extends StatefulWidget {
  const UploadProperty({super.key});

  @override
  _UploadPropertyState createState() => _UploadPropertyState();
}

class _UploadPropertyState extends State<UploadProperty> {
  AddPropertyServices services=AddPropertyServices();
  final _formKey = GlobalKey<FormState>();  // Add GlobalKey for Form validation
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _priceRangeController = TextEditingController();
  final TextEditingController _minAreaController = TextEditingController();
  bool isPropertyAdding=false;
  onPressed()async{
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      setState(() {
        isPropertyAdding=true;
      });
      final locationProvider = Provider.of<LocationProvider>(context,listen: false);
      final formProvider = Provider.of<FormProvider>(context,listen: false);
      final propertyImages = Provider.of<ImageHandlerProvider>(context,listen: false).imageFiles;
      if(propertyImages.isNotEmpty){
       await services.uploadImagesToFirebaseStorage(images: propertyImages, context: context);
       final images=Provider
           .of<AddProperty>(context,listen: false).imageUrL;
       final propertyId=Provider
           .of<AddProperty>(context,listen: false).propertyId;
       String ownerID = services.auth.currentUser!.email!;
       Property property=Property(
         propertyId: propertyId,
         propertyType:formProvider.selectedProperty,
         description: _descriptionController.text,
         city: formProvider.selectedCity,
         price:int.tryParse(_priceRangeController.text) ?? 0,
       projectTitle: _projectTitleController.text,
         areaType: formProvider.selectedAreaType,
         areaSize: _minAreaController.text,
         location: locationProvider.addressController.text,
         images: images,
         ownerId: ownerID,
         projectType: formProvider.selectedProjectType
       );
       await services.addProduct(context: context, propertyModel: property, propertyId: propertyId);
       _descriptionController.clear();
       _projectTitleController.clear();
       _priceRangeController.clear();
       _minAreaController.clear();
       formProvider.setPropertyType(null);
       formProvider.setCity(null);
       formProvider.setAreaType(null);
       formProvider.setProjectType(null);
       locationProvider.addressController.clear();
       setState(() {
         isPropertyAdding=false;
       });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final imageHandlerProvider = Provider.of<ImageHandlerProvider>(context);
    final formProvider = Provider.of<FormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF007BFF),
        title: Text('Upload Property', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Attach the form key to validate form
            child: Column(
              children: <Widget>[
                Consumer<ImageHandlerProvider>(
                  builder: (context, imageHandler, child) {
                    return GestureDetector(
                      onTap: () {
                        CommonFunctions.showPicker(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue[50],
                        ),
                        height: 150,
                        child: Center(
                          child: _buildUploadPreview(imageHandler),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Consumer<FormProvider>(
                  builder: (context, provider, child) => CustomDropdown(
                    icon: Icons.business,
                    labelText: 'Select Property Type',
                    selectedValue: provider.selectedProperty,
                    items: CommonFunctions.propertyType,
                    onChanged: (value) {
                      provider.setPropertyType(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a property type';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  icon: Icons.description,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Consumer<FormProvider>(
                  builder: (context, provider, child) => CustomDropdown(
                    icon: Icons.location_city,
                    labelText: 'Select City',
                    selectedValue: provider.selectedCity,
                    items: CommonFunctions.cities,
                    onChanged: (value) {
                      provider.setCity(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a city';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _projectTitleController,
                  labelText: 'Project Title',
                  icon: Icons.title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Consumer<FormProvider>(
                  builder: (context, provider, child) => CustomDropdown(
                    icon: Icons.category,
                    labelText: 'Select Property Type',
                    selectedValue: provider.selectedProjectType,
                    items: CommonFunctions.projectType,
                    onChanged: (value) {
                      provider.setProjectType(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a project type';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Consumer<FormProvider>(
                  builder: (context, provider, child) => CustomDropdown(
                    icon: Icons.layers,
                    labelText: 'Select Area Type',
                    selectedValue: provider.selectedAreaType,
                    items: CommonFunctions.countries,
                    onChanged: (value) {
                      provider.setAreaType(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an area type';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _minAreaController,
                  labelText: 'Area Size',
                  icon: Icons.square_foot,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the area size';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _priceRangeController,
                  labelText: 'Price',
                  icon: Icons.attach_money,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: CustomTextField(
                    controller: locationProvider.addressController,
                    labelText: 'Enter Location',
                    icon: Icons.location_on,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                    readOnly: false,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.map),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                        imageHandlerProvider.clearImageFiles();
                        _descriptionController.clear();
                        _projectTitleController.clear();
                        _priceRangeController.clear();
                        _minAreaController.clear();
                        formProvider.setPropertyType(null);
                        formProvider.setCity(null);
                        formProvider.setAreaType(null);
                        formProvider.setProjectType(null);
                        locationProvider.addressController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(130, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Text('Cancel', style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: onPressed,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(130, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: isPropertyAdding?CircularProgressIndicator(color: Colors.white,):Text('Upload', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildUploadPreview(ImageHandlerProvider imageHandler) {
  return imageHandler.imageFiles.isEmpty
      ? Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.image, size: 50, color: Color(0xFF007BFF)),
      Text(
        'Upload Images',
        style: TextStyle(color: Color(0xFF007BFF)),
      ),
    ],
  )
      : ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: imageHandler.imageFiles.length,
    itemBuilder: (context, index) {
      return ImagePreview(index: index); // Using ImagePreview here
    },
  );
}
