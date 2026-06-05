# JMeter — ABM Load Test

## Prerrequisitos

- Apache JMeter 5.6+
- SUT Node: `docker compose up node-api`

## Ejecución

```bash
jmeter -n -t ABM-load-test.jmx -JbaseUrl=http://localhost:3000 -l results.jtl -e -o jmeter-report
```

Variables del plan:

| Variable | Default | Descripción |
|----------|---------|-------------|
| baseUrl | http://localhost:3000 | Host del SUT |
| threadsList | 50 | Usuarios concurrentes listado |
| durationList | 30 | Segundos TG-List |
| threadsCreate | 20 | Hilos creación |
