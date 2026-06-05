const { randomUUID } = require('crypto');

const items = new Map();

function createItem({ name, description = '', active = true }) {
  const id = randomUUID();
  const item = {
    id,
    name,
    description,
    active: Boolean(active),
    createdAt: new Date().toISOString(),
  };
  items.set(id, item);
  return item;
}

function getItem(id) {
  return items.get(id) ?? null;
}

function updateItem(id, patch) {
  const existing = items.get(id);
  if (!existing) return null;
  const updated = {
    ...existing,
    ...(patch.name !== undefined ? { name: patch.name } : {}),
    ...(patch.description !== undefined ? { description: patch.description } : {}),
    ...(patch.active !== undefined ? { active: Boolean(patch.active) } : {}),
  };
  items.set(id, updated);
  return updated;
}

function deleteItem(id) {
  return items.delete(id);
}

function listItems({ page = 0, size = 20, active }) {
  let all = Array.from(items.values());
  if (active !== undefined && active !== null && active !== '') {
    const flag = active === true || active === 'true';
    all = all.filter((i) => i.active === flag);
  }
  all.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  const totalElements = all.length;
  const totalPages = Math.max(1, Math.ceil(totalElements / size) || 1);
  const start = page * size;
  const content = all.slice(start, start + size);
  return {
    content,
    page: Number(page),
    size: Number(size),
    totalElements,
    totalPages: totalElements === 0 ? 0 : totalPages,
  };
}

function reset() {
  items.clear();
}

module.exports = {
  createItem,
  getItem,
  updateItem,
  deleteItem,
  listItems,
  reset,
};
