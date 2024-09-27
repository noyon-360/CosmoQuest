import 'package:firebase_auth/firebase_auth.dart';

class Apis{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user => auth.currentUser!;

  static const String _nasaApi = "bLPwyL9IDLbirQypKMcX9HcGPo1MhRIVcwBFzeRa";

  static String gptApi = "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";

  static String googleSearchApi = "AIzaSyDd1h1JIunR5rFWSAaim-0M5hKaIIxw5_A";
  static String googleSearchID = "430621287811";
}

