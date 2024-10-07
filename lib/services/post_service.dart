// For JSON decoding
import 'package:go_ride_sharing/models/post.dart'; // Import the Post model

class PostService {
  // Define the API endpoint to fetch the user's posts
  final String apiUrl = "https://api.example.com/user/posts";

  Future<List<Post>> fetchProfilePosts() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Return a list of fake posts
    return [
      Post(
        authToken: 'token1',
        startLatitude: 37.7749,
        startLongitude: -122.4194,
        destinationLatitude: 34.0522,
        destinationLongitude: -118.2437,
        description: 'Trip from SF to LA',
        seatsAvailable: 3,
        postName: 'SF to LA Ride',
        posterName: 'John Doe',
        departureDate: DateTime.now().add(Duration(days: 1)),
        price: 50.0,
      ),
      Post(
        authToken: 'token2',
        startLatitude: 40.7128,
        startLongitude: -74.0060,
        destinationLatitude: 42.3601,
        destinationLongitude: -71.0589,
        description: 'Trip from NYC to Boston',
        seatsAvailable: 2,
        postName: 'NYC to Boston Ride',
        posterName: 'Jane Smith',
        departureDate: DateTime.now().add(Duration(days: 2)),
        price: 30.0,
      ),
      Post(
        authToken: 'token3',
        startLatitude: 34.0522,
        startLongitude: -118.2437,
        destinationLatitude: 36.1699,
        destinationLongitude: -115.1398,
        description: 'Trip from LA to Vegas',
        seatsAvailable: 4,
        postName: 'LA to Vegas Ride',
        posterName: 'Alice Johnson',
        departureDate: DateTime.now().add(Duration(days: 3)),
        price: 40.0,
      ),
      Post(
        authToken: 'token4',
        startLatitude: 47.6062,
        startLongitude: -122.3321,
        destinationLatitude: 45.5152,
        destinationLongitude: -122.6784,
        description: 'Trip from Seattle to Portland',
        seatsAvailable: 1,
        postName: 'Seattle to Portland Ride',
        posterName: 'Bob Brown',
        departureDate: DateTime.now().add(Duration(days: 4)),
        price: 25.0,
      ),
    ];
  }

  Future<void> createPost(Post post) async {
    print('Auth Token: ${post.authToken}');
    print('Start Latitude: ${post.startLatitude}');
    print('Start Longitude: ${post.startLongitude}');
    print('Destination Latitude: ${post.destinationLatitude}');
    print('Destination Longitude: ${post.destinationLongitude}');
    print('Description: ${post.description}');
    print('Seats Available: ${post.seatsAvailable}');
    print('Post Name: ${post.postName}');
    print('Poster Name: ${post.posterName}');
    print('Departure Date: ${post.departureDate}');
    print('Price: ${post.price}');
    // Fill in later
  }

  Future<void> deletePost(Post post) async {
    // Fill in later
  }
}