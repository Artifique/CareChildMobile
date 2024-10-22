import 'package:accessability/Modele/notification_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');

  // Créer une nouvelle notification
  Future<void> createNotification(Notification notification) async {
    try {
      await notificationCollection.doc(notification.id).set(notification.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la création de la notification : $e');
    }
  }

  // Mettre à jour une notification existante
  Future<void> updateNotification(Notification notification) async {
    try {
      await notificationCollection.doc(notification.id).update(notification.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la notification : $e');
    }
  }

  // Supprimer une notification
  Future<void> deleteNotification(String id) async {
    try {
      await notificationCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la notification : $e');
    }
  }

  // Récupérer toutes les notifications
  Future<List<Notification>> getAllNotifications() async {
    try {
      QuerySnapshot querySnapshot = await notificationCollection.get();
      return querySnapshot.docs.map((doc) => Notification.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des notifications : $e');
    }
  }

  // Récupérer une notification par ID
  Future<Notification> getNotificationById(String id) async {
    try {
      DocumentSnapshot doc = await notificationCollection.doc(id).get();
      return Notification.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la notification : $e');
    }
  }
}
