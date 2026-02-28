//Login Exceptions
class userNotFoundException implements Exception {}

class wrongPasswordException implements Exception {}

//Register Exceptions

class weakPasswordException implements Exception {}
class emailAlreadyInUseException implements Exception {}
class invalidEmailException implements Exception {}

//Generic Exceptions
class genericAuthException implements Exception {}

class userNotLoggedInException implements Exception {}