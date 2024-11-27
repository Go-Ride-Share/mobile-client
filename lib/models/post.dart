class Post {
  String? postId;
  String? authToken;
  double originLat;
  double originLng;
  double destinationLat;
  double destinationLng;
  String description;
  int seatsAvailable;
  String postName;
  String? posterName;
  String? posterId;
  DateTime departureDate;
  double price;

  Post({
    this.postId,
    this.authToken,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.description,
    required this.seatsAvailable,
    required this.postName,
    this.posterName,
    this.posterId,
    required this.departureDate,
    required this.price,
  });

  // Factory constructor to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'],
      authToken: json['authToken'],
      originLat: (json['originLat'] as num).toDouble(),
      originLng: (json['originLng'] as num).toDouble(),
      destinationLat: (json['destinationLat'] as num).toDouble(),
      destinationLng: (json['destinationLng'] as num).toDouble(),
      description: json['description'],
      seatsAvailable: json['seatsAvailable'],
      postName: json['name'],
      posterName: json['posterName'],
      posterId: json['posterId'],
      departureDate: parseDate(json['departureDate']),
      price: (json['price'] as num).toDouble(),
    );
  }

  /// Returns DateTime object parsed from passed string, current DateTime if string passed is null or an error happens
  static DateTime parseDate(String? dateTimeStr) {
    // Example of dateTimeStr
    // Tue Oct 15 2024 00:00:00 GMT-0500 (Central Daylight Time)
    // If parsing as this fails, tries parsing as ISO8061 date
    const monthIndex = 1;
    const dayIndex = 2;
    const yearIndex = 3;
    const timeIndex = 4;

    const hourIndex = 0;
    const minuteIndex = 1;
    const secondIndex = 2;

    if (dateTimeStr != null) {
      // Parse the string into a DateTime object
      try {
        List<String> dateTimeParts = dateTimeStr.split(' ');

        int month = {
          'Jan': 1,
          'Feb': 2,
          'Mar': 3,
          'Apr': 4,
          'May': 5,
          'Jun': 6,
          'Jul': 7,
          'Aug': 8,
          'Sep': 9,
          'Oct': 10,
          'Nov': 11,
          'Dec': 12}[dateTimeParts[monthIndex]]!;
        int day = int.parse(dateTimeParts[dayIndex]);
        int year = int.parse(dateTimeParts[yearIndex]);

        List<String> timeParts = dateTimeParts[timeIndex].split(':');
        int hour = int.parse(timeParts[hourIndex]);
        int minute = int.parse(timeParts[minuteIndex]);
        int second = int.parse(timeParts[secondIndex]);

        return DateTime(year, month, day, hour, minute, second);
      } catch (e) {
        try {
          // Try parsing the date like an ISO8601 
          return DateTime.parse(dateTimeStr);
        } catch (e2) {
          print('Both date formatting methods returned an error:');
          print('Read as react format: $e');
          print('Read a ISO format: $e2');
        }
      }
    }
    
    // Return current DateTime if string is null or we run into an error.
    return DateTime.now();
  }
}
