import { getStations, getStationById } from '../db/stations';
import type { Env, ApiResult } from '../types';

export async function GET(request: Request, env: Env): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname;

  // Health check
  if (path === '/health') {
    return Response.json({ status: 'ok', timestamp: new Date().toISOString() });
  }

  // Get stations list
  if (path === '/api/stations') {
    const params = Object.fromEntries(url.searchParams);
    const result = await getStations(env, params);
    return jsonResponse(result as any);
  }

  // Get single station
  if (path.startsWith('/api/stations/')) {
    const id = path.split('/').pop();
    const result = await getStationById(env, id!);
    return jsonResponse(result as any);
  }

  // Media proxy
  if (path === '/proxy/stream') {
    const streamUrl = url.searchParams.get('url');
    if (!streamUrl) {
      return jsonResponse({ success: false, message: 'Missing stream URL' }, 400);
    }
    
    try {
      const response = await fetch(streamUrl);
      if (!response.ok) {
        return jsonResponse({ success: false, message: 'Stream unavailable' }, 404);
      }
      
      return new Response(response.body, {
        headers: {
          'Content-Type': response.headers.get('Content-Type') || 'audio/mpeg',
          'Access-Control-Allow-Origin': '*',
          'Cache-Control': 'public, max-age=3600'
        }
      });
    } catch (error) {
      return jsonResponse({ success: false, message: 'Proxy error' }, 502);
    }
  }

  return jsonResponse({ success: false, message: 'Not found' }, 404);
}

function jsonResponse(data: any, status: number = 200): Response {
  return Response.json(data, { status });
}
