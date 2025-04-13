import 'package:flutter/material.dart';

// Modèle pour les horaires
class OpeningHours {
  final String day;
  final List<String> hours;

  const OpeningHours({required this.day, required this.hours});
}

// Modèle pour les moyens de livraison
class DeliveryMethod {
  final String name;
  final IconData icon;
  final bool available;

  const DeliveryMethod({
    required this.name,
    required this.icon,
    required this.available,
  });
}

// Modèle pour les avis
class Review {
  final String username;
  final String date;
  final double rating;
  final String comment;
  final String? userImage;

  const Review({
    required this.username,
    required this.date,
    required this.rating,
    required this.comment,
    this.userImage,
  });
}

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantName;
  final String restaurantImage;
  final double rating;
  final int reviewCount;
  final String address;
  final String phoneNumber;
  final List<OpeningHours> openingHours;
  final List<DeliveryMethod> deliveryMethods;
  final bool isOpen;
  final String description;
  final List<Review> reviews;

  const RestaurantDetailScreen({
    Key? key,
    this.restaurantName = "SENRESTO_ESCOA",
    this.restaurantImage = "images/img_2.png",
    this.rating = 5.0,
    this.reviewCount = 3,
    this.address = "KM 4.5 Avenue Cheikh Anta DIOP, en face UCAD Dakar/Senegal",
    this.phoneNumber = "+221 33-843-71-71",
    this.openingHours = const [
      OpeningHours(day: "Lundi", hours: ["09:00 - 20:00"]),
      OpeningHours(day: "Mardi", hours: ["09:00 - 20:00"]),
      OpeningHours(day: "Mercredi", hours: ["09:00 - 20:00"]),
      OpeningHours(day: "Jeudi", hours: ["09:00 - 20:00"]),
      OpeningHours(day: "Vendredi", hours: ["09:00 - 20:00"]),
      OpeningHours(day: "Samedi", hours: ["09:00 - 17:00"]),
      OpeningHours(day: "Dimanche", hours: ["Fermé"]),
    ],
    this.deliveryMethods = const [
      DeliveryMethod(
        name: "Click&Collect",
        icon: Icons.shopping_bag_outlined,
        available: true,
      ),
      DeliveryMethod(
        name: "Livraison à domicile",
        icon: Icons.delivery_dining,
        available: true,
      ),
    ],
    this.isOpen = true,
    this.description = "SENRESTO_ESCOA est un restaurant moderne proposant une cuisine sénégalaise authentique et raffinée. Situé en face de l'UCAD, notre établissement offre un cadre convivial pour savourer nos spécialités préparées avec des ingrédients frais et locaux. Nous proposons un service de qualité, des plats variés et une ambiance chaleureuse pour tous nos clients.",
    this.reviews = const [
      Review(
        username: "Sophie M.",
        date: "15 Mars 2025",
        rating: 5.0,
        comment: "Excellent restaurant! La cuisine est délicieuse et le service impeccable. Je recommande vivement le thieboudienne qui est vraiment authentique.",
        userImage: "images/avatar1.png",
      ),
      Review(
        username: "Amadou D.",
        date: "2 Mars 2025",
        rating: 4.5,
        comment: "Très bonne adresse près de l'université. Rapport qualité-prix imbattable et plats copieux. Seul bémol: l'attente aux heures de pointe.",
        userImage: "images/avatar2.png",
      ),
      Review(
        username: "Fatou N.",
        date: "25 Février 2025",
        rating: 5.0,
        comment: "J'adore cet endroit! Cuisine savoureuse, cadre agréable et personnel attentionné. Je viens régulièrement et je n'ai jamais été déçue.",
        userImage: "images/avatar3.png",
      ),
    ],
  }) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  String currentTab = "Détails";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // En-tête avec image et titre
          Stack(
            children: [
              // Image du restaurant avec overlay
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.restaurantImage),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
              // Barre supérieure avec bouton retour et nom du restaurant
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF3F51B5),
                      const Color(0xFF3F51B5).withOpacity(0),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.restaurantName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Onglets (Détails, Description, Avis)
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildTab("Détails", isSelected: currentTab == "Détails"),
                _buildTab("Description", isSelected: currentTab == "Description"),
                _buildTab("Avis", isSelected: currentTab == "Avis"),
              ],
            ),
          ),

          // Contenu principal
          Expanded(
            child: SingleChildScrollView(
              child: _buildCurrentTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, {bool isSelected = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentTab = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF3F51B5) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? const Color(0xFF3F51B5) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (currentTab) {
      case "Description":
        return _buildDescriptionTab();
      case "Avis":
        return _buildReviewsTab();
      case "Détails":
      default:
        return _buildDetailsTab();
    }
  }

  Widget _buildDetailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section étoiles
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.star_border, size: 28, color: Color(0xFF3F51B5)),
              const SizedBox(width: 12),
              Row(
                children: List.generate(
                  widget.rating.round(),
                      (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFFF9800),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "(${widget.reviewCount})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9800),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Section adresse
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 28, color: Color(0xFF3F51B5)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.address,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3F51B5)),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF3F51B5).withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.map_outlined, size: 24, color: Color(0xFF3F51B5)),
              ),
            ],
          ),
        ),

        // Section téléphone
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.phone, size: 28, color: Color(0xFF3F51B5)),
              const SizedBox(width: 12),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F51B5),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F51B5),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3F51B5).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.call, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "Appeler",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Section livraison
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3F51B5).withOpacity(0.1),
                const Color(0xFF3F51B5).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "MOYENS DE LIVRAISON",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...widget.deliveryMethods.map((method) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      method.icon,
                      color: const Color(0xFF3F51B5),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      method.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      method.available ? Icons.check_circle : Icons.cancel,
                      color: method.available ? const Color(0xFF4CAF50) : Colors.red,
                      size: 20,
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),

        // Section infos
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F51B5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "INFOS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFF3F51B5),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "HORAIRES D'OUVERTURE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: (widget.isOpen ? const Color(0xFF4CAF50) : Colors.red).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: widget.isOpen ? const Color(0xFF4CAF50) : Colors.red,
                          size: 8,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.isOpen ? "Ouvert" : "Fermé",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.isOpen ? const Color(0xFF4CAF50) : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
            ],
          ),
        ),

        // Section horaires
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: widget.openingHours.map((hourData) =>
                _buildHoraireRow(hourData.day, hourData.hours)
            ).toList(),
          ),
        ),

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildDescriptionTab() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3F51B5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "À PROPOS DE NOUS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3F51B5).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3F51B5).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: Color(0xFF3F51B5),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Notre histoire",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Services offerts
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.room_service,
                      color: Color(0xFF3F51B5),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Nos services",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildServiceItem("Service à table", "Profitez d'un service personnalisé et attentionné"),
                _buildServiceItem("Réservation en ligne", "Réservez facilement votre table en quelques clics"),
                _buildServiceItem("Événements spéciaux", "Nous organisons vos anniversaires et célébrations"),
                _buildServiceItem("Plats à emporter", "Tous nos plats sont disponibles à emporter"),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Spécialités
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF9800).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_dining,
                      color: const Color(0xFFFF9800),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Nos spécialités",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSpecialityItem("Thieboudienne", "Le plat national sénégalais"),
                _buildSpecialityItem("Yassa", "Poulet ou poisson mariné avec oignons et citron"),
                _buildSpecialityItem("Mafé", "Ragoût à base de sauce d'arachide"),
                _buildSpecialityItem("Pastels", "Beignets farcis à la viande ou au poisson"),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Column(
      children: [
        // En-tête des avis
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
              children: [
          Row(
          children: [
          Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF3F51B5).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.star,
            color: Color(0xFFFF9800),
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.rating.toStringAsFixed(1)}/5",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F51B5),
              ),
            ),
            Text(
              "Basé sur ${widget.reviewCount} avis",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF3F51B5),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3F51B5).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.rate_review, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                "Ajouter un avis",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    const SizedBox(height: 16),
    // Barre d'étoiles
    Row(
    children: [
    const Text(
    "5",
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xFF3F51B5),
    ),
    ),
    const SizedBox(width: 8),
    const Icon(Icons.star, color: Color(0xFFFF9800), size: 16),
    const SizedBox(width: 8),
    Expanded(
    child: ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: LinearProgressIndicator(
    value: 0.8,
    backgroundColor: Colors.grey[300],
    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
    minHeight: 8,
    ),
    ),
    ),
    const SizedBox(width: 8),
    Text(
    "80%",
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey[600],
    ),
    ),
    ],
    ),
    const SizedBox(height: 8),
    Row(
    children: [
    const Text(
    "4",
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xFF3F51B5),
    ),
    ),
      // Continuation du Row pour l'indicateur 4 étoiles
      const SizedBox(width: 8),
      const Icon(Icons.star, color: Color(0xFFFF9800), size: 16),
      const SizedBox(width: 8),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 0.15,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
            minHeight: 8,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        "15%",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    ],
    ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "3",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Color(0xFFFF9800), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.05,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "5%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "2",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Color(0xFFFF9800), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.0,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "0%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "1",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Color(0xFFFF9800), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.0,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "0%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
          ),
        ),

        // Liste des avis
        ...widget.reviews.map((review) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar utilisateur
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      image: review.userImage != null
                          ? DecorationImage(
                        image: AssetImage(review.userImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: review.userImage == null
                        ? const Icon(Icons.person, color: Colors.grey, size: 24)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review.date,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < review.rating.floor()
                            ? Icons.star
                            : (index < review.rating ? Icons.star_half : Icons.star_border),
                        color: const Color(0xFFFF9800),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                review.comment,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.thumb_up_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          "Utile",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.report_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          "Signaler",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )).toList(),

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildHoraireRow(String day, List<String> hours) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: hours.map((hour) => Text(
                hour,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: hour == "Fermé" ? Colors.red : const Color(0xFF3F51B5),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF3F51B5).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Color(0xFF3F51B5),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialityItem(String name, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant,
              color: Color(0xFFFF9800),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}