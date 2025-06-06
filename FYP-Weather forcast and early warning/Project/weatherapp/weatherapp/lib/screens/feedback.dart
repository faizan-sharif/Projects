import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feedback")),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "We value your feedback!",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 6,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter your feedback here...",
                hintStyle: TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Feedback submitted!")),
                );
                _controller.clear();
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
