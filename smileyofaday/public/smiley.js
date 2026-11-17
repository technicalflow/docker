// Smiley of a Day — server-side (njs) plain-text / JSON responses for curl.
// Rotation logic MUST stay in sync with public/app.js.
// Date = server local date (container TZ), or ?date=YYYY-MM-DD.

import fs from 'fs';

const EMOJI_FILE = '/usr/share/nginx/html/emojis.js';
const EPOCH = Date.UTC(2026, 0, 1);
const DAY_MS = 86400000;

// Reuse the browser list: take the JSON array after "window.EMOJIS ="
function loadEmojis() {
  const src = fs.readFileSync(EMOJI_FILE, 'utf8');
  return JSON.parse(src.slice(src.indexOf('= [') + 2, src.lastIndexOf(']') + 1));
}

function mulberry32(seed) {
  return function () {
    seed |= 0; seed = (seed + 0x6d2b79f5) | 0;
    let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function rawOrder(cycle, n) {
  const rand = mulberry32(0x5a11e + cycle * 7919);
  const order = [];
  for (let i = 0; i < n; i++) order.push(i);
  for (let i = n - 1; i > 0; i--) {
    const j = Math.floor(rand() * (i + 1));
    const tmp = order[i]; order[i] = order[j]; order[j] = tmp;
  }
  return order;
}

function cycleOrder(cycle, n) {
  const order = rawOrder(cycle, n);
  if (cycle > 0 && order[0] === rawOrder(cycle - 1, n)[n - 1]) {
    const tmp = order[0]; order[0] = order[1]; order[1] = tmp;
  }
  return order;
}

function pad(x) { return (x < 10 ? '0' : '') + x; }

function smileyFor(date) {
  const emojis = loadEmojis();
  const n = emojis.length;
  const d = Math.floor((Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()) - EPOCH) / DAY_MS);
  const pos = ((d % n) + n) % n;
  const idx = cycleOrder(Math.floor(d / n), n)[pos];
  const name = emojis[idx][1];
  return {
    date: date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate()),
    emoji: emojis[idx][0],
    name: name.charAt(0).toUpperCase() + name.slice(1),
    dayInCycle: pos + 1
  };
}

// Returns a Date, or null if ?date= is present but invalid
function requestDate(r) {
  const q = r.args.date;
  if (!q) return new Date();
  const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(q);
  if (!m) return null;
  const dt = new Date(+m[1], +m[2] - 1, +m[3]);
  return dt.getMonth() === +m[2] - 1 ? dt : null; // rejects e.g. 2026-02-31
}

function text(r) {
  const date = requestDate(r);
  r.headersOut['Content-Type'] = 'text/plain; charset=utf-8';
  if (!date) return r.return(400, 'Invalid date, use ?date=YYYY-MM-DD\n');
  const s = smileyFor(date);
  r.return(200, s.emoji + '\n');
}

function json(r) {
  const date = requestDate(r);
  r.headersOut['Content-Type'] = 'application/json; charset=utf-8';
  if (!date) return r.return(400, JSON.stringify({ error: 'Invalid date, use ?date=YYYY-MM-DD' }) + '\n');
  r.return(200, JSON.stringify(smileyFor(date)) + '\n');
}

export default { text, json };
