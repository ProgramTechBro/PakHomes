import 'package:flutter/material.dart';
import 'package:pakhomes/Controller/Provider/UserProvider.dart';
import 'package:pakhomes/Controller/Services/UserServices.dart';
import 'package:pakhomes/register.dart';
import 'package:provider/provider.dart';
class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();

}

class _MyLoginState extends State<MyLogin> {
  UserServices services=UserServices();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obscureText=true;
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight*0.08),
              Center(child:Image.asset('assets/images/logo.png',height: screenHeight*0.25,width: screenWidth*0.9,)),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: screenHeight*0.04),
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
              SizedBox(height: screenHeight*0.02),
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
              SizedBox(height: screenHeight*0.04),
              Consumer<UserProvider>(
                builder: (context, authProvider, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      authProvider.updateLoggingStatus();
                      await services.signIn(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text
                      );
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
                      child: authProvider.isLogging
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight*0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyRegister()),
                      );
                    },
                    child: Text(
                      "Don't have Account?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        color: Color(0xff4c505b),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implement forget password functionality
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        color: Color(0xff4c505b),
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
