import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class UserService {
  final String baseUrl = 'https://randomuser.me/api/';
  final int resultsPerPage = 10;

  Future<List<dynamic>> fetchUsers({int page = 1}) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    // Check for connectivity before making the API call
    if (connectivityResult == ConnectivityResult.none) {
      // Throw an exception or handle it as needed
      throw Exception('No Internet Connection');
    }

    final url = '$baseUrl?results=$resultsPerPage&page=$page';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        return json['results'];
      } else {
        throw Exception('Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions properly or rethrow
      // Consider logging the error or notifying the user
      print('Error: $e');
      throw Exception('An error occurred while fetching users.');
    }
  }
}
