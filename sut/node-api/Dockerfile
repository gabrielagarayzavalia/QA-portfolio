FROM node:20-alpine
WORKDIR /app
COPY sut/node-api/package.json ./
RUN npm install --omit=dev
COPY openapi /openapi
COPY sut/node-api/src ./src
ENV PORT=3000
ENV OPENAPI_PATH=/openapi/abm-crud.yaml
EXPOSE 3000
CMD ["node", "src/server.js"]
