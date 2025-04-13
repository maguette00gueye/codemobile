import 'dart:convert';
import 'package:escoa1/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CartPage.dart'; // Assurez-vous que ce fichier existe
import 'RestaurantDetailScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_outlined,
                      color: Colors.blueAccent,
                      size: 150,
                    ),

                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'SENRESTO_ESCOA',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// API Service Class
class ApiService {
  static const String baseUrl = 'http://192.168.1.35/senresto/api.php';
  static const String baseUrl1 = 'http://192.168.1.35/senresto/api_register.php';
  static const String baseUrl2 = 'http://192.168.1.35/senresto/api_profile.php';

  // Connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl1),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'login': '',
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec de connexion');
    }
  }

  // Inscription
  Future<Map<String, dynamic>> register(
      String name, String prenom, String email, String password, String phone, String role,String type, String address) async {
    final response = await http.post(
      Uri.parse(baseUrl1),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'register': '',
        'name': name,
        'firstname': prenom,
        'email': email,
        'password': password,
        'phone': phone,
        'role_id': role,
        'type_utilisateur': 'caissier',
        'address': address

      },
    );
    print (response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec d\'inscription');
    }
  }
}

// Classe pour les éléments de menu
class MenuItem {
  final String id;
  final String name;
  final String description;
  final String price;
  final String image;
  int quantity; // Ajout de la quantité

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.quantity = 1, // Initialisation de la quantité à 1
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      price: json['price'].toString(),
      image: json['image'],
      quantity: 1, // Initialisation de la quantité par défaut à 1
    );
  }
}
// Classe pour les éléments user
class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String? telephone;
  final String? adresse;
  final int roleId;
  final String typeUtilisateur;
  final String createdAt;
  final String? derniereConnexion;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    this.adresse,
    required this.roleId,
    required this.typeUtilisateur,
    required this.createdAt,
    this.derniereConnexion,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      nom: json['nom'] ?? '',
      prenom: json['firstname'] ?? '',
      email: json['email'] ?? '',
      telephone: json['phone'],
      adresse: json['adresse'],
      roleId: json['role_id'] is String ? int.parse(json['role_id']) : json['role_id'],
      typeUtilisateur: json['type_utilisateur'] ?? '',
      createdAt: json['created_at'] ?? '',
      derniereConnexion: json['derniere_connexion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'firstname': prenom,
      'email': email,
      'phone': telephone,
      'adresse': adresse,
      'role_id': roleId,
      'type_utilisateur': typeUtilisateur,
      'created_at': createdAt,
      'derniere_connexion': derniereConnexion,
    };
  }
}
// Fonction pour récupérer les menus depuis l'API
Future<List<MenuItem>> fetchMenus(String category) async {
  final response = await http.get(Uri.parse('http://192.168.1.35/senresto/api.php?action=$category'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['data'];
    return data.map((item) => MenuItem.fromJson(item)).toList();
  } else {
    throw Exception('Échec du chargement des menus');
  }
}

// Main application
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENRESTO_ESCOA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3F51B5), // Indigo plus vibrant
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5),
          primary: const Color(0xFF3F51B5),
          secondary: const Color(0xFFFF9800), // Orange pour contraste
          surface: Colors.white,
          background: const Color(0xFFF5F5F5),
          error: const Color(0xFFE53935),
        ),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9800),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late Future<List<MenuItem>> futureMenus;
  late TabController _tabController;
  List<MenuItem> cartItems = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    futureMenus = fetchMenus("view_menu");
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        if (_tabController.index == 0) {
          futureMenus = fetchMenus("view_menu");
        } else if (_tabController.index == 1) {
          futureMenus = fetchMenus("view_fast_food");
        } else if (_tabController.index == 2) {
          futureMenus = fetchMenus("view_menu_drinks");
        }
      });
    }
  }

  void _addToCart(MenuItem item) {
    setState(() {
      bool found = false;
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i].id == item.id) {
          cartItems[i].quantity += 1;
          found = true;
          break;
        }
      }
      if (!found) {
        cartItems.add(item);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${item.name} ajouté au panier',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF3F51B5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }
  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: cartItems),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'SENRESTO_ESCOA',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/img_2.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),

                    ],
                  ),
                ),
              ),
              // Éléments du menu
              ListTile(
                leading: const Icon(Icons.home, color: Color(0xFF3F51B5)),
                title: const Text('Accueil'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Color(0xFF3F51B5)),
                title: const Text('Panier'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cartItems: cartItems),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_rounded, color: Color(0xFF3F51B5)),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFF3F51B5)),
                title: const Text('Favoris'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history_edu_rounded, color: Color(0xFF3F51B5)),
                title: const Text('Mes commandes'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderHistoryPage(userId: '',)),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info, color: Color(0xFF3F51B5)),
                title: const Text('À propos'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined, color: Color(0xFF3F51B5)),
                title: const Text('Deconnexion'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFF3F51B5)),
                title: const Text('Paramètres'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3F51B5).withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Bienvenue chez SENRESTO_ESCOA',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Découvrez nos délicieux plats prêts à vous régaler!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'DE QUOI AVEZ-VOUS ENVIE?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
              //_buildFoodCategorySection(),
              const SizedBox(height: 16),
              FutureBuilder<List<MenuItem>>(
              future: futureMenus,
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucun menu disponible'));
              } else {
              return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return _buildMenuItemCard(item);
              },
              );
              }
              },
              ),
              ],
              ),
              ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;

            // Redirection vers RestaurantDetailScreen pour l'index de la boutique
            if (index == 1) {  // En supposant que 0 est l'index pour la boutique
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RestaurantDetailScreen()),
              );
            } else if (index == 2) {
              _navigateToCart();
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            } else {
              // Synchroniser le contrôleur d'onglets avec l'index de navigation pour les autres onglets
              _tabController.animateTo(index);
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3F51B5),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        elevation: 8,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_sharp),
            label: 'Boutique',

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Compte',
          ),
        ],
      ),
    );
  }




  Widget _buildFoodCategorySection() {
    return SizedBox(
      height: 280,
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // Redirection vers la page view_menu
                setState(() {
                  futureMenus = fetchMenus("view_menu");
                  _tabController.animateTo(0); // Activer le premier onglet
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('data:image/jpeg;base64,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'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        "MENU DU JOUR(3)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: InkWell(
              onTap: () {
              setState(() {
              futureMenus = fetchMenus("view_fast_food");
              _tabController.animateTo(1); // Activer le deuxième onglet
              });
              },

              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM8v0Oprl4El5HWvG--fyV5nFGZ97IQErIyA&s'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(25),
              ),
                child: const Text(
                   "FAST FOOD (12)",
                     style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 14,
              ),
            ),
          ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                futureMenus = fetchMenus("view_menu_drinks");
                _tabController.animateTo(2); // Activer le troisième onglet
                });
                },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('data:image/jpeg;base64,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'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        "A BOIRE(15)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildMenuItemCard(MenuItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuItemDetailPage(item: item, onAddToCart: _addToCart),
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.price}FCFA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image.network(
                item.image.isNotEmpty
                ? item.image
                    : 'http://192.168.1.35/senresto/src/images/${item.image}',
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Menu Item Detail Page
class MenuItemDetailPage extends StatefulWidget {
  final MenuItem item;
  final Function(MenuItem) onAddToCart;

  const MenuItemDetailPage({
    Key? key,
    required this.item,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _MenuItemDetailPageState createState() => _MenuItemDetailPageState();
}

class _MenuItemDetailPageState extends State<MenuItemDetailPage> {
  int quantity = 1;
  String selectedSauce = 'SANS SAUCES';

  @override
  Widget build(BuildContext context) {
    // Palette de couleurs améliorée
    final primaryColor = Color(0xFF3F51B5); // Vert riche
    final secondaryColor = Color(0xFFFFC107); // Ambre/Or
    final backgroundColor = Color(0xFFF5F5F5); // Gris très clair
    final textDarkColor = Color(0xFF263238); // Bleu gris foncé
    final accentColor = Color(0xFFE8F5E9); // Vert pâle

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('SENRESTO_ESCOA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            )),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [


                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          backgroundColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${widget.item.price}FCFA',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Titre de section
                  Text(
                    'Quantité',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textDarkColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            backgroundColor: quantity > 1 ? primaryColor.withOpacity(0.8) : Colors.grey[300],
                            foregroundColor: quantity > 1 ? Colors.white : Colors.black54,
                            elevation: 0,
                          ),
                          child: const Icon(Icons.remove, size: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '$quantity',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textDarkColor,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            final customizedItem = MenuItem(
              id: widget.item.id,
              name: widget.item.name,
              description: '${widget.item.description} - Sauce: $selectedSauce',
              price: widget.item.price,
              image: widget.item.image,
              quantity: quantity,
            );
            widget.onAddToCart(customizedItem);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined),
              SizedBox(width: 12),
              Text(
                'Ajouter au panier - ${(double.parse(widget.item.price) * quantity).toStringAsFixed(2)}FCFA',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }

// Cart Page



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
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.1),
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
                      color: Colors.blue.shade900,
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
                              icon: Icon(Icons.remove, color:  Colors.blue.shade900),
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
                              icon: Icon(Icons.add, color:  Colors.blue.shade900),
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
                      color:  Colors.blue.shade900.withOpacity(0.2),
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
                      color: Colors.blue.shade900,
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
                                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                                  Navigator.of(context).maybePop(); // Revient à la page précédente si possible
                                },
                              ),
                              TextButton(
                                child: Text("Confirmer"),
                                onPressed: () async {
                                  double totalAmount = _calculateTotal();
                                  String? paymentUrl = await PayTechService.generatePaymentUrl(totalAmount);
                                  print(paymentUrl);
                                  if (paymentUrl != null) {
                                    await (paymentUrl);
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
                      backgroundColor:Colors.blue.shade900,
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      textStyle: TextStyle(fontSize: 14,
                        color: Colors.white),
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

// Checkout Page


// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<MenuItem> searchResults = [];
  bool isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      // This is a simplified example - in a real app, you would call an API
      // Here we're just getting all menu items and filtering them
      List<MenuItem> allMenuItems = [];

      // Fetch from all categories
      var menuItems = await fetchMenus("view_menu");
      var fastFoodItems = await fetchMenus("view_fast_food");
      var drinkItems = await fetchMenus("view_menu_drinks");

      allMenuItems.addAll(menuItems);
      allMenuItems.addAll(fastFoodItems);
      allMenuItems.addAll(drinkItems);

      // Filter based on search query
      setState(() {
        searchResults = allMenuItems.where((item) {
          return item.name.toLowerCase().contains(query.toLowerCase()) ||
              item.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Rechercher...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          autofocus: true,
          onChanged: (value) {
            if (value.length >= 2) {
              _performSearch(value);
            } else if (value.isEmpty) {
              setState(() {
                searchResults = [];
              });
            }
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                searchResults = [];
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearching)
            const LinearProgressIndicator(
              backgroundColor: Colors.white,
            ),
          Expanded(
            child: searchResults.isEmpty
                ? Center(
              child: _searchController.text.isEmpty
                  ? const Text('Commencez à taper pour rechercher')
                  : const Text('Aucun résultat trouvé'),
            )
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final item = searchResults[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.image.isNotEmpty
                            ? item.image
                            :'http://192.168.1.35/senresto/src/images/${item.image}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${item.price}FCFA',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuItemDetailPage(
                            item: item,
                            onAddToCart: (item) {
                              // Implement add to cart functionality
                              // You'll need to access the cart state from here
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

// Edit Profile Page
class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _firstNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.nom);
    _firstNameController = TextEditingController(text: widget.user.prenom);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.telephone ?? '');
    _addressController = TextEditingController(text: widget.user.adresse ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // In a real app, you would call your API service here
        // final apiService = ApiService();
        // await apiService.updateProfile(...);

        // Pop loading indicator
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profil mis à jour avec succès'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );

        // Return to profile page
        Navigator.pop(context);
      } catch (e) {
        // Pop loading indicator
        Navigator.pop(context);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon profil'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.location_on),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text(
                      'Enregistrer les modifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent.withOpacity(0.1), Colors.white],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, opacity, child) => Opacity(
                    opacity: opacity as double,
                    child: Transform.translate(
                      offset: Offset(0, (1 - opacity) * 20),
                      child: child,
                    ),
                  ),
                  child: Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Connectez-vous à votre compte',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32),
                _buildEmailField(),
                SizedBox(height: 16),
                _buildPasswordField(),
                SizedBox(height: 24),
                _buildLoginButton(),
                SizedBox(height: 16),
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email_outlined, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Mot de passe',
          prefixIcon: Icon(Icons.lock_outline, color: Colors.blueAccent),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        obscureText: _obscurePassword,
      ),
    );
  }

  Widget _buildLoginButton() {
    return _isLoading
        ? Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ),
    )
        : ElevatedButton(
      onPressed: _login,
      child: Text(
        'Se connecter',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterPage(),
            ),
          );
        },
        child: Text(
          'Pas de compte ? Inscrivez-vous',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (result['status'] == 'success') {
        final userId = result['data']['user_id'];

        // Vérification si l'ID utilisateur est un entier et stockage
        if (userId is int) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', userId);  // Stockage de l'ID utilisateur comme entier
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Échec de connexion'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de connexion: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  final _typeController = TextEditingController();
  final _addressController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // Soft background color
      appBar: AppBar(
        title: Text('Inscription',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Créer un compte',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Renseignez vos informations',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32),
              _buildEnhancedInputField(
                controller: _nameController,
                label: 'Nom ',
                icon:Icons.badge_outlined,
              ),
              SizedBox(height: 32),
              _buildEnhancedInputField(
                controller: _prenomController,
                label: 'Prénom ',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16),
              _buildEnhancedInputField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              _buildPasswordField(),
              SizedBox(height: 16),
              _buildEnhancedInputField(
                controller: _phoneController,
                label: 'Téléphone',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              _buildroleDropdown(),
              SizedBox(height: 16),
              _buildtypeDropdown(),
              SizedBox(height: 16),
              _buildAddressField(),
              SizedBox(height: 32),
              _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              )
                  : Center(
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.blueAccent,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
  Widget _buildroleDropdown() {
    final List<String> role = [
      'Tous les roles',
      'Admin_resto',
      'Caissier',
      'Client_etudiant',
      'Client_personnel',
      'Client_professeur',
      'Cuisinier',
      'Livreur',
      'Serveur',
      'Super_admin'
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.work_outline,
            color: Colors.blueAccent,
          ),
          labelText: 'Role',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        value: 'Client_etudiant', // Valeur par défaut
        items: role.map((String type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _roleController.text = newValue ?? '';
          });
        },
        style: TextStyle(color: Colors.black, fontSize: 16),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
      ),
    );
  }
  Widget _buildtypeDropdown() {
    final List<String> type = [
      'Tous les types',
      'Administrateurs',
      'Etudiants',
      'Personnel',
      'Professeur',
      'Employés',
      'Livreurs'


    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.category_outlined,
            color: Colors.blueAccent,
          ),
          labelText: 'Type',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        value: 'Etudiants', // Valeur par défaut
        items: type.map((String type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _typeController.text = newValue ?? '';
          });
        },
        style: TextStyle(color: Colors.black, fontSize: 16),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
      ),
    );
  }
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.blueAccent,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return TextField(
      controller: _addressController,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Adresse',
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color:Colors.blueAccent,
        ),
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Vérification des champs requis
      if (_nameController.text.isEmpty ||
          _prenomController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veuillez remplir tous les champs obligatoires'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final result = await _apiService.register(
        _nameController.text,
        _prenomController.text,
        _emailController.text,
        _passwordController.text,
        _phoneController.text,
        _roleController.text,
        _typeController.text,
        _addressController.text,
      );

      if (result['status'] == 'success') {
        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inscription réussie, redirection vers la page de connexion...'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        // Attendre un moment pour que le SnackBar soit visible
        await Future.delayed(Duration(seconds: 1));

        // Rediriger vers la page de connexion
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Erreur lors de l\'inscription'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Erreur d\'inscription: $e'); // Pour le débogage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur d\'inscription: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

// Modèle pour les commandes
class Order {
  final String id;
  final String orderDate;
  final String total;
  final String status;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.orderDate,
    required this.total,
    required this.status,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      orderDate: json['order_date'],
      total: json['total'].toString(),
      status: json['status'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

// Modèle pour les éléments de commande
class OrderItem {
  final String menuId;
  final String name;
  final String price;
  final int quantity;

  OrderItem({
    required this.menuId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuId: json['view_menu'].toString(),
      name: json['name'],
      price: json['price'].toString(),
      quantity: json['quantity'],
    );
  }
}

// Fonction pour récupérer l'historique des commandes
Future<List<Order>> fetchOrderHistory(String userId) async {
  final response = await http.get(
    Uri.parse('http://192.168.1.35/senresto/api.php?action=order_history&user_id=$userId'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['data'];
    return data.map((item) => Order.fromJson(item)).toList();
  } else {
    throw Exception('Échec du chargement de l\'historique des commandes');
  }
}

// Page pour afficher l'historique des commandes
class OrderHistoryPage extends StatefulWidget {
  final String userId;

  OrderHistoryPage({required this.userId});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrderHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des commandes'),
      ),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Order order = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text('Commande #${order.id}'),
                    subtitle: Text('Date: ${order.orderDate} - Total: ${order.total} FCFA'),
                    trailing: _getStatusChip(order.status),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, itemIndex) {
                          OrderItem item = order.items[itemIndex];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text('Prix: ${item.price} FCFA'),
                            trailing: Text('Quantité: ${item.quantity}'),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _reorderItems(order);
                            },
                            child: Text('Commander à nouveau'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _getStatusChip(String status) {
    Color chipColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'en attente':
        chipColor = Colors.orange;
        displayText = 'En attente';
        break;
      case 'en préparation':
        chipColor = Colors.blue;
        displayText = 'En préparation';
        break;
      case 'livré':
        chipColor = Colors.green;
        displayText = 'Livré';
        break;
      case 'annulé':
        chipColor = Colors.red;
        displayText = 'Annulé';
        break;
      default:
        chipColor = Colors.grey;
        displayText = status;
    }

    return Chip(
      label: Text(
        displayText,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }

  void _reorderItems(Order order) {
    // Implémentez ici la logique pour commander à nouveau les mêmes articles
    // Par exemple, vous pouvez ajouter tous les éléments de la commande au panier
    // et rediriger l'utilisateur vers la page du panier

    // Exemple:
    for (var item in order.items) {
      // Ajouter l'élément au panier avec la même quantité
      // Cela dépendra de votre implémentation du panier
      // addToCart(item.menuId, item.quantity);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Les articles ont été ajoutés au panier')),
    );

    // Rediriger vers la page du panier
     Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(cartItems: [],)));
  }
}




