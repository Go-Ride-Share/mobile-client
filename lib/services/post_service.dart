import 'package:go_ride_sharing/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostService {
  String logicLayerAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1jN2wzSXo5M2c3dXdnTmVFbW13X1dZR1BrbyIsImtpZCI6Ik1jN2wzSXo5M2c3dXdnTmVFbW13X1dZR1BrbyJ9.eyJhdWQiOiJhcGk6Ly9iNzZmZDJhYi0xN2M5LTQ4MDYtOWY4Mi04ZDExMDRiNjY5OTEiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC80MzM3MGNhZi0xNGY4LTQ4NDktOTE5NC05NTk1MDQ5YzA2ZTkvIiwiaWF0IjoxNzI4NDMyNzQ3LCJuYmYiOjE3Mjg0MzI3NDcsImV4cCI6MTcyODQzNjY0NywiYWlvIjoiazJCZ1lIaFh2VExTY281ZW1oSHZWZmFHVHdjMkFRQT0iLCJhcHBpZCI6ImI3NmZkMmFiLTE3YzktNDgwNi05ZjgyLThkMTEwNGI2Njk5MSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQzMzcwY2FmLTE0ZjgtNDg0OS05MTk0LTk1OTUwNDljMDZlOS8iLCJvaWQiOiIxMDA0ZjEzNC02ZWE1LTRkMDUtYWM3Zi1jNTNiMThjODcyY2QiLCJyaCI6IjAuQVc4QnJ3dzNRX2dVU1VpUmxKV1ZCSndHNmF2U2I3ZkpGd1pJbjRLTkVRUzJhWkZ2QVFBLiIsInN1YiI6IjEwMDRmMTM0LTZlYTUtNGQwNS1hYzdmLWM1M2IxOGM4NzJjZCIsInRpZCI6IjQzMzcwY2FmLTE0ZjgtNDg0OS05MTk0LTk1OTUwNDljMDZlOSIsInV0aSI6IlZNT096Mzd2OEVDZGt4MTdwRXdDQXciLCJ2ZXIiOiIxLjAifQ.k8Q9A1qUsb8ax1RSjxfqQo24LsqFzu98zv1M-uy8RTbj869htXPnYgQZO1cZmHH0G50LGvcHl239Bsm6jbbI8mfiNdeySh5H6qO8bqShJ0LzmJq96D0flhNaW-O65DtH0IO6FCQ8RSQy_snwWTaEH50aqOTipWtdLTSCiJ5LFVvTgYCRA7B95e9-DP3hp2rQWHXBdRx_rzPDGLojJixh1q4W792WpZWdNEsDuo4GUNY3sh1y5fPGMCrmhBYRy9V15rlJE8U_xkuzjFcmcAAPp9eLQRO3zd3e1pG2uL6wfXeXCCsT6hDUqMT0Ixyz0TM7JMX3GWS810hzIyBXhK444Q";
  String dbLayerAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1jN2wzSXo5M2c3dXdnTmVFbW13X1dZR1BrbyIsImtpZCI6Ik1jN2wzSXo5M2c3dXdnTmVFbW13X1dZR1BrbyJ9.eyJhdWQiOiJhcGk6Ly9kZDZjY2RmMy0wOTFmLTQ2ZjMtYTRkMi1lOGE1MGI2ZTUyNjciLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC80MzM3MGNhZi0xNGY4LTQ4NDktOTE5NC05NTk1MDQ5YzA2ZTkvIiwiaWF0IjoxNzI4NDMyNzQ3LCJuYmYiOjE3Mjg0MzI3NDcsImV4cCI6MTcyODQzNjY0NywiYWlvIjoiazJCZ1lJaXhXYnpWWUk4RXAxOHVud2FYOGdNakFBPT0iLCJhcHBpZCI6ImRkNmNjZGYzLTA5MWYtNDZmMy1hNGQyLWU4YTUwYjZlNTI2NyIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzQzMzcwY2FmLTE0ZjgtNDg0OS05MTk0LTk1OTUwNDljMDZlOS8iLCJvaWQiOiI5ZjE3YjU3MS0zNGUwLTQxOGItODBjMi00NDU0M2ExZTI4YTkiLCJyaCI6IjAuQVc4QnJ3dzNRX2dVU1VpUmxKV1ZCSndHNmZQTmJOMGZDZk5HcE5Mb3BRdHVVbWR2QVFBLiIsInN1YiI6IjlmMTdiNTcxLTM0ZTAtNDE4Yi04MGMyLTQ0NTQzYTFlMjhhOSIsInRpZCI6IjQzMzcwY2FmLTE0ZjgtNDg0OS05MTk0LTk1OTUwNDljMDZlOSIsInV0aSI6ImZ6Mlhlb0t3bGtpZFVlWHVoNlVLQVEiLCJ2ZXIiOiIxLjAifQ.FwKyqdfSSGlt558O7lcjp7AYEAKiwvKLTO-d9yyqzIrxkXAFBuWcfZQFX1Kkr9_TO7kVZQpmO06qcVhJYmjAMjaAqBEmcmSls97IQoTacPp01TJSPM3GVOYlQHQ9Uyz0EPFjJX0RPsjhCsL6TqeWknxWB0h3QzmQX2zRgUhwXkEg1HfrjUMY7UStRyY54gOFnP8V2TNefsAkKKfSfwETLbSuu-8Rex0cAQ6UfQBc9An7wLxIfK_yHJdpwKxurxc975_Ukeq7x23KpmGKnfpLzkx4IqiwdrUmEv6BWLrmCAlbFgjRxySu2vKOZtRnUQHWD_XhG22sNAEw-tRUOK66ww";

  Future<List<Post>> fetchProfilePosts() async {
    final url = Uri.parse('https://grs-logic-dev.azurewebsites.net/api/GetPosts?userId=054c8144-4935-44bf-8887-6a06a9d8a78f');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + logicLayerAccessToken,
      'X-Db-Token': dbLayerAccessToken,
      'X-User-ID': '715cf2a6-23bb-4068-8a8d-86c2ccd9d044',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data: $data');
        List<Post> posts = (data as List).map((postJson) {
          Post post = Post.fromJson(postJson);
          post.authToken = "dummyAuthToken";
          post.posterName = "dummyPosterName";
          return post;
        }).toList();
        return posts;
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    }

    return [];
  }

  Future<void> createPost(Post post) async {
    final postData = jsonEncode({
      'posterId': 'hardcodedDummyValue',
      'originLat': post.startLatitude,
      'originLng': post.startLongitude,
      'destinationLat': post.destinationLatitude,
      'destinationLng': post.destinationLongitude,
      'description': post.description,
      'seatsAvailable': post.seatsAvailable,
      'name': post.postName,
      'departureDate': post.departureDate.toIso8601String(),
      'price': post.price,
    });

    final url = Uri.parse('https://grs-logic-dev.azurewebsites.net/api/SavePost?userId=054c8144-4935-44bf-8887-6a06a9d8a78f');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + logicLayerAccessToken,
      'X-Db-Token': dbLayerAccessToken,
      'X-User-ID': '715cf2a6-23bb-4068-8a8d-86c2ccd9d044',
    };

    print('Post Data: $postData');

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
      'originLat': post.startLatitude,
      'originLng': post.startLongitude,
      'destinationLat': post.destinationLatitude,
      'destinationLng': post.destinationLongitude,
      'description': post.description,
      'seatsAvailable': post.seatsAvailable,
      'name': post.postName,
      'departureDate': post.departureDate.toIso8601String(),
      'price': post.price,
    });

    final url = Uri.parse('https://grs-logic-dev.azurewebsites.net/api/SavePost?userId=054c8144-4935-44bf-8887-6a06a9d8a78f');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + logicLayerAccessToken,
      'X-Db-Token': dbLayerAccessToken,
      'X-User-ID': '715cf2a6-23bb-4068-8a8d-86c2ccd9d044',
    };

    print('Post Data: $postData');

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
}
