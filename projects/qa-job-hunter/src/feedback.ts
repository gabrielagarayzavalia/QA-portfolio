// ============================================================
//  feedback.ts — Feedback de matches incorrectos para aprendizaje
// ============================================================

import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import type { JobListing, JobMatch } from "./types.js";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
export const FEEDBACK_PATH = path.join(ROOT, "output", "match-feedback.json");

export interface MatchRejection {
  jobId: string;
  title: string;
  company: string;
  searchTerm: string;
  matchPercent: number;
  reason?: string;
  rejectedAt: string;
}

export interface MatchFeedbackStore {
  updatedAt: string;
  rejections: MatchRejection[];
}

function emptyStore(): MatchFeedbackStore {
  return { updatedAt: new Date().toISOString(), rejections: [] };
}

export function loadFeedback(): MatchFeedbackStore {
  if (!fs.existsSync(FEEDBACK_PATH)) return emptyStore();
  try {
    return JSON.parse(fs.readFileSync(FEEDBACK_PATH, "utf-8")) as MatchFeedbackStore;
  } catch {
    return emptyStore();
  }
}

export function saveFeedback(store: MatchFeedbackStore): void {
  const dir = path.dirname(FEEDBACK_PATH);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  store.updatedAt = new Date().toISOString();
  fs.writeFileSync(FEEDBACK_PATH, JSON.stringify(store, null, 2), "utf-8");
}

export function isRejectedJobId(jobId: string, store = loadFeedback()): boolean {
  return store.rejections.some((r) => r.jobId === jobId);
}

export function addRejection(
  job: Pick<JobMatch, "id" | "title" | "company" | "searchTerm" | "matchPercent">,
  reason?: string
): MatchFeedbackStore {
  const store = loadFeedback();
  const existing = store.rejections.findIndex((r) => r.jobId === job.id);

  const entry: MatchRejection = {
    jobId: job.id,
    title: job.title,
    company: job.company,
    searchTerm: job.searchTerm,
    matchPercent: job.matchPercent,
    reason: reason?.trim() || undefined,
    rejectedAt: new Date().toISOString(),
  };

  if (existing >= 0) store.rejections[existing] = entry;
  else store.rejections.push(entry);

  saveFeedback(store);
  return store;
}

export function removeRejection(jobId: string): MatchFeedbackStore {
  const store = loadFeedback();
  store.rejections = store.rejections.filter((r) => r.jobId !== jobId);
  saveFeedback(store);
  return store;
}

/** Bloque de contexto para el prompt del LLM — aprende de falsos positivos */
export function buildFeedbackLearningBlock(store = loadFeedback()): string {
  if (store.rejections.length === 0) return "";

  const recent = store.rejections.slice(-20);
  const lines = recent.map((r) => {
    const why = r.reason ? ` Motivo: ${r.reason}` : "";
    return `- "${r.title}" @ ${r.company} (búsqueda: ${r.searchTerm}) — el ${r.matchPercent}% fue INCORRECTO.${why}`;
  });

  const searchTerms = [...new Set(recent.map((r) => r.searchTerm))];
  const termHint =
    searchTerms.length > 0
      ? `\nTérminos de búsqueda que produjeron falsos positivos: ${searchTerms.join(", ")}.`
      : "";

  return `
=== FEEDBACK DEL USUARIO (matches marcados como incorrectos) ===
El candidato rechazó manualmente estos empleos que el sistema calificó con 70%+. Sé MÁS ESTRICTO con ofertas similares (mismo rol, stack o tipo de empresa).

${lines.join("\n")}
${termHint}

Si la oferta actual se parece a alguno de estos casos, asigna matchPercent por debajo de 70.
`;
}

/** Coincidencia heurística título+empresa para evitar re-analizar duplicados rechazados */
export function matchesPriorRejection(job: JobListing, store = loadFeedback()): MatchRejection | undefined {
  const norm = (s: string) => s.toLowerCase().trim();
  return store.rejections.find(
    (r) => norm(r.title) === norm(job.title) && norm(r.company) === norm(job.company)
  );
}
