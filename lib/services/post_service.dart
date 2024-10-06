// For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:your_project_name/models/post.dart'; // Import the Post model

class PostService {
  // Define the API endpoint to fetch the user's posts
  final String apiUrl = "https://api.example.com/user/posts";

  Future<List<Post>> fetchProfilePosts() async {
    // Fill in later
  }

  Future<void> createPost(Post post) async {
    // Fill in later
  }

  Future<void> deletePost(Post post) async {
    // Fill in later
  }
}