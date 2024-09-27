import 'package:cosmoquest/ViewModel/login_viewmodel.dart';
import 'package:cosmoquest/view/Auth/SocialMediaButton.dart';
import 'package:cosmoquest/view/Auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  // Conditional loading indicator
                  if (viewModel.isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),

                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      child: SingleChildScrollView(
                        child: FractionallySizedBox(
                          widthFactor: width > 600 ? 0.6 : 1, // Adjust form width
                          child: Container(
                            padding: const EdgeInsets.all(20.0),  // Padding inside the container

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: width * 0.07),
                                  child: SizedBox(
                                    // height: height * 0.4,
                                    width: width * 0.4,
                                    child: Image.asset('assets/Icons/Logo.png'),
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
                                          hintText: "Email",
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.4),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          errorStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          prefixIcon: const Icon(Icons.email),
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
                                          hintText: "Password",
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.4),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          prefixIcon: const Icon(Icons.lock),
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
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            viewModel.resetPassword(context);
                                          },
                                          child: const Text(
                                            'Forget Password?',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        height: 55,
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

                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.03),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 100.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Divider(
                                          thickness: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "or",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                SocialMediaButton(
                                  iconPath: 'assets/Icons/google.png',
                                  onPressed: () {
                                    viewModel.loginWithGoogle(context);
                                  },
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
