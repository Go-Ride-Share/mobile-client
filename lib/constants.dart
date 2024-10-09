class ENV {
    // For Auth:
    static const String API_AUTH_URL_PROD = "https://grs-accountmanager.azurewebsites.net";
    static const String API_AUTH_URL = "https://grs-accountmanager-dev.azurewebsites.net";

    // For Logic:
    static const String API_BASE_URL_PROD = "https://grs-logic.azurewebsites.net";
    static const String API_BASE_URL = "https://grs-logic-dev.azurewebsites.net";

    static const int TOKEN_EXPIRATION_DURATION = 6; //in hours

    static const String CACHE_TOKEN_KEY = "bearer_token";
    static const String CACHE_USER_ID_KEY = "user_id";

    // Sprint 1 - caching only the username for use within the App, will create complex states in the future
    static const String PROFILE_NAME = "profile_name";
}