import 'package:accessability/Modele/utilisateur_modele.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  
  Utilisateur? currentUser;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();
  
  void setCurrentUser(Utilisateur user) {
    currentUser = user;
  }

  Utilisateur? getCurrentUser() {
    return currentUser;
  }
}
