# Manual Setup

If you prefer not to use `setup.sh`, follow these steps manually.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose
- [Git](https://git-scm.com/)
- An [Anthropic API key](https://console.anthropic.com/)

## Step 1: Environment file

```bash
cp .env.example .env
```

Open `.env` and fill in your values.

## Step 2: Anthropic API key

Set `ANTHROPIC_API_KEY` in `.env`:

```bash
# .env
ANTHROPIC_API_KEY=sk-ant-...
```

Alternatively, export it in your shell (the setup script will remove it from `.env` if it finds it in the environment):

```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

## Step 3: PentestGPT

Clone PentestGPT into the `tools/` directory:

```bash
git clone https://github.com/greydgl/pentestgpt tools/PentestGPT
```

## Step 4: Docker images

Pull the pre-built images:

```bash
docker compose pull
```

> Note: `pentestgpt` and `shannon-worker` are built locally from `tools/` and are not pulled.

## Start the stack

```bash
docker compose up
```

Services:

| Service | URL |
|---|---|
| Juice Shop (target) | http://localhost:3000 |

