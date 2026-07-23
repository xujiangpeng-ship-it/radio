-- Radio Station Database Schema for Cloudflare D1

CREATE TABLE IF NOT EXISTS stations (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  country TEXT,
  language TEXT,
  url TEXT NOT NULL,
  stream_url TEXT,
  genre TEXT,
  description TEXT,
  logo_url TEXT,
  bit_rate INTEGER DEFAULT 128,
  is_favorite BOOLEAN DEFAULT 0,
  last_checked_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_favorites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL,
  station_id TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (station_id) REFERENCES stations(id),
  UNIQUE(user_id, station_id)
);

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  nickname TEXT,
  avatar_url TEXT,
  locale TEXT DEFAULT 'zh',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS comments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL,
  station_id TEXT NOT NULL,
  content TEXT NOT NULL,
  rating INTEGER DEFAULT 5,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (station_id) REFERENCES stations(id)
);

CREATE INDEX idx_stations_country ON stations(country);
CREATE INDEX idx_stations_language ON stations(language);
CREATE INDEX idx_stations_genre ON stations(genre);
CREATE INDEX idx_favorites_user ON user_favorites(user_id);
