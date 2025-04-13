import 'package:flutter/material.dart';
import 'package:paytech/paytech.dart';
import 'PaiementPage.dart';
import 'package:url_launcher/url_launcher.dart'; // Assurez-vous d'importer la page PaiementPage

class CartPage {
  String name;
  String price;
  int quantity;
  double get total => double.parse(price) * quantity;

  CartPage({
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class PanierPage extends StatefulWidget {
  final List<CartPage> cartItems;

  PanierPage({required this.cartItems});

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  // Fonction pour augmenter la quantité d'un article
  void _increaseQuantity(int index) {
    setState(() {
      widget.cartItems[index].quantity++;
    });
  }

  // Fonction pour diminuer la quantité d'un article
  void _decreaseQuantity(int index) {
    setState(() {
      if (widget.cartItems[index].quantity > 1) {
        widget.cartItems[index].quantity--;
      }
    });
  }

  // Fonction pour supprimer un article du panier
  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  // Calculer le total du panier
  double _calculateTotal() {
    double total = 0.0;
    for (var item in widget.cartItems) {
      total += item.total;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
        backgroundColor: Colors.white,
      ),
      body: widget.cartItems.isEmpty
          ? Center(child: Text('Votre panier est vide.'))
          : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(item.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prix: ${item.price} FCFA'),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decreaseQuantity(index),
                            ),
                            Text('Quantité: ${item.quantity}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _increaseQuantity(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(index),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total: ${_calculateTotal().toStringAsFixed(2)} FCFA',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logique pour passer à la page de paiement ou confirmer la commande
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Passer la commande"),
                      content: Text("Voulez-vous confirmer votre commande ?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Annuler"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Confirmer"),
                          onPressed: () async {
                            /** * Get this Url from Your backend * Your Backend must call https://paytech.sn/api/payment/request-payment to generate a payment token * Set success_url to https://paytech.sn/mobile/success * Set cancel_url to https://paytech.sn/mobile/cancel */
                            var paymentUrl =
                                "https://paytech.sn/payment/checkout/729b3e3021226cd27905";

                            bool? paymentResult = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PayTech(paymentUrl)),
                            );

                            if (paymentResult == true) {
                              print("Payment success");
                            } else {
                              print("Payment failed");
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Passer la commande'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
