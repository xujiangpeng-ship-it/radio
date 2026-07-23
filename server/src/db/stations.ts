import type { Env, ApiResult } from '../types';

/**
 * Get all radio stations with optional filtering
 */
export async function getStations(
  env: Env,
  params: {
    country?: string;
    language?: string;
    genre?: string;
    search?: string;
    limit?: number;
    offset?: number;
    user_id?: string;
  } = {}
): Promise<ApiResult> {
  try {
    let query = `SELECT * FROM stations WHERE 1=1`;
    const placeholders: string[] = [];

    if (params.country) {
      query += ` AND country = ?`;
      placeholders.push(params.country);
    }
    if (params.language) {
      query += ` AND language = ?`;
      placeholders.push(params.language);
    }
    if (params.genre) {
      query += ` AND genre = ?`;
      placeholders.push(params.genre);
    }
    if (params.search) {
      query += ` AND (name LIKE ? OR description LIKE ?)`;
      placeholders.push(`%${params.search}%`, `%${params.search}%`);
    }

    query += ` ORDER BY name ASC LIMIT ? OFFSET ?`;
    placeholders.push(params.limit || 50, params.offset || 0);

    const result = await env.DB.prepare(query).bind(...placeholders).all<Station>();

    // If user_id provided, mark favorites
    if (params.user_id && result.results) {
      const favResult = await env.DB.prepare(
        `SELECT station_id FROM user_favorites WHERE user_id = ?`
      ).bind(params.user_id).all();

      if (favResult.results) {
        const favIds = new Set(favResult.results.map((f: any) => f.station_id));
        result.results.forEach((s: Station) => {
          s.is_favorite = favIds.has(s.id);
        });
      }
    }

    return { success: true, data: result.results };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}

/**
 * Get a single station by ID
 */
export async function getStationById(env: Env, id: string): Promise<ApiResult<Station>> {
  try {
    const result = await env.DB.prepare(
      `SELECT * FROM stations WHERE id = ?`
    ).bind(id).first<Station>();

    if (!result) {
      return { success: false, message: 'Station not found' };
    }

    return { success: true, data: result };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}

/**
 * Add station to favorites
 */
export async function addToFavorites(env: Env, userId: string, stationId: string): Promise<ApiResult> {
  try {
    await env.DB.prepare(
      `INSERT OR IGNORE INTO user_favorites (user_id, station_id) VALUES (?, ?)`
    ).bind(userId, stationId).run();

    return { success: true, message: 'Added to favorites' };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}

/**
 * Remove station from favorites
 */
export async function removeFromFavorites(env: Env, userId: string, stationId: string): Promise<ApiResult> {
  try {
    await env.DB.prepare(
      `DELETE FROM user_favorites WHERE user_id = ? AND station_id = ?`
    ).bind(userId, stationId).run();

    return { success: true, message: 'Removed from favorites' };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}

/**
 * Get user's favorite stations
 */
export async function getUserFavorites(env: Env, userId: string): Promise<ApiResult> {
  try {
    const result = await env.DB.prepare(`
      SELECT s.* FROM stations s
      JOIN user_favorites f ON s.id = f.station_id
      WHERE f.user_id = ?
      ORDER BY f.created_at DESC
    `).bind(userId).all<Station>();

    return { success: true, data: result.results };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}

/**
 * Add comment to station
 */
export async function addComment(env: Env, userId: string, stationId: string, content: string, rating: number = 5): Promise<ApiResult> {
  try {
    await env.DB.prepare(
      `INSERT INTO comments (user_id, station_id, content, rating) VALUES (?, ?, ?, ?)`
    ).bind(userId, stationId, content, rating).run();

    return { success: true, message: 'Comment added' };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}

/**
 * Get comments for a station
 */
export async function getComments(env: Env, stationId: string): Promise<ApiResult> {
  try {
    const result = await env.DB.prepare(`
      SELECT c.*, u.nickname, u.avatar_url 
      FROM comments c
      LEFT JOIN users u ON c.user_id = u.id
      WHERE c.station_id = ?
      ORDER BY c.created_at DESC
      LIMIT 50
    `).bind(stationId).all();

    return { success: true, data: result.results };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}
