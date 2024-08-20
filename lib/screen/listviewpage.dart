import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pagination/screen/noInternet.dart'; // Import the NoInternetPage widget
import '../api/getapi.dart'; // Import the UserService class
import '../containerwidget.dart'; // Import container widget

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> users = [];
  final UserService userService = UserService();
  bool isLoading = false;
  bool hasMore = true;
  bool hasError = false;
  String errorMessage = '';
  int currentPage = 0;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late Timer retryTimer;

  @override
  void initState() {
    super.initState();
    fetchInitialData(); // Fetch initial data and set up connectivity listener
  }

  void fetchInitialData() {
    // Set up a listener for connectivity changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none && hasError) {
        fetchUsers(); // Retry fetching data if connectivity is restored and there was an error
      }
    });

    // Initial connectivity check and fetch
    checkConnectivityAndFetchUsers();

    // Set up periodic check for internet connectivity
    retryTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        fetchUsers(); // Attempt to fetch users when connectivity is restored
        timer.cancel(); // Cancel the timer once the data is fetched successfully
      }
    });
  }

  Future<void> checkConnectivityAndFetchUsers() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasError = true;
        errorMessage = 'No Internet Connection';
      });
    } else {
      fetchUsers(); // Fetch users if there is internet connectivity
    }
  }
  Future<void> fetchUsers() async {
    if (isLoading || !hasMore) return;

    // Check connectivity before making the API call
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'No Internet Connection'; // Error message for no connectivity
      });
      return;
    }

    // If there is internet connectivity, proceed with fetching data
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final fetchedUsers = await userService.fetchUsers(page: currentPage);
      setState(() {
        isLoading = false;
        if (fetchedUsers.isNotEmpty) {
          users.addAll(fetchedUsers);
          currentPage++;
        } else {
          hasMore = false; // No more data to load
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString(); // Set the error message for any fetch error
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text('ListView Exercise'),
      ),
      body: hasError && users.isEmpty
          ? NoInternetPage(
        errorMessage: errorMessage,
        onRetry: () {
          setState(() {
            hasError = false; // Clear the error state
            errorMessage = '';
          });
          fetchUsers(); // Retry fetching users
        },
      )
          : users.isEmpty
          ? Center(
          child: CircularProgressIndicator()) // Show spinner while loading
          : NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!isLoading && hasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchUsers(); // Fetch more users when scrolling to the bottom
          }
          return true;
        },
        child: ListView.builder(
          itemCount: users.length + 1, // Add one for the loading indicator
          itemBuilder: (context, index) {
            if (index == users.length) {
              // Show a loading indicator at the end of the list
              return Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : NoInternetPage(errorMessage: errorMessage, onRetry:  () {
                  setState(() {
                    hasError = false; // Clear the error state
                    errorMessage = '';
                  });
                  fetchUsers(); // Retry fetching users
                },),
              );
            }
            final user = users[index];
            final email = user['email'];
            final name = user['name']['first'];
            final image = user['picture']['thumbnail'];
            return Column(
              children: [
                NotificationCard(
                  imageUrl: image,
                  message: email,
                  time: name,
                ),
              ],
            );
          },
        ),
      ),
    );
  }}