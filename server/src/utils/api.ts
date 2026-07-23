import type { Env, ApiResult } from '../types';

/**
 * Fetch radio station data from Radio Garden API
 */
export async function fetchFromRadioGarden(): Promise<ApiResult> {
  try {
    // Note: Radio Garden API access requires proper authentication
    // This is a placeholder implementation
    const response = await fetch('https://radio.garden/api/regions');
    
    if (!response.ok) {
      return { success: false, message: `API error: ${response.status}` };
    }

    const data = await response.json();
    return { success: true, data };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}

/**
 * Validate stream URL accessibility
 */
export async function validateStreamUrl(url: string): Promise<boolean> {
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 5000);

    const response = await fetch(url, {
      method: 'HEAD',
      signal: controller.signal
    });

    clearTimeout(timeout);
    return response.ok;
  } catch (error) {
    return false;
  }
}

/**
 * Proxy media stream through Cloudflare CDN
 */
export async function proxyMediaStream(env: Env, streamUrl: string): Promise<Response> {
  try {
    const response = await fetch(streamUrl);
    
    if (!response.ok) {
      return new Response(JSON.stringify({
        success: false,
        message: `Stream unavailable: ${response.status}`
      }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    // Return the stream with appropriate CORS headers
    return new Response(response.body, {
      headers: {
        'Content-Type': response.headers.get('Content-Type') || 'audio/mpeg',
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'public, max-age=3600'
      }
    });
  } catch (error) {
    return new Response(JSON.stringify({
      success: false,
      message: 'Proxy error'
    }), {
      status: 502,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}
