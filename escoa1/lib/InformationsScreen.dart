import 'package:flutter/material.dart';
import 'UserProfileService.dart';
import 'main.dart';
// Importez la page profil pour pouvoir y revenir

class InformationsScreen extends StatefulWidget {
  const InformationsScreen({Key? key}) : super(key: key);

  @override
  _InformationsScreenState createState() => _InformationsScreenState();
}

class _InformationsScreenState extends State<InformationsScreen> {
  final UserProfileService _userService = UserProfileService();
  bool _isLoading = true;
  User? _user;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserInformations();
  }

  Future<void> _loadUserInformations() async {
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
      appBar: AppBar(
        title: const Text('Mes Informations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Naviguer vers une page d'édition des informations
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => EditInformationsScreen(user: _user),
              // ));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Erreur: $_errorMessage',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUserInformations,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      )
          : _buildInformationsContent(),
      // Ajout de la BottomNavigationBar pour la cohérence avec les autres écrans
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Index de l'onglet "Compte"
        type: BottomNavigationBarType.fixed,
        items: const [
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
          // Si on clique sur l'onglet Compte, revenir à la page principale du profil
          if (index == 4) {
            // On peut utiliser pop car nous sommes déjà dans la section Compte
            // et voulons revenir à la page principale du profil
            Navigator.pop(context);
          } else {
            // Pour les autres onglets, navigation vers les écrans correspondants
            // Implémenter selon votre système de navigation
          }
        },
      ),
    );
  }

  Widget _buildInformationsContent() {
    if (_user == null) {
      return const Center(child: Text('Aucune donnée utilisateur disponible'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Section Informations Personnelles
          _buildSectionHeader('Informations Personnelles'),
          _buildInfoTile('Prénom', _user!.prenom),
          _buildInfoTile('Nom', _user!.nom),
          _buildInfoTile('Email', _user!.email),
          _buildInfoTile('Téléphone', _user!.telephone ?? 'Non renseigné'),

          const SizedBox(height: 24),
          // Section Adresse
          _buildSectionHeader('Adresse'),
          _buildInfoTile('Adresse complète', _user!.adresse ?? 'Non renseignée'),
          // Vous pouvez ajouter d'autres champs d'adresse ici si disponibles
          // _buildInfoTile('Code postal', _user!.codePostal ?? 'Non renseigné'),
          // _buildInfoTile('Ville', _user!.ville ?? 'Non renseignée'),
          // _buildInfoTile('Pays', _user!.pays ?? 'Non renseigné'),

          const SizedBox(height: 24),
          // Section Compte
          _buildSectionHeader('Informations du Compte'),
          _buildInfoTile('Type d\'utilisateur', _user!.typeUtilisateur),
          _buildInfoTile('Date d\'inscription', _formatDate(_user!.createdAt)),
          _buildInfoTile(
              'Dernière connexion',
              _user!.derniereConnexion != null
                  ? _formatDate(_user!.derniereConnexion!)
                  : 'Première connexion'
          ),

          const SizedBox(height: 32),
          // Boutons d'action
          Center(
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Naviguer vers une page de modification de mot de passe
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => ChangePasswordScreen(),
                    // ));
                  },
                  icon: const Icon(Icons.lock),
                  label: const Text('Modifier mon mot de passe'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Afficher une confirmation de suppression de compte
                    _showDeleteAccountConfirmation();
                  },
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Supprimer mon compte'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const Divider(thickness: 2),
        const SizedBox(height: 8),
      ],
    );
  }

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
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Divider(height: 16, thickness: 0.5),
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

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer mon compte'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible et toutes vos données seront perdues.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appeler l'API pour supprimer le compte
                // _userService.deleteAccount().then((_) {
                //   Navigator.of(context).pushReplacementNamed('/login');
                // });
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}