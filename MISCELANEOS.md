# GGZenLab — Misceláneos

Portfolio monorepo: [gabrielagarayzavalia/QA-portfolio](https://github.com/gabrielagarayzavalia/QA-portfolio)  
Live site: `https://gabrielagarayzavalia.github.io/QA-portfolio/misc/`

Espacio para **ideas**, **preguntas abiertas** y **notas** que quiero compartir sin que necesariamente sean entregables QA ni ítems del [backlog de skills](BACKLOG.md).

> El sitio se sincroniza manualmente: al agregar un ítem acá, duplicar la tarjeta en `docs/misc/index.html` y las claves EN/ES en `docs/assets/js/i18n.js`.

## Ítems

| ID | Tipo | Título | Estado | Link |
|----|------|--------|--------|------|
| M-01 | Idea | Bitácora de aprendizajes técnicos | Explorando | — |
| M-02 | Pregunta | ¿Cómo compartís preguntas abiertas sin convertirlas en backlog? | Compartido | — |

## Cómo agregar un ítem

1. Agregar fila en la tabla de arriba.
2. Duplicar un `<article class="card">` en [`docs/misc/index.html`](docs/misc/index.html).
3. Agregar strings bilingües en [`docs/assets/js/i18n.js`](docs/assets/js/i18n.js) (`misc.itemN.*`).
4. Opcional: enlace a GitHub Issue, repo path o URL externa en la tarjeta.

## Tipos

| Tipo | Uso |
|------|-----|
| **Idea** | Experimento, side project o concepto en progreso |
| **Pregunta** | Curiosidad o debate — no implica compromiso de entrega |

## Estados sugeridos

- **Explorando** — lo estoy pensando o probando
- **Compartido** — publicado para conversación
- **Pausado** — interesante pero no activo ahora
