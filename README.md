# Workshop: Offensive AI In Practice 

Hands-on Exploitation of Vulnerable Applications Using Open Source AI Tools

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose
- [Git](https://git-scm.com/)
- An [Anthropic API key](https://console.anthropic.com/)

## Quick start

```bash
chmod +x setup.sh
./setup.sh
```

The script walks through each step interactively. Once complete:

```bash
docker compose up
```

For manual setup instructions, see [QUICKSTART.md](QUICKSTART.md).


## Services

### Run ZAP Baseline Scan

```bash
docker compose run --rm zap-baseline
# report at: ./out/zap/zap_baseline_report.html
```

This scan takes approximately five minutes to complete.

---

### Run PentestGPT (Interactive)

PentestGPT starts automatically with `docker compose up`. Connect to it interactively:

```bash
docker compose exec -it pentestgpt bash
```

Point it at Juice Shop:

```bash
pentestgpt --target juice-shop:3000
```

Common options:

```bash
pentestgpt --target juice-shop:3000                                          # Interactive TUI mode
pentestgpt --target juice-shop:3000 --instruction "Focus on auth bypass"     # With instructions
pentestgpt --target juice-shop:3000 -v                                       # Verbose output
pentestgpt --list-sessions                                                   # List previous sessions
pentestgpt --resume --session-id <id>                                        # Resume a session
```

---

## Troubleshooting

### Port Already in Use

If port 3000, 7233, or 8233 is already allocated:

```bash
docker compose down
docker compose up -d
```

### Viewing Logs

```bash
docker compose logs -f <service-name>

# Examples:
docker compose logs -f pentestgpt
docker compose logs -f juice-shop
```

### Reset Everything

```bash
docker compose down -v  # removes volumes
docker compose up -d
```
