// Smiley of a Day — daily rotation logic.
//
// Every block of 104 consecutive days is one "cycle". Each cycle uses its own
// seeded random shuffle of all 104 emojis, so the order looks random but
// every emoji appears exactly once before any emoji repeats. The shuffle is
// deterministic, so every visitor sees the same smiley on the same date,
// and no database or server state is needed.
// Rotation logic is mirrored server-side in public/smiley.js — keep in sync.

(function () {
  const EMOJIS = window.EMOJIS;
  const N = EMOJIS.length; // 104
  const EPOCH = Date.UTC(2026, 0, 1); // day 0 of the first cycle
  const DAY_MS = 86400000;
  const LOCALE = "en-US";

  // ---------- Rotation ----------

  // Small, fast seeded PRNG (mulberry32)
  function mulberry32(seed) {
    return function () {
      seed |= 0; seed = (seed + 0x6d2b79f5) | 0;
      let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
      t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }

  // Fisher–Yates shuffle of indices 0..N-1 for a given cycle
  function rawOrder(cycle) {
    const rand = mulberry32(0x5a11e + cycle * 7919);
    const order = Array.from({ length: N }, (_, i) => i);
    for (let i = N - 1; i > 0; i--) {
      const j = Math.floor(rand() * (i + 1));
      [order[i], order[j]] = [order[j], order[i]];
    }
    return order;
  }

  // Avoid the same emoji on the last day of one cycle and first day of the next
  function cycleOrder(cycle) {
    const order = rawOrder(cycle);
    if (cycle > 0) {
      const prevLast = rawOrder(cycle - 1)[N - 1];
      if (order[0] === prevLast) [order[0], order[1]] = [order[1], order[0]];
    }
    return order;
  }

  function dayIndex(date) {
    // Use the visitor's local calendar date
    const utcMidnight = Date.UTC(date.getFullYear(), date.getMonth(), date.getDate());
    return Math.floor((utcMidnight - EPOCH) / DAY_MS);
  }

  function smileyFor(date) {
    const d = dayIndex(date);
    const cycle = Math.floor(d / N);
    const pos = ((d % N) + N) % N;
    const idx = cycleOrder(cycle)[pos];
    return { emoji: EMOJIS[idx][0], name: EMOJIS[idx][1], dayInCycle: pos + 1, day: d };
  }

  // Expose for testing
  window.SmileyOfADay = { smileyFor, cycleOrder, dayIndex, N };

  if (typeof document === "undefined" || !document.getElementById("emoji")) return;

  // ---------- Page ----------

  let current = null;

  function render() {
    const now = new Date();
    current = smileyFor(now);

    document.getElementById("date").textContent = now.toLocaleDateString(LOCALE, {
      weekday: "long", year: "numeric", month: "long", day: "numeric"
    });
    const el = document.getElementById("emoji");
    el.textContent = current.emoji;
    el.style.animation = "none"; void el.offsetWidth; el.style.animation = "";
    document.getElementById("name").textContent = current.name;
    document.title = `${current.emoji} Smiley of a Day`;
  }

  function toast(text) {
    const t = document.getElementById("toast");
    t.textContent = text;
    t.classList.add("show");
    clearTimeout(toast.timer);
    toast.timer = setTimeout(() => t.classList.remove("show"), 2200);
  }

  let sharing = false;

  document.getElementById("share").addEventListener("click", async () => {
    if (sharing) return; // ignore double clicks while the share sheet is open
    const name = current.name.charAt(0).toUpperCase() + current.name.slice(1);
    const text = `Today's Smiley of a Day: ${current.emoji} ${name}`;

    // Only real web links can go to the system share menu. A file:// or
    // preview-pane address makes Chrome on macOS kill the page.
    const isWeb = location.protocol === "http:" || location.protocol === "https:";
    const url = isWeb ? location.origin + location.pathname : "";
    const data = isWeb ? { title: "Smiley of a Day", text, url } : null;

    if (data && navigator.share && (!navigator.canShare || navigator.canShare(data))) {
      sharing = true;
      try {
        await navigator.share(data);
        return;
      } catch (e) {
        if (e && e.name === "AbortError") return; // user closed the share menu
        // any other error: fall through to copying
      } finally {
        sharing = false;
      }
    }

    // Fallback: copy to clipboard
    const copyText = url ? `${text} ${url}` : text;
    try {
      await navigator.clipboard.writeText(copyText);
      toast("Copied to clipboard 📋");
    } catch (e) {
      toast("Sharing isn't available here");
    }
  });

  function updateCountdown() {
    const now = new Date();
    const next = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
    const ms = next - now;
    const h = Math.floor(ms / 3600000);
    const m = Math.floor((ms % 3600000) / 60000);
    const sec = Math.floor((ms % 60000) / 1000);
    document.getElementById("countdown").textContent =
      `Next smiley in ${h}h ${String(m).padStart(2, "0")}m ${String(sec).padStart(2, "0")}s`;
    if (ms < 1000) setTimeout(render, ms + 50);
  }

  // Little "boop" animation when the emoji is clicked
  document.getElementById("emoji").addEventListener("click", (e) => {
    const el = e.currentTarget;
    el.classList.remove("boop");
    void el.offsetWidth;
    el.classList.add("boop");
  });

  render();
  updateCountdown();
  setInterval(updateCountdown, 1000);
})();
