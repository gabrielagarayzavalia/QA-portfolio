# Postman — ABM CRUD

Importar `ABM-CRUD.postman_collection.json` y un environment (`env-node.json`, `env-spring.json`, `env-dotnet.json`).

Ejecutar colección tras `docker compose up`.

Opcional CI con Newman:

```bash
npx newman run ABM-CRUD.postman_collection.json -e env-node.json
```
