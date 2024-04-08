class Session {
  late String username;
  late String access_token;
  Session(String user, String token) {
    username = user;
    access_token = token;
  }
}
