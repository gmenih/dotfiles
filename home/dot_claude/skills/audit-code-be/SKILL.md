---
name: audit-code-be
description: Deep audit of an unfamiliar backend codebase. Discovers stack, endpoints, architecture, data models, and issues. Produces structured markdown output suitable for piping into further analysis. Use when user wants to audit code, understand an unfamiliar project, or reverse-engineer a backend.
---

You are auditing an unfamiliar backend codebase. Your job is to be relentless and thorough — leave no stone unturned. The user has zero context about this project and needs a complete picture.

Work autonomously. Do not ask questions. Explore everything, read everything relevant, and produce a single structured report at the end.

## Phase 1: Identify the stack

Start broad. Determine the foundational technologies before diving deeper.

1. Read the root directory listing, package manifests, lock files, and config files (`package.json`, `go.mod`, `Cargo.toml`, `requirements.txt`, `pyproject.toml`, `Gemfile`, `pom.xml`, `build.gradle`, `composer.json`, `mix.exs`, `Dockerfile`, `docker-compose.yml`, etc.)
2. Identify:
   - **Language(s)** and version constraints
   - **Framework** (Express, Fastify, NestJS, Django, Flask, FastAPI, Rails, Spring Boot, Phoenix, Gin, Axum, Laravel, ASP.NET, etc.)
   - **Runtime** (Node.js, Deno, Bun, Python, Ruby, JVM, .NET, Go, Rust, Elixir, etc.)
   - **Database(s)** — look at ORM configs, migration folders, connection strings, docker-compose services, env templates
   - **ORM / query layer** (Prisma, TypeORM, Drizzle, SQLAlchemy, ActiveRecord, GORM, Diesel, Ecto, Eloquent, etc.)
   - **Cache / queue / message broker** (Redis, RabbitMQ, Kafka, SQS, BullMQ, Celery, Sidekiq, etc.)
   - **Auth mechanism** (JWT, session, OAuth, API keys, passport, auth0, clerk, supabase auth, etc.)
   - **Cloud / infra** (AWS, GCP, Azure, Vercel, Railway, Fly.io — check IaC files, deployment configs, CI/CD)
   - **Key dependencies** — anything that shapes the architecture (tRPC, GraphQL libs, gRPC, Stripe, Twilio, etc.)

## Phase 2: Map the project structure

1. Get a recursive directory listing (2-3 levels deep) to understand the layout
2. Classify the architecture pattern:
   - Monolith vs microservices vs modular monolith
   - Layered (controller/service/repo) vs feature-based vs domain-driven
   - Monorepo structure if applicable (identify packages/services)
3. Identify the entry point(s) — where does the app boot? How are routes/handlers registered?
4. Identify configuration patterns — env vars, config files, feature flags

## Phase 3: Discover all endpoints / entry points

This is the most critical phase. Be exhaustive.

**For REST APIs:**

- Search for route definitions (`router.get`, `app.post`, `@Get()`, `@app.route`, `@router`, `HandleFunc`, etc.)
- Check for route registration files, controller decorators, or auto-discovery patterns
- Note HTTP method, path, and which handler/controller handles it

**For GraphQL:**

- Find schema definitions (`.graphql` files, `typeDefs`, schema-first or code-first)
- List all queries, mutations, and subscriptions
- Identify resolvers and where they live

**For tRPC / RPC:**

- Find router definitions and list all procedures
- Note input/output types

**For gRPC:**

- Find `.proto` files, list all services and methods

**For WebSocket / realtime:**

- Find socket event handlers, channel definitions

**For background jobs / workers / cron:**

- Find job definitions, queue consumers, scheduled tasks

**For CLI commands:**

- Find command definitions if the project exposes any

Produce a flat, complete list. Every single endpoint/procedure matters. Group them logically (by resource, module, or domain).

## Phase 4: Data model overview

1. Look at the ORM schema, migration files, or raw SQL definitions
2. List all major entities/tables with their key fields and relationships
3. Note any polymorphic patterns, soft deletes, multi-tenancy, or audit trails
4. If there's a Prisma schema, read it fully. Same for SQLAlchemy models, ActiveRecord models, etc.

## Phase 5: Authentication & authorization

1. How does auth work? Where is it enforced?
2. What roles/permissions exist?
3. Are there middleware guards, decorators, or policies?
4. What routes are public vs protected?

## Phase 6: Third-party integrations

List every external service the code talks to:

- Payment providers (Stripe, PayPal, etc.)
- Email/SMS (SendGrid, Twilio, Postmark, etc.)
- Storage (S3, GCS, Cloudinary, etc.)
- Analytics / monitoring (Sentry, Datadog, Segment, etc.)
- Any other APIs the code calls

## Phase 7: Architecture red flags & observations

Look for and report on:

- **Circular dependencies** between modules
- **God files/classes** — files over 500 lines that do too much
- **Missing error handling** — unhandled promise rejections, bare except blocks, panics without recovery
- **Security concerns** — hardcoded secrets, SQL injection vectors, missing auth on sensitive routes, CORS misconfiguration
- **No tests** or very low test coverage (check for test directories, test files, CI test steps)
- **Dead code** — unused routes, deprecated modules still present
- **Missing migrations** or schema drift indicators
- **Inconsistent patterns** — mixed coding styles suggesting multiple authors or rushed development
- **Scaling concerns** — N+1 queries, missing indexes, synchronous operations that should be async

## Output format

Produce a single markdown document with these exact sections. Use terse, factual language. No filler. Every line should carry information.

```markdown
# Backend Audit: [project name]

## Stack summary

| Layer       | Technology |
| ----------- | ---------- |
| Language    | ...        |
| Framework   | ...        |
| Runtime     | ...        |
| Database    | ...        |
| ORM         | ...        |
| Cache/Queue | ...        |
| Auth        | ...        |
| Cloud/Infra | ...        |

Key dependencies: ...

## Project structure

[tree-style layout with annotations on what each top-level directory does]

Architecture pattern: [classification]
Entry point: [file path]

## Endpoints

[Complete list grouped by domain/resource. Format each as:]
[METHOD] /path — brief description (handler: file:line)

[For GraphQL, list queries/mutations/subscriptions similarly]
[For RPC, list procedures]
[For jobs/workers, list them separately]

## Data model

[Entity list with key fields and relationships, in table or compact format]

## Auth & authorization

[How it works, what's protected, roles/permissions]

## Integrations

[Bulleted list of every external service with what it's used for]

## Red flags & observations

[Bulleted list, severity noted as: CRITICAL / WARNING / INFO]

## Quick stats

- Total endpoints/procedures: N
- Total DB models/tables: N
- Total files: N
- Test files found: N
- Lines of code (approx): N
```

## Rules

- Do NOT ask the user questions. Explore autonomously.
- Do NOT skip sections. If something doesn't apply, say "N/A" and move on.
- Do NOT summarize vaguely. Be specific — file names, line numbers, exact counts.
- If the codebase is a monorepo with multiple services, audit each service as a subsection.
- If you find `.env.example` or `.env.template`, read it to understand expected configuration.
- Read actual source files, not just config. Open controllers, services, models. Skim the code.
- When listing endpoints, actually trace them to their handlers. Don't just list route strings.
- Spend extra time on Phase 3 (endpoints). This is the most valuable output for the user.
