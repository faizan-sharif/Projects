import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseUrlScreen extends StatefulWidget {
  const BaseUrlScreen({super.key});

  @override
  State<BaseUrlScreen> createState() => _BaseUrlScreenState();
}

class _BaseUrlScreenState extends State<BaseUrlScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _savedUrl;

  @override
  void initState() {
    super.initState();
    _loadBaseUrl();
  }

  Future<void> _loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedUrl = prefs.getString('baseUrl');
      _controller.text = _savedUrl ?? '';
    });
  }

  Future<void> _saveBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', _controller.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Base URL saved: ${_controller.text}')),
    );
    setState(() => _savedUrl = _controller.text.trim());
  }

   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Base URL'),
      backgroundColor: Theme.of(context).colorScheme.primary,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the base URL of your server:',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              
              )),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'e.g., http://192.168.100.176:8000',
                border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
     


  
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveBaseUrl,
                  child: Text('Save URL'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_savedUrl != null)
              Text('Saved Base URL: $_savedUrl', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
  
}
