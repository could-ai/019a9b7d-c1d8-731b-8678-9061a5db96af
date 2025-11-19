import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/password_item.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data for demonstration
  final List<PasswordItem> _passwords = [
    PasswordItem(
      id: '1',
      serviceName: 'Google',
      username: 'user@gmail.com',
      password: 'password123',
      notes: 'Main email account',
    ),
    PasswordItem(
      id: '2',
      serviceName: 'Netflix',
      username: 'movie_watcher',
      password: 'securePass!@#',
    ),
  ];

  void _addOrUpdatePassword(PasswordItem item) {
    setState(() {
      final index = _passwords.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        _passwords[index] = item;
      } else {
        _passwords.add(item);
      }
    });
  }

  void _deletePassword(String id) {
    setState(() {
      _passwords.removeWhere((item) => item.id == id);
    });
  }

  Future<void> _navigateToAddEdit({PasswordItem? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditScreen(originalItem: item),
      ),
    );

    if (result != null) {
      if (result is PasswordItem) {
        _addOrUpdatePassword(result);
      } else if (result is Map && result['action'] == 'delete') {
        _deletePassword(result['id']);
      }
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Passwords'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _passwords.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No passwords yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap the + button to add one'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _passwords.length,
              itemBuilder: (context, index) {
                final item = _passwords[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _navigateToAddEdit(item: item),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.serviceName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.username,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () => _copyToClipboard(item.password, 'Password'),
                                tooltip: 'Copy Password',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEdit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
