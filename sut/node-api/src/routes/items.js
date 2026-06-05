const express = require('express');
const store = require('../store');

const router = express.Router();

function validateCreate(body) {
  if (!body || typeof body.name !== 'string' || body.name.trim().length === 0) {
    return { message: 'name is required and must not be empty' };
  }
  return null;
}

function validateUpdate(body) {
  if (body.name !== undefined && (typeof body.name !== 'string' || body.name.trim().length === 0)) {
    return { message: 'name must not be empty when provided' };
  }
  return null;
}

router.get('/', (req, res) => {
  const page = parseInt(req.query.page ?? '0', 10);
  const size = parseInt(req.query.size ?? '20', 10);
  const active = req.query.active;
  const result = store.listItems({ page, size, active });
  res.json(result);
});

router.post('/', (req, res) => {
  const err = validateCreate(req.body);
  if (err) return res.status(400).json(err);
  const item = store.createItem({
    name: req.body.name.trim(),
    description: req.body.description ?? '',
    active: req.body.active ?? true,
  });
  res.status(201).json(item);
});

router.get('/:id', (req, res) => {
  const item = store.getItem(req.params.id);
  if (!item) return res.status(404).json({ message: 'Item not found' });
  res.json(item);
});

router.put('/:id', (req, res) => {
  const err = validateUpdate(req.body);
  if (err) return res.status(400).json(err);
  const item = store.updateItem(req.params.id, req.body);
  if (!item) return res.status(404).json({ message: 'Item not found' });
  res.json(item);
});

router.delete('/:id', (req, res) => {
  const ok = store.deleteItem(req.params.id);
  if (!ok) return res.status(404).json({ message: 'Item not found' });
  res.status(204).send();
});

module.exports = router;
