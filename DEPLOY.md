# 全球广播APP - 部署指南

## 🚀 快速开始

### 后端 (Cloudflare Workers)

1. **安装Wrangler CLI**
```bash
npm i -g wrangler
```

2. **登录Cloudflare**
```bash
cd server
wrangler auth login
```

3. **创建D1数据库**
```bash
npx wrangler d1 create radio-stations
```
将输出的ID复制到 `server/wrangler.toml`

4. **初始化数据库表**
```bash
npx wrangler d1 execute radio-stations --file=./schema.sql
```

5. **本地测试**
```bash
npm run dev
```

6. **部署**
```bash
npm run deploy
```

---

### 客户端 (Flutter)

1. **设置Flutter环境**
```bash
flutter doctor
flutter pub get
```

2. **配置API地址**

编辑 `client/.env` 添加后端地址：
```env
backendUrl=https://your-worker.workers.dev/api
```

3. **运行应用**
```bash
# Android
flutter run -d <device_id>

# 或创建虚拟设备
flutter emulators
```

4. **构建APK**
```bash
flutter build apk --release
```

---

## 📦 项目结构

```
radio/
├── client/              # Flutter客户端
│   ├── lib/
│   │   ├── core/        # 主题、路由、工具
│   │   └── features/    # 功能模块
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
├── server/              # Cloudflare Workers后端
│   ├── src/
│   │   ├── routes/      # API路由
│   │   ├── db/          # 数据库操作
│   │   └── utils/       # 工具函数
│   ├── schema.sql       # 数据库表结构
│   └── wrangler.toml    # 部署配置
└── README.md
```

---

## 🔧 配置说明

### Cloudflare Workers
- `wrangler.toml` - Workers配置
- `schema.sql` - D1数据库模式
- 环境变量在Cloudflare控制台中设置

### Flutter客户端
- `pubspec.yaml` - 依赖管理
- `.env.example` - 环境变量模板
- 需要在 `android/app/src/main/kotlin/.../MainActivity.kt` 配置包名

---

## 📱 主要功能

- ✅ 全球电台列表浏览
- ✅ 实时音频播放 (HLS/HTTP)
- ✅ 国家/语言/类型筛选
- ✅ 收藏管理
- ✅ 后台播放（待实现）
- ✅ 多语言支持（待完善）
- ✅ 个性化推荐（待开发）

---

## 🛠️ 下一步开发计划

### MVP阶段 (v1.0)
- [ ] 完善API接口
- [ ] 实现just_audio播放器
- [ ] 集成Radio Garden数据源
- [ ] 添加离线缓存功能

### v1.1
- [ ] 定时关闭功能
- [ ] 评论系统
- [ ] 匿名反馈

### v2.0
- [ ] AI推荐算法
- [ ] 30+语言完整支持
- [ ] 多源切换和故障恢复
- [ ] 管理员后台

---

## ⚠️ 注意事项

1. Radio Garden API使用需确认商业用途授权
2. 电台流媒体地址的版权合规性
3. Android 12+需要通知权限用于后台播放
4. iOS需要Info.plist配置`UIBackgroundModes`

---

## 📄 License

MIT License
