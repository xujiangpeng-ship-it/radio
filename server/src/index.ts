import type { Env } from '../types';
import type { ApiResult, Station } from '../types';

export async function handleRequest(request: Request): Promise<Response> {
  const url = new URL(request.url);
  const env: Env = globalThis as any;

  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };

  if (request.method === 'OPTIONS') return new Response(null, { headers });

  try {
    // Health check
    if (url.pathname === '/health') {
      return new Response(JSON.stringify({ status: 'ok', timestamp: new Date().toISOString() }), { headers });
    }

    // Get stations list
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
