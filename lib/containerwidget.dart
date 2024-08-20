import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String imageUrl;
  final String message;
  final String time;

  const NotificationCard({
    Key? key,
    required this.imageUrl,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            height: 100,
            child: Row(
              children: [
                // Add some spacing before the Container
                const SizedBox(width: 10),

                // Circular Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 20),
                // Add some spacing after the Container

                // Text and Button Column
                Expanded(
                  child: Container(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        Text(
                          message,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          time,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF33353D),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.grey, // Line color
          thickness: 1, // Line thickness
          indent: 20, // Space to the left of the line
          endIndent: 20, // Space to the right of the line
        ),
      ],
    );
  }
}
