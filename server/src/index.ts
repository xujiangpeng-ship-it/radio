import { handleRequest } from './routes';

export default {
  async fetch(request: Request): Promise<Response> {
    return handleRequest(request);
  }
};
