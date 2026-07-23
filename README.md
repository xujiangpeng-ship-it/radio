## Global Broadcast App (全球广播APP)

A Flutter-based global radio streaming app with Cloudflare Workers backend. Listen to 30,000+ radio stations worldwide with real-time playback, personalized recommendations, multi-language support, and background listening.

### 🚀 Tech Stack

| Layer | Technology |
|-------|-----------|
| Client | Flutter (Dart) |
| Backend | Cloudflare Workers |
| Database | Cloudflare D1 |
| Audio | just_audio + chewie |
| CDN | Cloudflare |
| Auth | Supabase / Firebase |

### 📁 Project Structure

```
├── client/               # Flutter mobile app
│   ├── lib/              # Dart source code
│   ├── android/          # Android platform files
│   └── ios/              # iOS platform files
├── server/               # Cloudflare Workers backend
│   ├── src/
│   │   ├── routes/       # API route handlers
│   │   ├── db/           # Database operations (D1)
│   │   ├── middleware/   # Request middleware
│   │   └── utils/        # Utilities
│   ├── tests/            # Unit tests
│   └── wrangler.toml     # Cloudflare Workers config
├── docs/                 # Documentation
└── README.md
```

### 🛠️ Getting Started

#### Prerequisites
- Node.js 20+ / npm 9+
- Flutter SDK 3.0+
- Wrangler CLI (`npm i -g wrangler`)
- Cloudflare account

#### Backend Setup

```bash
cd server
npm install
wrangler auth login
wrangler d1 create radio-stations
wrangler d1 execute radio-stations --file=./schema.sql
wrangler deploy
```

#### Frontend Setup

```bash
cd client
flutter create .
flutter pub get
flutter run
```

### 📋 Features (MVP v1)

- [x] Global radio station list
- [x] Real-time audio playback (HLS/HTTP)
- [x] Search & filter by country/language
- [x] Favorites management
- [x] Background playback
- [ ] Personalized recommendations
- [ ] Multi-language support (30+)
- [ ] Comments & feedback
- [ ] Timer sleep mode
- [ ] Offline caching

### 🔧 Environment Variables

Create `.env` in `server/`:

```env
CLOUDFLARE_API_TOKEN=your_token
CLOUDFLARE_ACCOUNT_ID=your_account_id
```

### 📄 License

MIT
