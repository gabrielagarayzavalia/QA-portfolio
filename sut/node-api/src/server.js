const path = require('path');
const express = require('express');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');
const itemsRouter = require('./routes/items');

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());

const openApiPath =
  process.env.OPENAPI_PATH || path.join(__dirname, '../../../openapi/abm-crud.yaml');
const swaggerDocument = YAML.load(openApiPath);

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.get('/health', (_req, res) => res.json({ status: 'ok', sut: 'node-api' }));

app.use('/api/items', itemsRouter);

app.listen(PORT, () => {
  console.log(`node-api listening on http://localhost:${PORT}`);
  console.log(`Swagger UI: http://localhost:${PORT}/api-docs`);
});
