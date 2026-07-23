# Global Broadcast App - Backend Setup Guide

## Prerequisites
- Node.js 20+
- npm or yarn
- Wrangler CLI: `npm i -g wrangler`
- Cloudflare account

## Setup Steps

### 1. Install Dependencies

```bash
cd server
npm install
```

### 2. Login to Cloudflare

```bash
wrangler auth login
```

### 3. Create D1 Database

```bash
wrangler d1 create radio-stations
```

This will output a database ID. Copy it and update `wrangler.toml`:

```toml
[[d1_databases]]
binding = "DB"
database_name = "radio-stations"
database_id = "YOUR_DATABASE_ID_HERE"
```

### 4. Initialize Schema

```bash
wrangler d1 execute radio-stations --file=./schema.sql
```

### 5. Test Locally

```bash
npm run dev
```

Visit `http://localhost:8787/health`

### 6. Deploy

```bash
npm run deploy
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /health | Health check |
| GET | /api/stations | Get all stations (with filters) |
| GET | /api/stations/:id | Get single station |
| POST | /api/favorites | Add to favorites |
| DELETE | /api/favorites | Remove from favorites |
| GET | /api/comments | Get comments |
| POST | /api/comments | Add comment |
| GET | /proxy/stream?url=... | Proxy media stream |

## Query Parameters for /api/stations

- `country` - Filter by country
- `language` - Filter by language
- `genre` - Filter by genre
- `search` - Search station name/description
- `limit` - Number of results (default: 50)
- `offset` - Pagination offset
- `user_id` - User ID for marking favorites
