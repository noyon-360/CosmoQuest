import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmoquest/Model/UserModel.dart';
import 'package:cosmoquest/Utils/apis.dart';
import 'package:cosmoquest/ViewModel/UserProfileViewModel.dart';
import 'package:cosmoquest/view/Video/video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  // final String uid; // Pass the user UID

  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProfileViewModel()..fetchUserData(Apis.user.uid.toString()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),

        ),
        body: Consumer<UserProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            UserModel? user = viewModel.userModel;
            if (user == null) {
              return const Center(child: Text("No user data found"));
            }
            return Align(
              alignment: Alignment.center,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CachedNetworkImage(
                  //   width: 80,
                  //   height: 80,
                  //   imageUrl: user.photoURL.toString(),
                  //   imageBuilder: (context, imageProvider) => Container(
                  //     width: 80,
                  //     height: 80,
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle, // Ensures the image is circular
                  //       image: DecorationImage(
                  //         image: imageProvider,
                  //         fit: BoxFit.cover, // Ensures the image covers the circle
                  //       ),
                  //     ),
                  //   ),
                  //   placeholder: (context, url) => const CircularProgressIndicator(),
                  //   errorWidget: (context, url, error) => const Icon(
                  //     Icons.person,
                  //     size: 50,
                  //   ),
                  // ),

                  InkWell(
                    onTap : () async {
                      await viewModel.pickImage(context, Apis.user.uid.toString());
                      },
                    child: CircleAvatar(
                      radius: 50,
                      child: CachedNetworkImage(
                        imageUrl: user.photoURL!,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 50,
                        ),
                      )
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? 'Anonymous',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    user.email ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  viewModel.userLevel == 0 ?
                  Text(
                    'Level: ${viewModel.userLevel + 1}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ) : Text(
                    'Level: ${viewModel.userLevel}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  TextButton(onPressed: (){
                    viewModel.logout(context);
                  }, child: const Text("SignOut")),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: (){
                    viewModel.pickVideo(context);
                  }, child: const Text("Video"))

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
