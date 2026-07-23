import type { Env, ApiResult, Station } from '../types';

export async function getStations(env: Env, params: Record<string, any> = {}): Promise<ApiResult> {
  try {
    const limit = parseInt(params.limit || '50');
    const offset = parseInt(params.offset || '0');
    let query = `SELECT * FROM stations WHERE 1=1`;
    const placeholders: (string | number)[] = [];

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
    placeholders.push(limit, offset);

    const result = await env.DB.prepare(query).bind(...placeholders).all<Station>();

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
