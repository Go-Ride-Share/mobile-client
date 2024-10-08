//should i name this authetnication checker or login getter
// this is a service that will check if the user is logged in or not from any screen

//should fetch authentication token from shared preferences or JSON cache
// if token is not found, navigate to sign in page
// if token is found, navigate to home page
// between screens, use navigator.pushReplacementNamed('/home') or navigator.pushReplacementNamed('/sign_in_page')
// this service will be used in the splash screen to determine the first screen to navigate to

// it will also fetch the token in the state, for stateful widgets to use and pass to other services
// other services will use this token to make requests to the server