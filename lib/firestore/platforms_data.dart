import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlatformsData {
  // Save selected platforms to Firestore
  Future<void> saveSelectedPlatforms(List<String> selectedPlatforms) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs
        .getString('user_id'); // Assuming user_id is saved in SharedPreferences

    if (userId == null) {
      throw 'User ID is null';
    }

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'selectedPlatforms': selectedPlatforms,
    }, SetOptions(merge: true));
  }

  // Fetch selected platforms from Firestore
  Future<List<String>> fetchSelectedPlatforms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        throw 'User ID is null';
      }

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final selectedPlatforms = List<String>.from(userDoc.get(
          'selectedPlatforms',
        ));
        return selectedPlatforms;
      } else {
        print('User document does not exist');
        return []; // Return empty list if the document does not exist
      }
    } catch (e) {
      print('Error fetching selected platforms: $e');
      return []; // Return empty list in case of an error
    }
  }
}
