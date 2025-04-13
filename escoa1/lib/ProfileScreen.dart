import 'package:flutter/material.dart';
import 'UserProfileService.dart';
import 'main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileService _userService = UserProfileService();
  bool _isLoading = true;
  User? _user;
  String _errorMessage = '';

  // Définition d'une palette de couleurs attrayante
  final Color primaryColor = const Color(0xFF3F51B5);  // Indigo
  final Color secondaryColor = const Color(0xFF3F51B5); // Bleu
  final Color accentColor = const Color(0xFFFF4081);    // Rose
  final Color backgroundColor = const Color(0xFFF5F5F5); // Gris très clair
  final Color cardColor = Colors.white;
  final Color textPrimaryColor = const Color(0xFF212121); // Gris très foncé
  final Color textSecondaryColor = const Color(0xFF757575); // Gris moyen

  final LinearGradient headerGradient = const LinearGradient(
    colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final userData = await _userService.getUserProfile();
      setState(() {
        _user = User.fromJson(userData);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Mon Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: secondaryColor))
          : _errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Erreur: $_errorMessage',
              style: TextStyle(color: accentColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      )
          : _buildProfileContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Index de l'onglet "Compte"
        type: BottomNavigationBarType.fixed,
        selectedItemColor: secondaryColor,
        unselectedItemColor: textSecondaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Boutique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Commandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Compte',
          ),
        ],
        onTap: (index) {
          // Navigation vers d'autres écrans
          if (index != 4) {
            // Si l'utilisateur clique sur un autre onglet que "Compte"
            // Ajouter la navigation
          }
        },
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_user == null) {
      return Center(
        child: Text(
          'Aucune donnée utilisateur disponible',
          style: TextStyle(color: textSecondaryColor),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section d'en-tête avec avatar et nom d'utilisateur
          Container(
            decoration: BoxDecoration(
              gradient: headerGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 48, color: Colors.blueGrey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_user!.prenom} ${_user!.nom}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _user!.typeUtilisateur,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Liste des options comme sur la capture d'écran
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Compte'),
                _buildOptionTile(
                  'Mes informations',
                  Icons.person,
                      () => _navigateToScreen(context, 'informations'),
                ),
                _buildOptionTile(
                  'Mes commandes',
                  Icons.shopping_bag,
                      () => _navigateToScreen(context, 'commandes'),
                ),
                _buildOptionTile(
                  'Moyens de paiement',
                  Icons.payment,
                      () => _navigateToScreen(context, 'paiement'),
                ),
                _buildOptionTile(
                  'Adresses enregistrées',
                  Icons.location_on,
                      () => _navigateToScreen(context, 'adresses'),
                ),

                const SizedBox(height: 16),
                _buildSectionTitle('Mes préférences'),
                _buildOptionTile(
                  'Mes favoris',
                  Icons.favorite,
                      () => _navigateToScreen(context, 'favoris'),
                ),
                _buildOptionTile(
                  'Mes discussions',
                  Icons.chat,
                      () => _navigateToScreen(context, 'discussions'),
                ),
                _buildOptionTile(
                  'Mes notifications',
                  Icons.notifications,
                      () => _navigateToScreen(context, 'notifications'),
                ),

                const SizedBox(height: 16),
                _buildSectionTitle('Aide et support'),
                _buildOptionTile(
                  'Contact',
                  Icons.contact_support,
                      () => _navigateToScreen(context, 'contact'),
                ),
                _buildOptionTile(
                  'À propos',
                  Icons.info,
                      () => _navigateToScreen(context, 'apropos'),
                ),
                _buildOptionTile(
                  'Infos utiles',
                  Icons.help,
                      () => _navigateToScreen(context, 'infos'),
                ),

                const SizedBox(height: 32),

                // Bouton de déconnexion
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Fonction de déconnexion
                      // _userService.logout().then((_) {
                      // Naviguer vers la page de connexion
                      // Navigator.of(context).pushReplacementNamed('/login');
                      // });
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Déconnexion',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour les titres de section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  // Widget pour chaque option
  Widget _buildOptionTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: secondaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: secondaryColor),
        onTap: onTap,
      ),
    );
  }

  // Fonction pour naviguer vers d'autres écrans
  void _navigateToScreen(BuildContext context, String route) {
    // Ajoutez votre logique de navigation ici
    print('Navigation vers: $route');
    // Par exemple: Navigator.pushNamed(context, '/$route');
  }

  // Méthodes existantes conservées
  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: textPrimaryColor,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}

