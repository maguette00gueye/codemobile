import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MenuItem.dart'; // Assurez-vous que ce fichier existe avec la classe MenuItem

class MenuService {
  static const String apiUrl = 'http://localhost/mydashboard/senresto/api.php';

  // Récupérer tous les menus
  static Future<List<MenuItem>> fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?action=view_menu'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success' && responseData.containsKey('data')) {
          List<dynamic> data = responseData['data'];
          return data.map((item) => MenuItem.fromJson(item)).toList();
        } else {
          throw Exception('Format de réponse invalide: ${response.body}');
        }
      } else {
        throw Exception('Échec de chargement des menus: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération des menus: $e');
      // Retourner une liste vide en cas d'erreur
      return [];
    }
  }

  // Récupérer les menus filtrés par type de repas et catégorie
  static Future<List<MenuItem>> fetchFilteredMenuItems(String mealType, String category) async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl?action=view_menu&meal_type=$mealType&category=$category')
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success' && responseData.containsKey('data')) {
          List<dynamic> data = responseData['data'];
          return data.map((item) => MenuItem.fromJson(item)).toList();
        } else {
          throw Exception('Format de réponse invalide: ${response.body}');
        }
      } else {
        throw Exception('Échec de chargement des menus: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération des menus filtrés: $e');
      // Retourner une liste vide en cas d'erreur
      return [];
    }
  }

  // Ajouter un article au panier
  static Future<bool> addToCart(String itemId, String itemName, double itemPrice, int itemQuantity) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'add_to_cart': '1',
          'item_id': itemId,
          'item_name': itemName,
          'item_price': itemPrice.toString(),
          'item_quantity': itemQuantity.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['status'] == 'success';
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout au panier: $e');
      return false;
    }
  }

  // Rechercher des menus
  static Future<List<MenuItem>> searchMenuItems(String query) async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl?action=search_menu&query=$query')
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success' && responseData.containsKey('data')) {
          List<dynamic> data = responseData['data'];
          return data.map((item) => MenuItem.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Erreur lors de la recherche de menus: $e');
      return [];
    }
  }
}