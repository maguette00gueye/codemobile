import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaiementPage extends StatelessWidget {
  final List<Map<String, String>> cartItems;

  PaiementPage({required this.cartItems});

  // Fonction pour procéder au paiement
  Future<void> proceedToPayment(BuildContext context) async {
    if (cartItems.isEmpty) {
      _showErrorDialog(context, 'Votre panier est vide. Veuillez ajouter des articles à votre panier.');
      return;
    }

    double totalAmount = 0.0;

    // Calculer le montant total du panier
    cartItems.forEach((item) {
      totalAmount += double.parse(item['price']!) * double.parse(item['quantity']!);
    });

    // Construction des données à envoyer à l'API
    Map<String, String> paymentData = {
      'proceedToPayment': 'true', // Indicateur de paiement
      'total_amount': totalAmount.toString(),
    };

    // URL de votre API PHP
    String apiUrl = 'http://192.168.1.35/senresto/api.php';

    try {
      // Effectuer une requête POST à l'API
      final response = await http.post(
        Uri.parse(apiUrl),
        body: paymentData,
      );

      // Vérification de la réponse de l'API
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['status'] == 'success') {
          // Redirection vers le paiement (par exemple vers une URL de paiement)
          String paymentUrl = responseBody['data']['payment_url'];

          // Afficher le lien de paiement dans une boîte de dialogue
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Paiement initié"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Veuillez procéder au paiement à l'adresse suivante :"),
                  TextButton(
                    onPressed: () async {
                      // Ouvrir l'URL de paiement dans un navigateur
                      if (await canLaunchUrl(Uri.parse(paymentUrl))) {
                        await launchUrl(Uri.parse(paymentUrl));
                      } else {
                        _showErrorDialog(context, 'Impossible d\'ouvrir l\'URL de paiement.');
                      }
                    },
                    child: Text(paymentUrl),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Fermer'),
                ),
              ],
            ),
          );
        } else {
          _showErrorDialog(context, responseBody['message']);
        }
      } else {
        _showErrorDialog(context, 'Erreur lors de la communication avec le serveur.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Une erreur s\'est produite. Veuillez réessayer.');
    }
  }

  // Fonction pour afficher les erreurs
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;

    // Calculer le total du panier
    cartItems.forEach((item) {
      totalAmount += double.parse(item['price']!) * double.parse(item['quantity']!);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Récapitulatif et Paiement'),
        backgroundColor: Colors.blueAccent,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Votre panier est vide.'))
          : Column(
        children: [
          // Afficher les articles du panier
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(item['name']!),
                    subtitle: Text('Prix: ${item['price']} | Quantité: ${item['quantity']}'),
                  ),
                );
              },
            ),
          ),
          // Afficher le montant total et le bouton de paiement
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Total : ${totalAmount.toStringAsFixed(2)} CFA', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: cartItems.isEmpty ? null : () {
                    proceedToPayment(context); // Appeler la fonction de paiement
                  },
                  child: Text('Payer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
