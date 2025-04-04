import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBVjRdv50AAPojsU98GII4xRe3FjPRiN0A",
        authDomain: "urbanservices-9e464.firebaseapp.com",
        projectId: "urbanservices-9e464",
        storageBucket: "urbanservices-9e464.appspot.com",
        messagingSenderId: "991860978031",
        appId: "1:991860978031:web:6e0987d60629c61c19b89a",
        measurementId: "G-XR73ED7WLE",
      ),
    );
  }
}
