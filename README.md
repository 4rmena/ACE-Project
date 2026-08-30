# Gemini Assistant API (Cloudflare Worker Backend)

A lightweight Cloudflare Worker backend that exposes an HTTP API for an assistant model (e.g., Gemini / other LLMs). This service is designed to run on Cloudflare Workers and act as a secure, low-latency proxy and thin orchestration layer for LLM requests, authentication, streaming responses, and simple rate limiting.

- Repository: 4rmena/ACE-Project
- Component: gemini-assistant-api
- Language: JavaScript
- Purpose: Cloudflare Worker-backed assistant API

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Available Endpoints](#available-endpoints)
- [Local Development](#local-development)
- [Deployment](#deployment)
- [Testing](#testing)
- [Security & Rate Limiting](#security--rate-limiting)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features

- Cloudflare Worker implementation for low-latency edge execution
- Proxy requests to an LLM provider (Gemini, OpenAI, or other)
- Simple request validation and authentication
- Support for synchronous and streaming responses (SSE or chunked)
- Lightweight rate limiting hooks (works with KV / Durable Objects if added)
- Health and metrics endpoints for monitoring

## Prerequisites

- Node.js (v16+ recommended)
- Wrangler (Cloudflare CLI) v2+
- A Cloudflare account and a Worker namespace
- API key(s) for the model provider (Gemini, OpenAI, etc.)

## Quick Start

1. Clone the repo and navigate to the folder:

   git clone https://github.com/4rmena/ACE-Project.git
   cd ACE-Project/gemini-assistant-api

2. Install dependencies:

   npm install

3. Create a local configuration file (.env or wrangler.toml — see [Configuration](#configuration)).

4. Run locally:

   npm run dev
   # or
   wrangler dev

5. Deploy:

   wrangler publish

## Configuration

This project expects a small set of environment variables. Example .env:

```
# Model provider keys
MODEL_PROVIDER=gemini            # or openai, custom
GEMINI_API_KEY=your-gemini-key
OPENAI_API_KEY=your-openai-key

# Cloudflare / Wrangler
CF_ACCOUNT_ID=your-cloudflare-account-id
CF_API_TOKEN=your-cloudflare-api-token

# Optional: namespaces for KV, Durable Objects, etc.
RATE_LIMIT_KV_NAMESPACE=your_kv_namespace_id

# App settings
DEFAULT_MODEL=gemini-frontend
PORT=8787
```

If this repository uses `wrangler.toml`, add secret bindings via `wrangler secret put` and refer to them in the Worker.

## Available Endpoints

Note: adapt these to the actual routes in the code. The examples below are typical for an assistant API.

- GET /health
  - Simple health check returning 200 OK and basic status.

- POST /v1/chat
  - Request:
    ```
    POST /v1/chat
    Content-Type: application/json
    Authorization: Bearer <token>
    {
      "model": "gemini",
      "messages": [
        { "role": "system", "content": "You are a helpful assistant." },
        { "role": "user", "content": "Hello!" }
      ],
      "stream": false
    }
    ```
  - Response: JSON with assistant reply and metadata.

- POST /v1/stream
  - Similar to /v1/chat but returns a streaming response (SSE or chunked). Useful for streaming tokens to the client.

- GET /metrics
  - (Optional) Exposes basic usage or health metrics for scraping.

Adjust endpoint paths and payloads to match the implementation in this directory.

## Example: curl (non-streaming)

```
curl -X POST https://<your-worker>.workers.dev/v1/chat \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <API_TOKEN>" \
  -d '{
    "model": "gemini",
    "messages": [
      {"role":"user","content":"Tell me a short joke."}
    ]
  }'
```

## Local Development

- Use `wrangler dev` to run the Worker locally with live reloading.
- Use `wrangler secret put <NAME>` to add secrets for local testing or `--local` options supported by Wrangler.
- For rapid development, mock the external model provider with a local stub or use a test API key.

## Deployment

- Configure `wrangler.toml` for the target account and route.
- Ensure secrets are set in Cloudflare via `wrangler secret put`.
- Publish:

  wrangler publish

If you use CI/CD, integrate `wrangler publish` into your pipeline and store secrets securely (GitHub Actions secrets, Vault, etc).

## Testing

- Unit test any helper modules with your preferred test runner (Jest, Vitest).
- Integration test the Worker using `wrangler dev` and a test model provider or mock endpoint.
- Add end-to-end tests for core flows (chat, streaming, auth).

## Security & Rate Limiting

- Always protect your API behind an auth token (JWT, API key, or other).
- Consider using Cloudflare Workers KV or Durable Objects for rate limiting and request counting.
- Never commit provider API keys into repo. Use secrets or environment bindings.

## Contributing

Contributions are welcome. Suggested workflow:

1. Fork the repository
2. Create a feature branch (git checkout -b feat/your-feature)
3. Run tests and linters
4. Open a Pull Request with a clear description

Please follow the existing code style and include tests for new features.

## License

Copyright (c) 2026 4rmena

All rights reserved.

This repository and its contents, including source code, documentation, and original materials, are the intellectual property of the copyright holder unless otherwise stated.

Permission is not granted to copy, modify, distribute, sublicense, publish, or use this software or its contents for commercial purposes without prior written permission from the copyright holder.

Third-party libraries, services, APIs, models, datasets, and other materials included in or referenced by this project remain subject to their respective licenses and terms.
