//this is just a dso

//holds the fields and reresents data structure for the profile/person entity
// includes some validation logic
// does not contain business logic or API calls

//if UI wants to validate, we can call the validate methods and use them as callbacks from Screens.
class Profile {
  final String name;
  final String email;
  final String password;
  final String bio;
  final String phoneNumber;
  final List<String> preferences;
  final String profilePicture;

  Profile({
    required this.name,
    required this.email,
    required this.password,
    required this.bio,
    required this.phoneNumber,
    required this.preferences,
    required this.profilePicture,
  });

  String validate() {
    if (name.isEmpty) {
      return 'Please enter your name';
    }
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    if (bio.isEmpty) {
      return 'Please enter your bio';
    }
    if (phoneNumber.isEmpty) {
      return 'Please enter your phone number';
    }
    if (preferences.isEmpty) {
      return 'Please enter your preferences';
    }
    if (profilePicture.isEmpty) {
      return 'Please upload a profile picture';
    }
    return '';
  }
}