import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContentPage extends StatelessWidget {
  const HomeContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          _buildSearchBar(context),

          const SizedBox(height: 24),

          // Featured Stations
          Text(
            '推荐电台',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildFeaturedStations(),

          const SizedBox(height: 24),

          // Top Countries
          Text(
            '热门国家',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildTopCountries(),

          const SizedBox(height: 24),

          // Genres
          Text(
            '音乐类型',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildGenres(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: '搜索电台、国家或类型...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () {},
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  Widget _buildFeaturedStations() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade300,
                    Colors.deepPurple.shade500,
                  ],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.radio, size: 40, color: Colors.white),
                    SizedBox(height: 8),
                    Text('热门电台', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopCountries() {
    final countries = ['中国', '美国', '日本', '韩国', '英国', '法国', '德国'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: countries.map((country) {
        return FilterChip(
          label: Text(country),
          onSelected: (_) {},
          avatar: const CircleAvatar(
            radius: 12,
            child: Text('🌍', style: TextStyle(fontSize: 12)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenres() {
    final genres = ['流行', '古典', '爵士', '摇滚', '电子', '新闻', '自然'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.map((genre) {
        return ActionChip(
          label: Text(genre),
          avatar: const Icon(Icons.music_note, size: 16),
          onPressed: () {},
        );
      }).toList(),
    );
  }
}
