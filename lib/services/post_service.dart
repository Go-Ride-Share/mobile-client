import 'package:go_ride_sharing/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'caching_service.dart';
import '../constants.dart';
import 'package:go_ride_sharing/utils.dart';

class PostService {
  CachingService cache = CachingService();

  late Future<String?> baseAccessToken;
  late Future<String?> dbAccessToken;
  late Future<String?> userID;

  PostService() {
    baseAccessToken = cache.getData(ENV.CACHE_BEARER_TOKEN_KEY);
    dbAccessToken = cache.getData(ENV.CACHE_DB_TOKEN_KEY);
    userID = cache.getData(ENV.CACHE_USER_ID_KEY);
  }

  Future<List<Post>> fetchProfilePosts() async {
    final userId = await userID;

    final url = '${ENV.API_BASE_URL}/api/Posts/$userId';
    // logic token and db token can be null values if they are expired.
    // We are ignoring the case of having to sign in again.
    final headers = getHeaders(await baseAccessToken, await dbAccessToken, await userID);

    List<Post> posts = (
      await sendGetRequestAndGetAsList(convertJsonToPostList, url, headers)
    ).cast<Post>();

    return posts;
  }

  Future<void> createPost(Post post) async {
    String? userID = await this.userID;
    
    final postData = jsonEncode({
      'posterId': userID,
      'name': post.postName,
      'originLat': post.originLat,
      'originLng': post.originLng,
      'destinationLat': post.destinationLat,
      'destinationLng': post.destinationLng,
      'originName': post.originName,
      'destinationName': post.destinationName,
      'description': post.description,
      'seatsAvailable': post.seatsAvailable,
      'departureDate': post.departureDate.toIso8601String(),
      'price': post.price,
    });

    final url = Uri.parse('${ENV.API_BASE_URL}/api/posts');

    final headers = getHeaders(await baseAccessToken, await dbAccessToken, userID);
 
    print('Asits Post Data: $postData');
    print('Asits Headers: $headers');
    print('Asits URL: $url');

    try {
      final response = await http.post(url, headers: headers, body: postData);

      if (response.statusCode == 201) {
        print('Post created successfully');
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  Future<void> updatePost(Post post) async {
    final postData = jsonEncode({
      'posterId': 'hardcodedDummyValue',
      'postId': post.postId,
      'originLat': post.originLat,
      'originLng': post.originLng,
      'destinationLat': post.destinationLat,
      'destinationLng': post.destinationLng,
      'originName': post.originName,
      'destinationName': post.destinationName,
      'description': post.description,
      'seatsAvailable': post.seatsAvailable,
      'name': post.postName,
      'departureDate': post.departureDate.toIso8601String(),
      'price': post.price,
    });

    final url = Uri.parse('${ENV.API_BASE_URL}/api/Posts/${await userID}');

    final headers = getHeaders(await baseAccessToken, await dbAccessToken, await userID);

    // print('Post Data: $postData');

    try {
      final response = await http.post(url, headers: headers, body: postData);

      if (response.statusCode == 201) {
        print('Post created successfully');
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }
  }

  Future<List<Post>> fetchAllPosts() async {
    const url = '${ENV.API_AUTH_URL}/api/Posts';
    // logic token and db token can be null values if they are expired.
    // We are ignoring the case of having to sign in again.
    final headers = getHeaders(await baseAccessToken, await dbAccessToken, await userID);

    List<Post> posts = (
      await sendGetRequestAndGetAsList(convertJsonToPostList, url, headers)
    ).cast<Post>();

    return posts;
  }

  List<Post> convertJsonToPostList(String responseBody) {
    final data = jsonDecode(responseBody);
        List<Post> posts = (data as List).map((postJson) {
          return Post.fromJson(postJson);
        })
        .where((post) => post.postName != "Load test")
        .toList();

    return posts;
  }

  
}
