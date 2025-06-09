import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthRepository {
  static const String _loggedInUserKey = 'loggedInUser';
  static const String _registeredUsersKey = 'registeredUsers';

  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_loggedInUserKey);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredUsersJson = prefs.getStringList(_registeredUsersKey) ?? [];
    final registeredUsers = registeredUsersJson
        .map((jsonString) => User.fromJson(json.decode(jsonString)))
        .toList();

    final user = registeredUsers.firstWhere(
          (u) => u.username == username && u.password == password,
      orElse: () => throw Exception('Invalid username or password'),
    );

    await prefs.setString(_loggedInUserKey, json.encode(user.toJson()));
  }

  Future<void> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> registeredUsersJson =
        prefs.getStringList(_registeredUsersKey) ?? [];
    List<User> registeredUsers = registeredUsersJson
        .map((jsonString) => User.fromJson(json.decode(jsonString)))
        .toList();

    if (registeredUsers.any((u) => u.username == username)) {
      throw Exception('Username already exists');
    }

    final newUser = User(username: username, password: password);
    registeredUsers.add(newUser);
    registeredUsersJson =
        registeredUsers.map((user) => json.encode(user.toJson())).toList();
    await prefs.setStringList(_registeredUsersKey, registeredUsersJson);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserKey);
  }
}
