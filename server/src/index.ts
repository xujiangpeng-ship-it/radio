import { getStations } from './db/stations';
import type { Env, ApiResult } from '../types';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    if (request.method === 'OPTIONS') return new Response(null, { headers });

    try {
      if (url.pathname === '/health') {
        return new Response(JSON.stringify({ status: 'ok', timestamp: new Date().toISOString() }), { headers });
      }

      if (url.pathname.startsWith('/api/stations')) {
        const query: Record<string, string> = {};
        url.searchParams.forEach((value, key) => { query[key] = value; });
        const result: ApiResult = await getStations(env, query);
        return new Response(JSON.stringify(result), { headers });
      }

      return new Response(JSON.stringify({ success: false, message: 'Not found' }), { status: 404, headers });
    } catch (error) {
      console.error('Request error:', error);
      return new Response(JSON.stringify({ error: String(error) }), { status: 500, headers });
    }
  }
};
