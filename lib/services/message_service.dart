import 'dart:convert';
import 'dart:math';
import 'package:go_ride_sharing/utils.dart';
import '../constants.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import 'caching_service.dart';

class MessageService {

  CachingService cache = CachingService();

  late Future<String?> baseAccessToken;
  late Future<String?> dbAccessToken;
  late Future<String?> userID;

  MessageService() {
    baseAccessToken = cache.getData(ENV.CACHE_BEARER_TOKEN_KEY);
    dbAccessToken = cache.getData(ENV.CACHE_DB_TOKEN_KEY);
    userID = cache.getData(ENV.CACHE_USER_ID_KEY);
  }

  Future<List<Conversation>> getAllConversations() async {

    // Create http request data
    const String uri = '${ENV.API_BASE_URL}/api/GetAllConversations';
    final headers = getHeaders(await baseAccessToken, await dbAccessToken, await userID);

    // Make the request and parse the data
    List<Conversation> conversations = (
      await sendGetRequestAndGetAsList(convertJsonToConversationList, uri, headers))
      .cast<Conversation>();

    return conversations;
  }

  Future<List<Message>> getMessagesForConversation(String conversationId) async {
    // Fake JSON response for messages
    final String response = '''
    [
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:00:00Z",
      "contents": "Hello! I'm looking for a ride to downtown. Are you available?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:01:00Z",
      "contents": "Hi, yes I am available. What time do you need the ride?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:02:00Z",
      "contents": "I need to be there by 11 AM. Can we leave around 10:30?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:03:00Z",
      "contents": "Sure, that works for me. Where should I pick you up?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:04:00Z",
      "contents": "Can you pick me up from 123 Main Street?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:05:00Z",
      "contents": "Got it. I'll be there at 10:30."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:06:00Z",
      "contents": "Great, thank you!"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:07:00Z",
      "contents": "No problem. See you then."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:08:00Z",
      "contents": "Just to confirm, it's 10 dollars for the ride, right?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:09:00Z",
      "contents": "Yes, that's correct."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:10:00Z",
      "contents": "Perfect. I'll have the cash ready."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:11:00Z",
      "contents": "Sounds good. See you soon."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:12:00Z",
      "contents": "Hey, I'm ready. Are you on your way?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:13:00Z",
      "contents": "Yes, I'm just leaving now. Should be there in 10 minutes."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:14:00Z",
      "contents": "Great, see you soon."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:15:00Z",
      "contents": "I'm almost there. Just a couple of minutes away."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:16:00Z",
      "contents": "Okay, I'm waiting outside."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:17:00Z",
      "contents": "I see you. Pulling up now."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:18:00Z",
      "contents": "Got it. Getting in now."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:19:00Z",
      "contents": "Welcome! Let's get going."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:20:00Z",
      "contents": "Thanks for the ride. How long have you been driving?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:21:00Z",
      "contents": "I've been driving for about 2 years now. How about you? Do you often use rideshare services?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:22:00Z",
      "contents": "Yes, I use them quite frequently. It's very convenient."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:23:00Z",
      "contents": "I agree. It's a great way to get around without the hassle of owning a car."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:24:00Z",
      "contents": "Absolutely. Plus, it's more environmentally friendly."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:25:00Z",
      "contents": "True. Every little bit helps."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:26:00Z",
      "contents": "By the way, do you have any recommendations for good places to eat downtown?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:27:00Z",
      "contents": "Oh, there are plenty of great places. What kind of food do you like?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:28:00Z",
      "contents": "I'm open to anything, but I do love Italian food."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:29:00Z",
      "contents": "In that case, you should try 'Luigi's'. They have amazing pasta and pizza."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:30:00Z",
      "contents": "That sounds perfect. I'll definitely check it out."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:31:00Z",
      "contents": "You won't be disappointed. It's one of my favorite spots."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:32:00Z",
      "contents": "Thanks for the recommendation!"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:33:00Z",
      "contents": "Anytime. Enjoy your meal!"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:34:00Z",
      "contents": "Will do. How much longer until we get there?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:35:00Z",
      "contents": "We should be there in about 10 minutes."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:36:00Z",
      "contents": "Great, thanks."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:37:00Z",
      "contents": "You're welcome."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:38:00Z",
      "contents": "Do you have any other favorite spots downtown?"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:39:00Z",
      "contents": "Yes, there's a great coffee shop called 'Brewed Awakenings'. They have the best coffee in town."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:40:00Z",
      "contents": "I love coffee. I'll have to check that out too."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:41:00Z",
      "contents": "Definitely. It's a great place to relax and enjoy a good cup of coffee."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:42:00Z",
      "contents": "Thanks for all the tips. I appreciate it."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:43:00Z",
      "contents": "No problem at all. Happy to help."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:44:00Z",
      "contents": "Looks like we're almost there."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:45:00Z",
      "contents": "Yes, just a couple more minutes."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:46:00Z",
      "contents": "Thanks again for the ride."
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "2023-10-01T10:47:00Z",
      "contents": "You're welcome. Have a great day!"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "2023-10-01T10:48:00Z",
      "contents": "You too!"
      }
    ]
    ''';

    // Decode the JSON response
    final List<dynamic> data = jsonDecode(response);

    // Convert JSON to List<Message>
    List<Message> messages = data.map((json) {
      return Message(
        conversationId: json['conversationId'],
        posterId: json['posterId'],
        timestamp: DateTime.parse(json['timestamp']),
        contents: json['contents'],
      );
    }).toList();

    return messages;
  }

  Future<String> createConversation(String? posterId) async {
    // Generate a dummy conversationId
    final String dummyConversationId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Return the dummy conversationId
    return dummyConversationId;
  }

  Future<List<Message>> pollMessages(String conversationId, DateTime timestamp) async {
    final Random random = Random();
    final String response = '''
    [
      {
      "conversationId": "$conversationId",
      "posterId": "user1",
      "timestamp": "${timestamp.add(Duration(minutes: 2)).toIso8601String()}",
      "contents": "Random number: ${random.nextInt(100)}"
      },
      {
      "conversationId": "$conversationId",
      "posterId": "user2",
      "timestamp": "${timestamp.add(Duration(minutes: 4)).toIso8601String()}",
      "contents": "Random number: ${random.nextInt(100)}"
      }
    ]
    ''';

    // Decode the JSON response
    final List<dynamic> data = jsonDecode(response);

    // Convert JSON to List<Message>
    List<Message> messages = data.map((json) {
      return Message(
        conversationId: json['conversationId'],
        posterId: json['posterId'],
        timestamp: DateTime.parse(json['timestamp']),
        contents: json['contents'],
      );
    }).toList();

    return messages;
  }

  Future<void> postMessage(String conversationId, Message message) async {
    // Dummy function, no implementation needed
  }

  List<Conversation> convertJsonToConversationList(String responseBody) {
    final data = jsonDecode(responseBody);

    List<Conversation> conversations = (data as List).map((json) {
      
        return Conversation.fromJson(json);
        }).toList();

        return conversations;
  }
}