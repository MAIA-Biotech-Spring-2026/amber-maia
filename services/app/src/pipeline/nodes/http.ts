import { registerNode } from '../engine.js';

registerNode('http.fetch', async (_input, cfg) => {
  const url = String((cfg as any).url);
  const method = String((cfg as any).method || 'GET');
  const headers = (cfg as any).headers || {};
  const body = (cfg as any).body;
  const res = await fetch(url, { method, headers, body: body ? JSON.stringify(body) : undefined });
  const text = await res.text();
  return { status: res.status, headers: Object.fromEntries(res.headers.entries()), body: text };
});




