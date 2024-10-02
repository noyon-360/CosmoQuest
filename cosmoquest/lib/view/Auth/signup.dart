import 'package:cosmoquest/ViewModel/SignUpViewModel.dart';
import 'package:cosmoquest/view/Map%20Containers/container_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'SocialMediaButton.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // final _formKey = GlobalKey<FormState>();
  // final TextEditingController _passwordController = TextEditingController();
  // bool _obscureText = true;
  // bool _confirmObscureText = true;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(
          builder: (context, constraints){
            final viewModel = Provider.of<SignUpViewModel>(context);
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            return Stack(
              children: [
                // Background Image and Overlay
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
                // Form Fields and Sign Up Logic
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: SingleChildScrollView(
                      child: FractionallySizedBox(
                        widthFactor: width > 600 ? 0.6 : 1,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Astronaut Image
                              Padding(
                                padding: EdgeInsets.only(top: width * 0.07),
                                child: SizedBox(
                                  // height: height * 0.2,
                                  width: width * 0.4,
                                  child: Image.asset('assets/Icons/Logo.png'),
                                ),
                              ),
                               SizedBox(height: height * 0.02),
                              const Text(
                                "Create Your Account",
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
                                    // Email Field
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
                                        errorStyle: const TextStyle(color: Colors.white),
                                        prefixIcon: const Icon(Icons.email)
                                      ),
                                      validator: viewModel.validateEmail,
                                      // validator: (value) {
                                      //   if (value == null || value.isEmpty) {
                                      //     return "Please enter your email";
                                      //   } else if (!EmailValidator.validate(value)) {
                                      //     return "Please enter a valid email";
                                      //   }
                                      //   return null;
                                      // },
                                      // onChanged: (value) {
                                      //   viewModel.email = value;
                                      // },
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),

                                    // Password Field
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
                                            viewModel.obscureText ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.white,
                                          ),
                                          onPressed: viewModel.togglePasswordVisibility
                                          //     () {
                                          //
                                          //   // setState(() {
                                          //   //   _obscureText = !_obscureText;
                                          //   // });
                                          // },
                                        ),
                                        errorStyle: const TextStyle(color: Colors.white),
                                      ),
                                      validator: viewModel.validatePassword,
                                      //     (value) {
                                      //   if (value == null || value.isEmpty) {
                                      //     return "Please enter your password";
                                      //   } else if (value.length < 6) {
                                      //     return "Password must be at least 6 characters";
                                      //   }
                                      //   return null;
                                      // },
                                      // onChanged: (value) {
                                      //   viewModel.password = value;
                                      // },
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 20),

                                    // Confirm Password Field
                                    TextFormField(
                                      controller: viewModel.confirmPasswordController,
                                      obscureText: viewModel.confirmObscureText,
                                      decoration: InputDecoration(
                                        hintText: "Confirm Password",
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.4),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            viewModel.confirmObscureText ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.white,
                                          ),
                                          onPressed: viewModel.toggleConfirmPasswordVisibility,
                                              // () {
                                            // setState(() {
                                            //   _confirmObscureText = !_confirmObscureText;
                                            // });
                                          // },
                                        ),
                                        errorStyle: const TextStyle(color: Colors.white),
                                      ),
                                      validator: viewModel.validateConfirmPassword,

                                      //     (value) {
                                      //   if (value == null || value.isEmpty) {
                                      //     return "Please confirm your password";
                                      //   } else if (value != _passwordController.text) {
                                      //     return "Passwords do not match";
                                      //   }
                                      //   return null;
                                      // },
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 22),

                                    // Sign Up Button
                                    Container(
                                      width: double.infinity,
                                      height: 58,
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
                                          if (viewModel.formKey.currentState!.validate()) {
                                            viewModel.signUpWithEmailAndPassword(context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),

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

                                    // Social Media Sign In Options
                                    // const Text(
                                    //   "Or sign up with",
                                    //   style: TextStyle(
                                    //     fontSize: 18,
                                    //     color: Colors.white,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    SizedBox(height: height * 0.02),
                                    SocialMediaButton(
                                      iconPath: 'assets/Icons/google.png',
                                      onPressed: () {
                                        viewModel.signInWithGoogle(context);
                                      },
                                    ),
                                    SizedBox(width: height * 0.02),
                                    // const SizedBox(height: 20),

                                    // Already have an account? Login
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Already have an account? Sign In",
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
                  ),
                ),
              ],
            );
          },

        ),
      ),
    );
  }
}
