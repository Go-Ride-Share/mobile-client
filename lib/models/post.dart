class Post {
  String? postId;
  String? authToken;
  double startLatitude;
  double startLongitude;
  double destinationLatitude;
  double destinationLongitude;
  String description;
  int seatsAvailable;
  String postName;
  String? posterName;
  DateTime departureDate;
  double price;

  Post({
    this.postId,
    this.authToken,
    required this.startLatitude,
    required this.startLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.description,
    required this.seatsAvailable,
    required this.postName,
    this.posterName,
    required this.departureDate,
    required this.price,
  });

  // Factory constructor to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'],
      authToken: json['authToken'],
      startLatitude: (json['originLat'] as num).toDouble(),
      startLongitude: (json['originLng'] as num).toDouble(),
      destinationLatitude: (json['destinationLat'] as num).toDouble(),
      destinationLongitude: (json['destinationLng'] as num).toDouble(),
      description: json['description'],
      seatsAvailable: json['seatsAvailable'],
      postName: json['name'],
      departureDate: json['departureDate'] != null && json['departureDate'].isNotEmpty
          ? DateTime.parse(json['departureDate'])
          : DateTime.now(), // Default to current date if not provided
      price: (json['price'] as num).toDouble(),
    );
  }
}
