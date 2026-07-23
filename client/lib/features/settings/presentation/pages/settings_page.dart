import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          _SettingsSection(
            title: '播放设置',
            items: [
              _SettingsItem(
                icon: Icons.audiotrack,
                title: '音频质量',
                subtitle: '标准 (128kbps)',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.sleep,
                title: '定时关闭',
                subtitle: '关闭',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.download,
                title: '离线缓存',
                subtitle: '0 MB',
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: '语言与地区',
            items: [
              _SettingsItem(
                icon: Icons.language,
                title: '应用语言',
                subtitle: '跟随系统',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.public,
                title: '默认地区',
                subtitle: '全球',
                onTap: () {},
              ),
            ],
          ),
          _SettingsSection(
            title: '关于',
            items: [
              _SettingsItem(
                icon: Icons.info,
                title: '版本信息',
                subtitle: 'v1.0.0',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.star,
                title: '评分此应用',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.feedback,
                title: '反馈建议',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
