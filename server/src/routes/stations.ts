import { getStations, getStationById } from '../db/stations';
import type { Env, ApiResult } from '../types';

const corsHeaders: Record<string, string> = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

export async function GET(request: Request, env: Env): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname;

  // CORS preflight
  if (request.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  // Health check
  if (path === '/health') {
    return jsonResponse({ status: 'ok', timestamp: new Date().toISOString() });
  }

  // Get stations list
  if (path === '/api/stations') {
    const params = Object.fromEntries(url.searchParams);
    const result = await getStations(env, params as any);
    return jsonResponse(result as any);
  }

  // Get single station
  if (path.startsWith('/api/stations/')) {
    const id = path.split('/').pop();
    const result = await getStationById(env, id!);
    return jsonResponse(result as any);
  }

  return jsonResponse({ success: false, message: 'Not found' }, 404);
}

function jsonResponse(data: any, status: number = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json', ...corsHeaders }
  });
}
