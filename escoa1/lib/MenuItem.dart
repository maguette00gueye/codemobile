class MenuItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String mealType;
  final double rating;

  MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.mealType,
    this.rating = 4.5,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'].toString(),
      title: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['image'] ?? '',
      category: json['category'] ?? 'Tous les plats',
      mealType: json['meal_type'] ?? 'Déjeuner',
      rating: double.tryParse(json['rating'].toString()) ?? 4.5,
    );
  }
}