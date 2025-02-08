import 'package:flutter/material.dart';
import 'package:pakhomes/Controller/Provider/UserProviderLocalStorage.dart';
import 'package:pakhomes/Widgets/CustomTextField.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'Model/UserModel.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProviderLocalData>(context, listen: false);
      final user = userProvider.user;
      if (user != null) {
        nameController.text = user.fullName ?? "";
        userNameController.text = user.username ?? "";
        emailController.text = user.email ?? "";
        addressController.text = user.address ?? "";
        phoneController.text = user.contact ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<UserProviderLocalData>(
      builder: (context, userProvider, child) {
        UserModel? user = userProvider.user;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF007BFF),
            title: Text('Profile', style: TextStyle(color: Colors.white)),
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
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                              )
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: userProvider.selectedImage != null
                                  ? FileImage(userProvider.selectedImage!)
                                  : (user?.imageUrl == null || user?.imageUrl == "NULL")
                                  ? AssetImage("assets/images/farmer.png")
                                  : NetworkImage(user!.imageUrl!) as ImageProvider,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showImagePicker(context),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 4, color: Colors.white),
                                color: Colors.blue,
                              ),
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight*0.05),
                  CustomTextField(controller: userNameController, labelText: 'User Name', icon: Icons.person),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(controller: nameController, labelText: 'Full Name', icon: Icons.person_pin_rounded),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(controller: emailController, labelText: 'Email', icon: Icons.email),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(controller: phoneController, labelText: 'Contact', icon: Icons.phone),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextField(controller: addressController, labelText: 'Address', icon: Icons.home),
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                        child:Text('Cancel', style: TextStyle(fontSize: 16)),
                      ),
                      ElevatedButton(
                        onPressed: userProvider.isLoading
                            ? null
                            : () async {
                          userProvider.updateUserUpdatingProfile();
                          String? newImageUrl = user?.imageUrl;
                          if (userProvider.selectedImage != null) {
                            String? downloadUrl = await userProvider.uploadImageToStorage(emailController.text);
                            if (downloadUrl != null) {
                              newImageUrl = downloadUrl;
                            }
                          }
                          await userProvider.updateUserDetails(
                              user!.copyWith(
                                fullName: nameController.text,
                                username: userNameController.text,
                                email: emailController.text,
                                address: addressController.text,
                                contact: phoneController.text,
                                imageUrl: newImageUrl,
                              ),
                              context
                          );
                        },
                        style: ElevatedButton.styleFrom(
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
                        child: userProvider.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Update', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
void _showImagePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text("Take Photo"),
            onTap: () {
              Provider.of<UserProviderLocalData>(context, listen: false)
                  .pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text("Choose from Gallery"),
            onTap: () {
              Provider.of<UserProviderLocalData>(context, listen: false)
                  .pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
