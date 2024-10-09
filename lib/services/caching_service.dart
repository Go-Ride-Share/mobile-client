import 'package:shared_preferences/shared_preferences.dart';

class CachingService {
  static const String _keyData = 'myData';
  static const String _keyExpiration = 'expirationTime';


  /*
    //Function to save data with an expiration date to SharedPreferences
    Parameters:
      key: The key to store the data with
      data: The data to store
      expirationDuration: The duration after which the data will expire
    Returns:
      A Future<bool> that resolves to true if the data was saved successfully, false otherwise

    How to use Duration object:
      Example: Duration(days: 1, hours: 2, minutes: 30, seconds: 30)
  */
  Future<bool> saveData(String key, String data, Duration expirationDuration) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime expirationTime = DateTime.now().add(expirationDuration);
      await prefs.setString(key, data);
      await prefs.setString("${key}_expiration", expirationTime.toIso8601String());
      // print in what format data was saved
      print('Data saved to SharedPreferences.');
      print("Key: $key, Data: $data, Expiration Time: $expirationTime");
      return true;
    } catch (e) {
      print('Error saving data to SharedPreferences: $e');
      return false;
    }
  }

  /*
    Function to get data from SharedPreferences if it's not expired
    
    Parameters:
      key: The key to retrieve the data with
    Returns:
      A Future<String> that resolves to the data if it's not expired, null otherwise
   */
  Future<String?> getData(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? data = prefs.getString(key);
      String? expirationTimeStr = prefs.getString("${key}_expiration");
      if (data == null || expirationTimeStr == null) {
        print('No data or expiration time found in SharedPreferences.');
        return null; // No data or expiration time found.
      }

      DateTime expirationTime = DateTime.parse(expirationTimeStr);
      if (expirationTime.isAfter(DateTime.now())) {
        print('Data has not expired.');
        // The data has not expired.
        return data;
      } else {
        // Data has expired. Remove it from SharedPreferences.
        await prefs.remove(_keyData);
        await prefs.remove(_keyExpiration);
        print('Data has expired. Removed from SharedPreferences.');
        return null;
      }
    } catch (e) {
      print('Error retrieving data from SharedPreferences: $e');
      return null;
    }
  }

  // Function to clear data from SharedPreferences
  Future<void> clearData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyData);
      await prefs.remove(_keyExpiration);
      print('Data cleared from SharedPreferences.');
    } catch (e) {
      print('Error clearing data from SharedPreferences: $e');
    }
  }
}