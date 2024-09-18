
import 'package:cosmoquest/view/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../ViewModel/home_viewmodel.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);
    _viewModel.initAnimation(this);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return AnimatedBuilder(
                animation: viewModel.animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: viewModel.animation.value,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/Background/home.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              double height = constraints.maxHeight;
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.1),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: height * 0.2,
                        child: const Text(
                          "Welcome To",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.2,
                        width: width * 0.4,
                        child: Image.asset('assets/images/Astronaut.png'),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        child: Text(
                          "Exoplanet Explorers",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Text(
                          "Beyond Earth Learning",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Container(
                        width: width * 0.6,
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start Exploring',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_right_alt, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
