import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  static const String baseUrl2 = 'http://192.168.1.35/senresto/api_profile.php';

  Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id'); // Récupérer l'ID utilisateur en tant qu'entier

    if (userId == null) {
      throw Exception('Utilisateur non connecté. Veuillez vous connecter d\'abord.');
    }

    final url = '$baseUrl2';

    try {
      final response = await http.get(
        Uri.parse('$url?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Erreur inconnue');
        }
      } else {
        throw Exception('Erreur de serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Échec de la connexion à l\'API: $e');
    }
  }
}
