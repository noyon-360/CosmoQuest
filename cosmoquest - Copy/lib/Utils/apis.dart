import 'package:firebase_auth/firebase_auth.dart';

class Apis{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user => auth.currentUser!;

  static const String _nasaApi = "bLPwyL9IDLbirQypKMcX9HcGPo1MhRIVcwBFzeRa";

}

