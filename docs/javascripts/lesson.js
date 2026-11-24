// Interactive pieces for the lesson site: SQL playgrounds, quizzes, exercise check-off and progress.
// The markdown stays plain and readable on GitHub; this script only upgrades it on the site.

const STORE_KEY = "dbt-fundamentals-progress";
const DUCKDB_WASM = "https://cdn.jsdelivr.net/npm/@duckdb/duckdb-wasm@1.29.0/+esm";
const MAX_ROWS = 100;

// ---------- progress store ----------

function loadProgress() {
  try {
    return JSON.parse(localStorage.getItem(STORE_KEY)) || {};
  } catch {
    return {};
  }
}

function saveProgress(progress) {
  try {
    localStorage.setItem(STORE_KEY, JSON.stringify(progress));
  } catch {
    // Private mode or blocked storage: the page still works, progress just isn't kept.
  }
}

function updatePage(key, change) {
  const progress = loadProgress();
  progress[key] = change(progress[key] || {});
  saveProgress(progress);
}

// Material sets __md_scope to the site root, so keys work under any base path.
function siteRoot() {
  try {
    return new URL(__md_scope);
  } catch {
    return new URL("/", location);
  }
}

function pageKey(href = location.href) {
  const path = new URL(href, location).pathname;
  const base = siteRoot().pathname;
  return (path.startsWith(base) ? path.slice(base.length) : path).replace(/index\.html$/, "");
}

function pageStatus(state) {
  if (!state) return "todo";
  const quizTotal = state.quizTotal || 0;
  const quizRight = Object.values(state.quiz || {}).filter(Boolean).length;
  const tracked = quizTotal > 0 || state.hasExercise;
  const done = tracked && quizRight >= quizTotal && (!state.hasExercise || state.exercise);
  if (done) return "done";
  return quizRight || state.exercise || state.visited ? "started" : "todo";
}

// ---------- quizzes ----------

function initQuizzes(root, key) {
  const quizzes = [...root.querySelectorAll(".quiz")];
  if (!quizzes.length) return;
  updatePage(key, (s) => ({ ...s, visited: true, quizTotal: quizzes.length }));
  const saved = (loadProgress()[key] || {}).quiz || {};

  quizzes.forEach((quiz, qi) => {
    const answer = Number(quiz.dataset.answer);
    const list = quiz.querySelector(":scope > ul, :scope > ol");
    if (!list || !answer) return;
    const options = [...list.children];
    const explain = quiz.querySelector(":scope > details");
    const feedback = document.createElement("p");
    feedback.className = "quiz-feedback";
    feedback.setAttribute("aria-live", "polite");
    list.after(feedback);
    if (explain) explain.hidden = true;

    const solve = (li, announce) => {
      quiz.classList.add("solved");
      li.classList.add("correct");
      li.setAttribute("aria-pressed", "true");
      feedback.textContent = announce ? "Correct." : "Answered.";
      if (explain) {
        explain.hidden = false;
        explain.open = announce;
      }
    };

    options.forEach((li, i) => {
      li.classList.add("quiz-option");
      li.tabIndex = 0;
      li.setAttribute("role", "button");
      li.setAttribute("aria-pressed", "false");
      const choose = () => {
        if (quiz.classList.contains("solved")) return;
        if (i + 1 === answer) {
          solve(li, true);
          updatePage(key, (s) => ({ ...s, quiz: { ...(s.quiz || {}), [qi]: true } }));
          refreshNav();
        } else {
          li.classList.add("wrong");
          feedback.textContent = "Not quite. Try another option, or open the answer.";
          if (explain) explain.hidden = false;
        }
      };
      li.addEventListener("click", choose);
      li.addEventListener("keydown", (e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          choose();
        }
      });
    });

    if (saved[qi] && options[answer - 1]) solve(options[answer - 1], false);
  });
}

// ---------- exercises ----------

function initExercise(root, key) {
  const answers = [...root.querySelectorAll("details")].filter(
    (d) => !d.closest(".quiz") && d.querySelector("summary")?.textContent.trim() === "Answer"
  );
  if (!answers.length) return;
  updatePage(key, (s) => ({ ...s, visited: true, hasExercise: true }));

  const button = document.createElement("button");
  button.type = "button";
  button.className = "md-button exercise-done";
  const render = () => {
    const done = !!(loadProgress()[key] || {}).exercise;
    button.textContent = done ? "✓ Exercise done" : "Mark exercise done";
    button.classList.toggle("md-button--primary", done);
    button.setAttribute("aria-pressed", String(done));
  };
  button.addEventListener("click", () => {
    updatePage(key, (s) => ({ ...s, exercise: !s.exercise }));
    render();
    refreshNav();
  });
  answers[answers.length - 1].after(button);
  render();
}

// ---------- progress display ----------

const STATUS_LABEL = { done: "✓ Done", started: "In progress", todo: "Not started" };

function initProgressMap(root) {
  const badges = [...root.querySelectorAll("[data-progress]")];
  if (!badges.length) return;
  const progress = loadProgress();
  let done = 0;
  badges.forEach((badge) => {
    const href = badge.closest("tr, li")?.querySelector("a[href]")?.href;
    const status = href ? pageStatus(progress[pageKey(href)]) : "todo";
    if (status === "done") done += 1;
    badge.className = `progress-badge progress-${status}`;
    badge.textContent = STATUS_LABEL[status];
  });

  const bar = root.querySelector(".progress-overall");
  if (bar) {
    const pct = Math.round((done / badges.length) * 100);
    bar.innerHTML = `
      <div class="progress-track" role="progressbar" aria-valuemin="0" aria-valuemax="${badges.length}"
           aria-valuenow="${done}" aria-label="Lessons done"><div class="progress-fill" style="width:${pct}%"></div></div>
      <p>${done} of ${badges.length} lessons done.
        <button type="button" class="progress-reset">Reset progress</button></p>`;
    bar.querySelector(".progress-reset").addEventListener("click", () => {
      if (confirm("Clear all quiz answers and exercise check-offs saved in this browser?")) {
        saveProgress({});
        location.reload();
      }
    });
  }
}

function refreshNav() {
  const progress = loadProgress();
  document.querySelectorAll(".md-nav__link[href]").forEach((link) => {
    link.classList.toggle("lesson-done", pageStatus(progress[pageKey(link.href)]) === "done");
  });
}

// ---------- SQL playground (DuckDB-WASM) ----------

let connection;

function getConnection(onStatus) {
  connection ??= (async () => {
    onStatus("Loading DuckDB in your browser. The first run takes a few seconds…");
    const duckdb = await import(DUCKDB_WASM);
    const bundle = await duckdb.selectBundle(duckdb.getJsDelivrBundles());
    const workerUrl = URL.createObjectURL(
      new Blob([`importScripts("${bundle.mainWorker}");`], { type: "text/javascript" })
    );
    const db = new duckdb.AsyncDuckDB(new duckdb.VoidLogger(), new Worker(workerUrl));
    await db.instantiate(bundle.mainModule, bundle.pthreadWorker);
    URL.revokeObjectURL(workerUrl);
    await db.open({ query: { castBigIntToDouble: true, castDecimalToDouble: true, castTimestampToDate: true } });

    // Build the raw tables with the same script load_raw.py runs, so the browser matches raw.duckdb.
    onStatus("Loading the jaffle_shop raw data…");
    const dataUrl = (name) => new URL(`data/${name}`, siteRoot()).href;
    const script = await (await fetch(dataUrl("raw_data.sql"))).text();
    for (const path of new Set(script.match(/data\/[\w.-]+\.csv/g))) {
      const csv = await (await fetch(dataUrl(path.slice("data/".length)))).text();
      await db.registerFileText(path, csv);
    }
    const conn = await db.connect();
    await conn.query("attach ':memory:' as raw");
    await conn.query("use raw");
    const statements = script
      .split(";")
      .map((s) => s.trim())
      .filter((s) => s && !s.toLowerCase().startsWith("select"));
    for (const statement of statements) await conn.query(statement);
    return conn;
  })();
  connection.catch(() => (connection = undefined));
  return connection;
}

function formatValue(value, type) {
  if (value === null || value === undefined) return "NULL";
  if (/^(Date|Timestamp)/.test(String(type))) {
    const iso = new Date(value).toISOString();
    return iso.endsWith("T00:00:00.000Z") ? iso.slice(0, 10) : iso.replace("T", " ").replace(/\.000Z$|Z$/, "");
  }
  if (typeof value === "number") return Number.isInteger(value) ? String(value) : String(Math.round(value * 1e6) / 1e6);
  if (typeof value === "object") return JSON.stringify(value, (_, v) => (typeof v === "bigint" ? v.toString() : v));
  return String(value);
}

function renderTable(table) {
  const fields = table.schema.fields;
  const rows = table.toArray();
  const wrap = document.createElement("div");
  wrap.className = "playground-table";
  const el = document.createElement("table");
  const head = el.createTHead().insertRow();
  fields.forEach((f) => {
    const th = document.createElement("th");
    th.textContent = f.name;
    head.appendChild(th);
  });
  const body = el.createTBody();
  rows.slice(0, MAX_ROWS).forEach((row) => {
    const tr = body.insertRow();
    fields.forEach((f) => {
      const value = row[f.name];
      tr.insertCell().textContent = formatValue(value, f.type);
    });
  });
  wrap.appendChild(el);
  return { node: wrap, count: rows.length };
}

function initPlaygrounds(root) {
  root.querySelectorAll(".sql-playground").forEach((box) => {
    const code = box.querySelector("pre code");
    if (!code || box.dataset.ready) return;
    box.dataset.ready = "1";
    const starter = code.textContent.replace(/\n$/, "");
    const expectRows = box.dataset.expectRows;

    const editor = document.createElement("textarea");
    editor.className = "playground-editor";
    editor.spellcheck = false;
    editor.setAttribute("aria-label", "SQL query");
    editor.value = starter;
    editor.rows = Math.max(3, starter.split("\n").length + 1);

    const run = document.createElement("button");
    run.type = "button";
    run.className = "md-button md-button--primary";
    run.textContent = "▶ Run";
    const reset = document.createElement("button");
    reset.type = "button";
    reset.className = "md-button";
    reset.textContent = "Reset";
    const hint = document.createElement("span");
    hint.className = "playground-hint";
    hint.textContent = "Ctrl/⌘ + Enter to run";
    const bar = document.createElement("div");
    bar.className = "playground-bar";
    bar.append(run, reset, hint);

    const status = document.createElement("p");
    status.className = "playground-status";
    status.setAttribute("aria-live", "polite");
    const output = document.createElement("div");
    output.className = "playground-output";

    box.querySelector(".highlight, pre").replaceWith(editor);
    box.append(bar, status, output);

    const execute = async () => {
      run.disabled = true;
      output.replaceChildren();
      status.className = "playground-status";
      try {
        const conn = await getConnection((msg) => (status.textContent = msg));
        status.textContent = "Running…";
        const started = performance.now();
        const { node, count } = renderTable(await conn.query(editor.value));
        const ms = Math.round(performance.now() - started);
        const shown = count > MAX_ROWS ? `, showing the first ${MAX_ROWS}` : "";
        status.textContent = `${count} row${count === 1 ? "" : "s"}${shown} · ${ms} ms`;
        if (expectRows !== undefined) {
          const pass = count === Number(expectRows);
          status.textContent += pass ? ` · ✓ Check passed` : ` · ✗ Expected ${expectRows} rows`;
          status.classList.add(pass ? "playground-pass" : "playground-fail");
        }
        output.appendChild(node);
      } catch (err) {
        status.textContent = "Error";
        status.classList.add("playground-fail");
        const pre = document.createElement("pre");
        pre.className = "playground-error";
        pre.textContent = String(err.message || err);
        output.appendChild(pre);
      } finally {
        run.disabled = false;
      }
    };

    run.addEventListener("click", execute);
    reset.addEventListener("click", () => {
      editor.value = starter;
      output.replaceChildren();
      status.textContent = "";
    });
    editor.addEventListener("keydown", (e) => {
      if (e.key === "Enter" && (e.metaKey || e.ctrlKey)) {
        e.preventDefault();
        execute();
      }
    });
  });
}

// ---------- boot ----------

function init() {
  const root = document.querySelector(".md-content") || document.body;
  const key = pageKey();
  initPlaygrounds(root);
  initQuizzes(root, key);
  initExercise(root, key);
  initProgressMap(root);
  refreshNav();
}

// Material's instant navigation swaps pages without a reload; document$ fires on each one.
if (window.document$) document$.subscribe(init);
else document.addEventListener("DOMContentLoaded", init);
