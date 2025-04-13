// CartPage.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:paytech/paytech.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class PayTechService {
  static Future<String?> generatePaymentUrl(double amount) async {
    try {
      var response = await http.post(
        Uri.parse('https://paytech.sn/api/payment/request-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'API_KEY': '9700a81b5ddda71f2b902764fbe7fd4b0fcad1e63b6614172fd6cb0cf57b7cf2',
          'API_SECRET': 'dd092fc0feed7d14e6e8b89b3eb839cd976983ca9544887608ae4fed4a38ffbf',
        },
        body: jsonEncode({
          "item_name": "Commande en ligne",
          "item_price": amount.toString(),
          "currency": "XOF",
          "ref_command": "CMD_${DateTime.now().millisecondsSinceEpoch}",
          "command_name": "Paiement CFPT Resto",
          "success_url": "https://votreapp.com/success",
          "cancel_url": "https://votreapp.com/cancel",
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['redirect_url'];
      } else {
        print("Erreur PayTech : ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception PayTech : $e");
      return null;
    }
  }
}

class CartPage extends StatefulWidget {
  final List<MenuItem> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double _calculateTotal() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += double.parse(item.price) * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Votre Panier',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueAccent.withOpacity(0.1),
              Colors.white
            ],
          ),
        ),
        child: widget.cartItems.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.blueGrey.withOpacity(0.5)
              ),
              SizedBox(height: 20),
              Text(
                  'Votre panier est vide',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w300
                  )
              ),
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ]
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: item.image.isNotEmpty
                            ? Image.network(
                          'http://192.168.1.35/senresto/src/images/${item.image}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: 60,
                          height: 60,
                          color: Colors.blueGrey.withOpacity(0.1),
                          child: Icon(Icons.image, color: Colors.blueGrey),
                        ),
                      ),
                      title: Text(
                          item.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800]
                          )
                      ),
                      subtitle: Text(
                          '${item.price} FCFA',
                          style: TextStyle(color: Colors.blueGrey)
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.blueAccent),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  setState(() {
                                    item.quantity--;
                                  });
                                }
                              },
                            ),
                            Text(
                                item.quantity.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.blueAccent),
                              onPressed: () {
                                setState(() {
                                  item.quantity++;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  widget.cartItems.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    )
                  ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total : ${_calculateTotal().toStringAsFixed(2)} FCFA',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
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
                                  double totalAmount = _calculateTotal();
                                  String? paymentUrl = await PayTechService.generatePaymentUrl(totalAmount);
                                  print(paymentUrl);
                                  if (paymentUrl != null) {
                                    await launch(paymentUrl);
                                  } else {
                                    print("Erreur lors de l'ouverture du paiement");
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Passer la commande',),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: TextStyle(fontSize: 16,
                      color: Colors.white,),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}