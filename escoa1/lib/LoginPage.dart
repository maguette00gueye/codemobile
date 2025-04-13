import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'main.dart'; // Import de ApiService depuis main.dart
import 'HomePage.dart'; // Assurez-vous que cela correspond à votre import de la page d'accueil
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

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
