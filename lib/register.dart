
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Controller/Provider/UserProvider.dart';
import 'Controller/Services/UserServices.dart';
import 'login.dart';
class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  UserServices services=UserServices();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();
  bool obscureText=true;
  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child:Image.asset('assets/images/logo.png',height: screenHeight*0.25,width: screenWidth*0.9,)),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: screenHeight*0.02),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: screenHeight*0.015),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                      Icons.person_outline, color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: screenHeight*0.015),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: screenHeight*0.015),
              TextField(
                controller: _passwordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.015),
              TextField(
                controller: _contactNumberController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Contact Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.phone, color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: screenHeight*0.015),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.home, color: Colors.blue.shade700),
                ),
              ),
              SizedBox(height: screenHeight*0.04),
              Consumer<UserProvider>(builder: (context,authProvider,child){
                return ElevatedButton(
                  onPressed: ()async{
                    authProvider.updateRegisteringStatus();
                    await services.createUser(context: context, userName: _usernameController.text, fullName: _fullNameController.text, email: _emailController.text, password: _passwordController.text, contactNo: _contactNumberController.text, address: _addressController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007BFF),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Center(
                    child: authProvider.isRegistering?CircularProgressIndicator(color: Colors.white,):Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: screenHeight*0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyLogin()),
                        );
                      },
                      child: Text(
                        'Already Have Account?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Color(0xff4c505b),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

