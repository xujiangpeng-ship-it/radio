import 'package:flutter/material.dart';

void main() {
  runApp(
    const GlobalBroadcastApp(),
  );
}

class GlobalBroadcastApp extends StatelessWidget {
  const GlobalBroadcastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '全球广播',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _isLoading = true;
  List<Map<String, dynamic>> _stations = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadStations() async {
    try {
      final response = await _fetchStations();
      setState(() {
        _stations = response['data'];
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<Map<String, dynamic>> _fetchStations() async {
    // Stub: Replace with actual API call to Cloudflare Worker
    return {
      'data': [
        {'name': 'NPR News', 'country': 'US', 'genre': 'News'},
        {'name': 'BBC World Service', 'country': 'UK', 'genre': 'News'},
        {'name': 'NHK World Japan', 'country': 'JP', 'genre': 'News'},
        {'name': 'France Inter', 'country': 'FR', 'genre': 'Talk'},
        {'name': 'China National Radio', 'country': 'CN', 'genre': 'News'},
      ]
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('全球广播'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.radio, size: 100, color: Colors.blue),
            const SizedBox(height: 24),
            const Text('全球广播电台', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_error != null)
              Text('错误: $_error', style: const TextStyle(color: Colors.red))
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _stations.length,
                  itemBuilder: (context, index) {
                    final station = _stations[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            station['country']!.substring(0, 2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(station['name']!),
                        subtitle: Text('${station['country']} • ${station['genre']}'),
                        trailing: const Icon(
                          Icons.play_circle_outline,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getGenreColor(String? genre) {
    switch (genre?.toLowerCase()) {
      case 'news':
        return Colors.red;
      case 'music':
        return Colors.purple;
      case 'talk':
        return Colors.orange;
      case 'classical':
        return Colors.indigo;
      case 'general':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }
}
