class Post {
  final String authToken;
  final double startLatitude;
  final double startLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final String description;
  final int seatsAvailable;
  final String postName;
  final String posterName;
  final DateTime departureDate;
  final double price;

  Post({
    required this.authToken,
    required this.startLatitude,
    required this.startLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.description,
    required this.seatsAvailable,
    required this.postName,
    required this.posterName,
    required this.departureDate,
    required this.price,
  });

  // Factory constructor to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      authToken: json['authToken'],
      startLatitude: json['startLatitude'],
      startLongitude: json['startLongitude'],
      destinationLatitude: json['destinationLatitude'],
      destinationLongitude: json['destinationLongitude'],
      description: json['description'],
      seatsAvailable: json['seatsAvailable'],
      postName: json['postName'],
      posterName: json['posterName'],
      departureDate: DateTime.parse(json['departureDate']),
      price: json['price'],
    );
  }
}