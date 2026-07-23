export interface Env {
  DB: D1Database;
  RADIO_GARDEN_API_KEY?: string;
  CDN_BASE_URL?: string;
}

export interface Station {
  id: string;
  name: string;
  country: string;
  language: string;
  url: string;
  stream_url: string | null;
  genre: string;
  description: string | null;
  logo_url: string | null;
  bit_rate: number;
  is_favorite: boolean;
  last_checked_at: string | null;
}

export interface ApiResult<T = unknown> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}
