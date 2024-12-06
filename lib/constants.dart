class ENV {

    // UNCOMMENT THE FOLLOWING LINE TO USE LOCALHOST
    // static const String API_AUTH_URL = "http://localhost:7071/api";
    // static const String API_BASE_URL = "http://localhost:7072/api";

    // COMMENT THE FOLLOWING 2 LINES WHEN USING LOCALHOST
    // static const String API_AUTH_URL = "https://grs-accountmanager-dev.azurewebsites.net";
    // static const String API_BASE_URL = "https://grs-logic-dev.azurewebsites.net";

    static const String API_BASE_URL = "https://grs-logic.azurewebsites.net";
    static const String API_AUTH_URL = "https://grs-accountmanager.azurewebsites.net";
    
    static const int TOKEN_EXPIRATION_DURATION = 2; //in hours

    static const String CACHE_BEARER_TOKEN_KEY = "bearer_token";
    static const String CACHE_DB_TOKEN_KEY = "db_token";
    static const String CACHE_USER_ID_KEY = "user_id";

    // Sprint 1 - caching only the username for use within the App, will create complex states in the future
    static const String PROFILE_NAME = "profile_name";
}