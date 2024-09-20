import 'package:cosmoquest/ViewModel/login_viewmodel.dart';
import 'package:cosmoquest/view/Auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SocialMediaButton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Close the keyboard when tapping elsewhere
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewModel = Provider.of<LoginViewModel>(context);
              double width = constraints.maxWidth;
              double height = constraints.maxHeight;

              return Stack(
                children: [
                  // Background image
                  Container(
                    height: height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Background/account.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: width * 0.07),
                              child: SizedBox(
                                height: height * 0.2,
                                width: width * 0.4,
                                child: Image.asset('assets/images/Astronaut.png'),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            const Text(
                              "Login to your Account",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Form(
                              key: viewModel.formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: viewModel.emailController,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      errorStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    validator: viewModel.validateEmail,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  TextFormField(
                                    controller: viewModel.passwordController,
                                    obscureText: viewModel.obscureText,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          viewModel.obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.white,
                                        ),
                                        onPressed: viewModel.togglePasswordVisibility,
                                      ),
                                      errorStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    validator: viewModel.validatePassword,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Container(
                                    width: double.infinity,
                                    height: height * 0.07,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Color(0xFF545088), Color(0xFF2E23A6)],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        viewModel.loginWithEmailPassword(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.03),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30),
                                    child: Divider(height: 1, color: Colors.white),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  const Text(
                                    "Or sign in with",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SocialMediaButton(
                                        iconPath: 'assets/Icons/google.png',
                                        onPressed: () {
                                          viewModel.loginWithGoogle(context);
                                        },
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignUp(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Don’t have an account? Sign Up",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
