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

  Future<List<Message>> getMessagesForConversation(Conversation conversation) async {
    return conversation.messages;
  }

  Future<String> createConversation(String? posterId) async {
    // Generate a dummy conversationId
    final String dummyConversationId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Return the dummy conversationId
    return dummyConversationId;
  }

  Future<List<Message>> pollMessages(String conversationId, DateTime timeStamp) async {

    // Create http request data
    final String uri = '${ENV.API_BASE_URL}/api/PollConversation?conversationId=$conversationId&timeStamp=$timeStamp';
    final headers = getHeaders(await baseAccessToken, await dbAccessToken, await userID);

    List<Message> messages = (
      await sendGetRequestAndGetAsList(convertJsonToMessageList, uri, headers))
    .cast<Message>();
    
    return messages;
  }

  Future<void> postMessage(String conversationId, Message message) async {
    // Dummy function, no implementation needed
  }

  /// Used by getAllConversations
  List<Conversation> convertJsonToConversationList(String responseBody) {
    final data = jsonDecode(responseBody);

    List<Conversation> conversations = (data as List).map((json) {
      
        return Conversation.fromJson(json);
        }).toList();

        return conversations;
  }

  /// Used by pollMessages
  List<Message> convertJsonToMessageList(String responseBody) {
    final data = jsonDecode(responseBody);
    final Conversation conversation = Conversation.fromJson(data);

   return conversation.messages;
  }
}