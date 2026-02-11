import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Singleton instance de FirebaseAuth pour la gestion de l'authentification
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Inscription d'un nouvel utilisateur
  Future<User?> signUp({required String email, required String password}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email : email, password : password);
      return userCredential.user;
    } catch (e) {
     throw Exception(e.toString());
    }
  }

  // Connexion d'un utilisateur existant
  Future<User?> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email : email, password : password);
      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Déconnexion d'un utilisateur
  Future<void> signOut() async{
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  // Mot de passe oublié
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email : email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  // Connexion avec Google
  Future<User?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Stream pour suivre les changements d'état de l'utilisateur
  Stream<User?> get authStateChanges => _auth.authStateChanges();
} 