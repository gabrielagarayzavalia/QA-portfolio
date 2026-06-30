let jobs = [];
let selectedId = null;
let sortOrder = "desc";
let hideRejected = true;
/** @type {Set<string>} */
let rejectedIds = new Set();
/** @type {Map<string, { reason?: string; rejectedAt: string }>} */
let rejectionMeta = new Map();

const els = {
  headerStats: document.getElementById("header-stats"),
  jobList: document.getElementById("job-list"),
  sortSelect: document.getElementById("sort-select"),
  hideRejected: document.getElementById("hide-rejected"),
  detailEmpty: document.getElementById("detail-empty"),
  detailContent: document.getElementById("detail-content"),
  listEmpty: document.getElementById("list-empty"),
  listError: document.getElementById("list-error"),
};

function matchClass(pct) {
  if (pct >= 85) return "match-badge__pct--high";
  if (pct >= 75) return "match-badge__pct--mid";
  return "match-badge__pct--low";
}

function isRejected(jobId) {
  return rejectedIds.has(jobId);
}

function visibleJobs() {
  let list = [...jobs];
  if (hideRejected) list = list.filter((j) => !isRejected(j.id));
  return list.sort((a, b) =>
    sortOrder === "desc" ? b.matchPercent - a.matchPercent : a.matchPercent - b.matchPercent
  );
}

function renderHeader(result) {
  const date = new Date(result.scrapedAt).toLocaleString("es-AR");
  const visible = visibleJobs().length;
  const fbCount = rejectedIds.size;
  const fbLine =
    fbCount > 0
      ? `<span class="header-feedback">Aprendizaje: <strong>${fbCount}</strong> incorrecto(s)</span>`
      : "";
  els.headerStats.innerHTML = `
    <span>Fecha: <strong>${date}</strong></span>
    <span>Analizados: <strong>${result.totalAnalyzed}</strong></span>
    <span>Visibles: <strong>${visible}</strong> / ${result.matchedJobs.length}</span>
    ${fbLine}
  `;
}

function renderList() {
  const list = visibleJobs();
  els.jobList.innerHTML = "";

  if (jobs.length === 0) {
    els.listEmpty.classList.remove("hidden");
    els.listEmpty.hidden = false;
    return;
  }

  if (list.length === 0) {
    els.listEmpty.classList.remove("hidden");
    els.listEmpty.hidden = false;
    els.listEmpty.querySelector("p").textContent =
      hideRejected && rejectedIds.size > 0
        ? "Todos los empleos visibles fueron marcados como incorrectos."
        : "No hay empleos con 70%+ de match.";
    return;
  }

  els.listEmpty.classList.add("hidden");
  els.listEmpty.hidden = true;

  for (const job of list) {
    const rejected = isRejected(job.id);
    const li = document.createElement("li");
    li.className =
      "job-item" + (job.id === selectedId ? " active" : "") + (rejected ? " rejected" : "");
    li.dataset.id = job.id;
    li.tabIndex = 0;
    const pctClass = matchClass(job.matchPercent);
    const colorVar =
      job.matchPercent >= 85 ? "match-high" : job.matchPercent >= 75 ? "match-mid" : "match-low";
    const rejectedBadge = rejected ? `<span class="badge-rejected">Match incorrecto</span>` : "";

    li.innerHTML = `
      <div class="match-badge">
        <span class="match-badge__pct ${pctClass}">${job.matchPercent}%</span>
        <div class="match-bar" style="color: var(--${colorVar})">
          <div class="match-bar__fill" style="width: ${job.matchPercent}%"></div>
        </div>
      </div>
      <div>
        <p class="job-item__title">${escapeHtml(job.title)}</p>
        <p class="job-item__company">${escapeHtml(job.company)}</p>
        <p class="job-item__meta">${escapeHtml(job.modality)} · ${escapeHtml(job.datePosted)}</p>
        ${rejectedBadge}
      </div>`;

    li.addEventListener("click", () => selectJob(job.id));
    li.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        selectJob(job.id);
      }
    });
    els.jobList.appendChild(li);
  }
}

function selectJob(id) {
  selectedId = id;
  renderList();
  renderHeader({ scrapedAt: window.__scrapedAt, totalAnalyzed: window.__totalAnalyzed, matchedJobs: jobs });
  const job = jobs.find((j) => j.id === id);
  if (job) renderDetail(job);
}

function renderDetail(job) {
  els.detailEmpty.classList.add("hidden");
  els.detailEmpty.hidden = true;
  els.detailContent.classList.remove("hidden");
  els.detailContent.hidden = false;

  const pctClass = matchClass(job.matchPercent);
  const rejected = isRejected(job.id);
  const meta = rejectionMeta.get(job.id);

  const gapsBlock =
    job.gaps?.length && job.gaps[0] !== "Ninguno"
      ? `<section class="detail__section"><h3>Gaps</h3><ul class="detail__list">${listItems(job.gaps)}</ul></section>`
      : "";

  const feedbackBlock = rejected
    ? `<section class="feedback-section">
        <p class="feedback-done">Marcado como <strong>match incorrecto</strong>${meta?.reason ? `: ${escapeHtml(meta.reason)}` : ""}</p>
        <p class="feedback-learn">El próximo análisis usará este feedback para ser más estricto con ofertas similares.</p>
        <div class="feedback-actions">
          <button type="button" class="btn btn--ghost" id="btn-undo-reject">Deshacer — restaurar en lista</button>
        </div>
      </section>`
    : `<section class="feedback-section">
        <h3>¿El match es incorrecto?</h3>
        <p>Ayudá al sistema a aprender: el próximo análisis será más estricto con ofertas parecidas.</p>
        <textarea class="feedback-reason" id="feedback-reason" placeholder="Opcional: ¿por qué no aplica? (ej. es Mobile Engineer, no QA)"></textarea>
        <div class="feedback-actions">
          <button type="button" class="btn btn--danger" id="btn-reject-match">Match incorrecto</button>
        </div>
      </section>`;

  els.detailContent.innerHTML = `
    <header class="detail__header">
      <div class="detail__match"><span class="match-badge__pct ${pctClass}">${job.matchPercent}% match</span></div>
      <h1 class="detail__title">${escapeHtml(job.title)}</h1>
      <p class="detail__company">${escapeHtml(job.company)}</p>
      <div class="detail__meta">
        <span>${escapeHtml(job.location)}</span>
        <span>${escapeHtml(job.modality)}</span>
        <span>${escapeHtml(job.datePosted)}</span>
        <span>Búsqueda: ${escapeHtml(job.searchTerm)}</span>
      </div>
      <a class="detail__link" href="${escapeAttr(job.url)}" target="_blank" rel="noopener noreferrer">Ver en LinkedIn →</a>
    </header>
    ${feedbackBlock}
    <section class="detail__section"><h3>Descripción del puesto</h3><div class="detail__description">${escapeHtml(job.description)}</div></section>
    <section class="detail__section"><h3>Skills que coinciden</h3><ul class="detail__list">${listItems(job.matchedSkills)}</ul></section>
    ${gapsBlock}
    <section class="detail__section"><h3>Sugerencias para el CV</h3><ul class="detail__list">${listItems(job.cvSuggestions)}</ul></section>
    <section class="detail__section"><h3>Resumen del análisis</h3><p class="detail__summary">${escapeHtml(job.summary)}</p></section>`;

  if (rejected) {
    document.getElementById("btn-undo-reject")?.addEventListener("click", () => undoReject(job));
  } else {
    document.getElementById("btn-reject-match")?.addEventListener("click", () => rejectMatch(job));
  }
}

async function rejectMatch(job) {
  const reason = document.getElementById("feedback-reason")?.value?.trim() || undefined;
  try {
    const res = await fetch("/api/feedback/reject", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        jobId: job.id,
        title: job.title,
        company: job.company,
        searchTerm: job.searchTerm,
        matchPercent: job.matchPercent,
        reason,
      }),
    });
    if (!res.ok) throw new Error("No se pudo guardar el feedback");
    applyFeedback(await res.json());
    const next = visibleJobs()[0];
    if (next && next.id !== job.id) selectJob(next.id);
    else {
      renderList();
      renderHeader({ scrapedAt: window.__scrapedAt, totalAnalyzed: window.__totalAnalyzed, matchedJobs: jobs });
      renderDetail(job);
    }
  } catch (e) {
    alert(String(e.message ?? e));
  }
}

async function undoReject(job) {
  try {
    const res = await fetch(`/api/feedback/reject/${encodeURIComponent(job.id)}`, { method: "DELETE" });
    if (!res.ok) throw new Error("No se pudo deshacer");
    applyFeedback(await res.json());
    renderList();
    renderHeader({ scrapedAt: window.__scrapedAt, totalAnalyzed: window.__totalAnalyzed, matchedJobs: jobs });
    renderDetail(job);
  } catch (e) {
    alert(String(e.message ?? e));
  }
}

function applyFeedback(store) {
  rejectedIds = new Set(store.rejections.map((r) => r.jobId));
  rejectionMeta = new Map(
    store.rejections.map((r) => [r.jobId, { reason: r.reason, rejectedAt: r.rejectedAt }])
  );
}

function listItems(arr) {
  if (!arr?.length) return "<li>—</li>";
  return arr.map((s) => `<li>${escapeHtml(s)}</li>`).join("");
}

function escapeHtml(text) {
  const d = document.createElement("div");
  d.textContent = text ?? "";
  return d.innerHTML;
}

function escapeAttr(text) {
  return (text ?? "").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
}

async function init() {
  els.sortSelect.addEventListener("change", () => {
    sortOrder = els.sortSelect.value;
    renderList();
  });

  els.hideRejected.addEventListener("change", () => {
    hideRejected = els.hideRejected.checked;
    renderList();
    renderHeader({ scrapedAt: window.__scrapedAt, totalAnalyzed: window.__totalAnalyzed, matchedJobs: jobs });
  });

  try {
    const res = await fetch("/api/results");
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.error ?? `HTTP ${res.status}`);
    }

    const result = await res.json();
    jobs = result.matchedJobs ?? [];
    window.__scrapedAt = result.scrapedAt;
    window.__totalAnalyzed = result.totalAnalyzed;

    if (result.feedback) {
      applyFeedback({ rejections: result.feedback.rejections, updatedAt: "" });
    }

    renderHeader(result);

    if (jobs.length === 0) {
      els.listEmpty.classList.remove("hidden");
      els.listEmpty.hidden = false;
      return;
    }

    const first = visibleJobs()[0] ?? jobs[0];
    selectJob(first.id);
  } catch (e) {
    els.listError.textContent = String(e.message ?? e);
    els.listError.classList.remove("hidden");
    els.listError.hidden = false;
  }
}

init();
