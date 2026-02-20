# OpenClaw Agents

OpenClaw multi-agent configuration guide and examples, following the [OpenClaw Multi-Agent](https://docs.openclaw.ai/concepts/multi-agent) docs: run multiple isolated agents (separate workspace, agentDir, sessions) in one gateway and route inbound messages via bindings.

> **Official docs**  
> - [Multi-Agent Routing](https://docs.openclaw.ai/concepts/multi-agent) (paths, single/multi-agent, Agent helper, routing rules)

---

## Two things to know

### How to quickly add agent config to OpenClaw

1. **Ensure OpenClaw is installed** (see [§1 System Requirements & Installation](#1-system-requirements--installation) if not).
2. **Prepare config**  
   If you use a **config fragment** from this repo: open the fragment in an editor and replace any placeholder path (e.g. `<REPO_ROOT>`) with your **absolute path** (e.g. `~/.openclaw` or `/home/you/openclaw-agents`).
3. **Merge and restart**  
   Merge the fragment’s `agents`, `bindings`, and `tools.agentToAgent` into `~/.openclaw/openclaw.json` (merge `agents.list` with existing list if keys already exist). Run `openclaw gateway restart` (or `openclaw gateway`).
4. **Verify**  
   `openclaw agents list --bindings`, `openclaw channels status --probe`.

No local or product-specific paths are required; use paths that match the [official path map](https://docs.openclaw.ai/concepts/multi-agent#paths-quick-map) (Config, State dir, Workspace, Agent dir, Sessions).

### How to add a new agent

- **Option 1 (recommended, matches official docs)**  
  Run `openclaw agents add <agentId>` (e.g. `openclaw agents add work`). The wizard creates a dedicated workspace (e.g. `~/.openclaw/workspace-work`), `agentDir` (e.g. `~/.openclaw/agents/work/agent`), and session store. In `~/.openclaw/openclaw.json` set `workspace` (absolute path) and `agentDir` (must not be shared with other agents), and add `bindings` as needed for routing.
- **Option 2**  
  Manually create `~/.openclaw/workspace-<agentId>` with SOUL.md, AGENTS.md, optional USER.md, etc.; create `~/.openclaw/agents/<agentId>/agent` and `sessions`; add an entry to `agents.list` with `id`, `workspace`, `agentDir`.
- For more detail and fields, see [§4 Creating agents](#4-creating-agents) and [§5 Configuring agents](#5-configuring-agents).

---

## Contents

1. [System Requirements & Installation](#1-system-requirements--installation)
2. [Quick Start & First-Time Setup](#2-quick-start--first-time-setup)
3. [What Is "One Agent"](#3-what-is-one-agent)
4. [Creating Agents](#4-creating-agents)
5. [Configuring Agents](#5-configuring-agents)
6. [Multi-Agent Routing](#6-multi-agent-routing)
7. [Full Configuration Examples](#7-full-configuration-examples)
8. [Paths & Deployment](#8-paths--deployment)
9. [Templates & Agent Mapping](#9-templates--agent-mapping)
10. [Multi-Agent Constraints](#10-multi-agent-constraints)
11. [Troubleshooting](#11-troubleshooting)
12. [Links](#12-links)

---

## 1. System Requirements & Installation

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **OS** | macOS 12+ / Linux (Ubuntu 20.04+) / Windows 11 (WSL2) | macOS 14+ / Ubuntu 22.04+ |
| **Node.js** | 18.0.0+ | 20.0.0+ LTS |
| **Memory** | 4GB RAM | 8GB+ RAM |
| **Disk** | 2GB free | 10GB+ SSD |
| **Network** | Stable internet | - |

### Installation

**Option 1: Official install script (recommended)**

```bash
# macOS / Linux
curl -fsSL https://openclaw.ai/install.sh | bash
# or
wget -qO- https://openclaw.ai/install.sh | bash

source ~/.bashrc   # or ~/.zshrc
```

**Option 2: npm**

```bash
npm install -g openclaw
# or
npx openclaw@latest
```

**Option 3: Homebrew (macOS/Linux)**

```bash
brew tap openclaw/tap
brew install openclaw
brew upgrade openclaw
```

**Option 4: From source**

```bash
git clone https://github.com/openclaw/openclaw.git
cd openclaw && npm install && npm run build && npm link
```

### Verify installation

```bash
openclaw --version
openclaw --help
openclaw doctor
```

---

## 2. Quick Start & First-Time Setup

### First run

```bash
openclaw init
# or
openclaw init --quick
```

The wizard guides you through: config directory, default model, API keys, channel login (optional).

### Manual minimal config

```bash
mkdir -p ~/.openclaw
mkdir -p ~/.openclaw/workspace ~/.openclaw/agents/main/agent
```

Minimal `~/.openclaw/openclaw.json`:

```json5
{
  "agents": {
    "list": [
      {
        "id": "main",
        "default": true,
        "workspace": "~/.openclaw/workspace",
        "agentDir": "~/.openclaw/agents/main/agent"
      }
    ]
  }
}
```

### API keys

- **Environment**: Set `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `DEEPSEEK_API_KEY`, etc. in `~/.bashrc` or `~/.zshrc`, then `source` it.
- **Config file**: Put profiles (name + apiKey) in `~/.openclaw/agents/main/agent/auth-profiles.json` and `chmod 600` it.

### Start gateway

```bash
openclaw gateway              # foreground
openclaw gateway --daemon     # background
openclaw gateway --port 8080  # custom port
```

---

## 3. What Is "One Agent"

Each **agent** is an isolated "brain" with its own:

| Component | Description | Path |
|------------|-------------|------|
| **Workspace** | Files, AGENTS.md/SOUL.md/USER.md, notes, persona rules | `~/.openclaw/workspace-<agentId>` or configured path |
| **agentDir** | Auth, model registry, per-agent config | `~/.openclaw/agents/<agentId>/agent` |
| **Session store** | Chat history and routing state | `~/.openclaw/agents/<agentId>/sessions` |

**Single-agent mode (default)**: With no multi-agent config, `agentId` defaults to `main`, workspace to `~/.openclaw/workspace`, state to `~/.openclaw/agents/main/agent`.

---

## 4. Creating Agents

### Method 1: Wizard (recommended)

```bash
openclaw agents add
openclaw agents add work
openclaw agents add personal
```

The wizard guides: name, workspace path, state directory path, channel bindings (optional).

### Method 2: Manual

```bash
mkdir -p ~/.openclaw/workspace-work
cd ~/.openclaw/workspace-work
touch AGENTS.md SOUL.md USER.md

mkdir -p ~/.openclaw/agents/work/agent
mkdir -p ~/.openclaw/agents/work/sessions

vim ~/.openclaw/openclaw.json
```

Add to `agents.list`:

```json5
{
  id: "work",
  name: "Work",
  workspace: "~/.openclaw/workspace-work",
  agentDir: "~/.openclaw/agents/work/agent",
}
```

### Method 3: Copy existing agent

```bash
cp -r ~/.openclaw/workspace ~/.openclaw/workspace-copy
cp -r ~/.openclaw/agents/main ~/.openclaw/agents/copy
# Add a new list entry for "copy" in openclaw.json and set id/workspace/agentDir
```

---

## 5. Configuring Agents

### Config file location

Main config: `~/.openclaw/openclaw.json` (JSON5). Override with `OPENCLAW_CONFIG_PATH`.

### Agent fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique identifier for routing |
| `name` | string | No | Display name |
| `default` | boolean | No | Default agent for fallback routing |
| `workspace` | string | Yes | **Absolute** workspace path |
| `agentDir` | string | Yes | State directory; **must not** be shared across agents |
| `model` | string | No | Default model |

### Workspace files

| File | Purpose | When to edit |
|------|---------|--------------|
| `AGENTS.md` | Role, tools, constraints | Change role and capabilities |
| `SOUL.md` | Personality, tone, style | Change reply style |
| `USER.md` | User preferences, context | Change user settings |
| `BOOTSTRAP.md` | Startup behavior | Change init logic |
| `HEARTBEAT.md` | Periodic tasks | Change periodic behavior |
| `TOOLS.md` | Tool usage | Change tool config |
| `IDENTITY.md` | Identity | Optional |

### Changing channel bindings

Configure `bindings` by `channel`, `accountId`, `peer`, etc.; see "Multi-Agent Routing" below.

### Changing channel config

```json5
{
  channels: {
    whatsapp: {
      accounts: {
        biz: {
          authDir: "~/.custom-credentials/whatsapp/biz",
        }
      }
    }
  }
}
```

### Hot reload and validation

```bash
openclaw config validate
openclaw config reload
# or: kill -HUP <gateway_pid>
```

```bash
openclaw agents list --bindings
openclaw agents validate --id work
openclaw agents test-binding --agent work --channel whatsapp
```

### Removing an agent

```bash
openclaw agents remove --id work
# Optional: manually remove workspace and state (use with care)
# rm -rf ~/.openclaw/workspace-work ~/.openclaw/agents/work
```

### Backup and restore

```bash
# Backup
tar czf work-backup.tar.gz ~/.openclaw/workspace-work
tar czf work-agent-backup.tar.gz ~/.openclaw/agents/work
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# Restore: extract and restore config
tar xzf work-backup.tar.gz -C ~/
tar xzf work-agent-backup.tar.gz -C ~/
cp ~/.openclaw/openclaw.json.backup ~/.openclaw/openclaw.json
```

---

## 6. Multi-Agent Routing

### Routing rules (most specific wins)

1. `peer` match (exact DM/group/channel ID)
2. `parentPeer` match (thread inheritance)
3. `guildId + roles` (Discord roles)
4. `guildId` (Discord)
5. `teamId` (Slack)
6. Channel `accountId` match
7. Channel-level match (`accountId: "*"`)
8. Fallback to default agent (`default: true` or first in list)

### Binding examples

```json5
{
  bindings: [
    { agentId: "deep-work", match: { channel: "whatsapp", peer: { kind: "direct", id: "+15551234567" } } },
    { agentId: "home", match: { channel: "whatsapp", accountId: "personal" } },
    { agentId: "work", match: { channel: "whatsapp", accountId: "biz" } },
    { agentId: "main", match: { channel: "telegram" } },
  ]
}
```

### Match fields

| Field | Description | Example |
|-------|-------------|---------|
| `channel` | Channel type | `whatsapp`, `telegram`, `discord` |
| `accountId` | Channel account ID | `personal`, `biz`, `default` |
| `peer.kind` | Conversation type | `direct`, `group` |
| `peer.id` | Conversation ID | Phone number, group ID, channel ID |
| `guildId` | Discord server ID | `"123456789012345678"` |

---

## 7. Full Configuration Examples

### WhatsApp multi-account (personal + work)

```bash
openclaw channels login --channel whatsapp --account personal
openclaw channels login --channel whatsapp --account biz
```

```json5
{
  agents: {
    list: [
      { id: "home", default: true, name: "Home", workspace: "~/.openclaw/workspace-home", agentDir: "~/.openclaw/agents/home/agent" },
      { id: "work", name: "Work", workspace: "~/.openclaw/workspace-work", agentDir: "~/.openclaw/agents/work/agent" },
    ],
  },
  bindings: [
    { agentId: "home", match: { channel: "whatsapp", accountId: "personal" } },
    { agentId: "work", match: { channel: "whatsapp", accountId: "biz" } },
  ],
  channels: { whatsapp: { accounts: { personal: {}, biz: {} } } },
}
```

### Route by channel (WhatsApp daily + Telegram deep work)

```json5
{
  agents: {
    list: [
      { id: "chat", name: "Everyday", workspace: "~/.openclaw/workspace-chat", model: "anthropic/claude-sonnet-4-5" },
      { id: "opus", name: "Deep Work", workspace: "~/.openclaw/workspace-opus", model: "anthropic/claude-opus-4-6" },
    ],
  },
  bindings: [
    { agentId: "chat", match: { channel: "whatsapp" } },
    { agentId: "opus", match: { channel: "telegram" } },
  ],
}
```

---

## 8. Paths & Deployment

### Path reference

| Path | Env var | Default | Description |
|------|----------|--------|-------------|
| Config | `OPENCLAW_CONFIG_PATH` | `~/.openclaw/openclaw.json` | Main config |
| State root | `OPENCLAW_STATE_DIR` | `~/.openclaw` | All state |
| Workspace | `OPENCLAW_WORKSPACE` / `OPENCLAW_PROFILE` | `~/.openclaw/workspace` | Default workspace |
| Agent dir | - | `~/.openclaw/agents/<agentId>/agent` | Agent state |
| Sessions | - | `~/.openclaw/agents/<agentId>/sessions` | Chat history |
| Global skills | - | `~/.openclaw/skills` | Shared skills |

### Directory layout

```
~/.openclaw/
├── openclaw.json
├── workspace/                 # default (main)
│   ├── AGENTS.md, SOUL.md, USER.md, BOOTSTRAP.md, HEARTBEAT.md
│   └── skills/
├── workspace-<agentId>/
├── agents/
│   ├── main/
│   │   ├── agent/            # auth-profiles.json, config.json
│   │   └── sessions/
│   └── <agentId>/
├── credentials/
└── skills/
```

### Environment-based deployment

```bash
# Dev
export OPENCLAW_CONFIG_PATH="$HOME/.openclaw/openclaw.dev.json"
export OPENCLAW_STATE_DIR="$HOME/.openclaw-dev"

# Prod
export OPENCLAW_CONFIG_PATH="/etc/openclaw/openclaw.json"
export OPENCLAW_STATE_DIR="/var/lib/openclaw"
```

### systemd (Linux)

```ini
# /etc/systemd/system/openclaw.service
[Unit]
Description=OpenClaw Gateway
After=network.target
[Service]
Type=simple
User=your-user
Environment="OPENCLAW_CONFIG_PATH=/home/your-user/.openclaw/openclaw.json"
ExecStart=/usr/local/bin/openclaw gateway
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable openclaw && sudo systemctl start openclaw
sudo systemctl status openclaw
```

### Docker

```bash
docker pull openclaw/openclaw:latest
docker run -d --name openclaw \
  -v ~/.openclaw:/root/.openclaw \
  -e ANTHROPIC_API_KEY=your-api-key \
  -p 8080:8080 \
  openclaw/openclaw:latest
```

### Permissions and backup

```bash
chmod 700 ~/.openclaw
chmod 600 ~/.openclaw/openclaw.json
chmod 600 ~/.openclaw/agents/*/agent/auth-profiles.json
```

Use a scheduled job to back up `openclaw.json`, `workspace*`, and `agents` to dated tar.gz and retain the last N backups.

---

## 9. Templates & Agent Mapping

### Workspace file layout

```
<agent-name>/
├── AGENTS.md      # Role, tools, constraints
├── SOUL.md        # Personality, tone, style
├── USER.md        # User preferences, context
├── BOOTSTRAP.md   # Startup behavior
├── HEARTBEAT.md   # Periodic tasks
├── IDENTITY.md    # Identity (optional)
└── TOOLS.md       # Tool usage (optional)
```

### Agent type examples (official paths only)

Conceptual examples using the [official path convention](https://docs.openclaw.ai/concepts/multi-agent#paths-quick-map) (`~/.openclaw/workspace-<agentId>`, `~/.openclaw/agents/<agentId>/agent`):

| Workspace path (example) | Purpose |
|--------------------------|---------|
| `~/.openclaw/workspace` | Default main agent, general chat |
| `~/.openclaw/workspace-work` | Work context |
| `~/.openclaw/workspace-personal` | Personal context |
| `~/.openclaw/workspace-coding` | Coding assistant |
| `~/.openclaw/workspace-social` | Social / content |

Each agent must have its own `agentDir` (e.g. `~/.openclaw/agents/work/agent`); do not share it.

### Creating an agent from an existing directory

```bash
# If you already have a workspace directory (e.g. copied or created by hand)
mkdir -p ~/.openclaw/workspace-coding
# Add AGENTS.md, SOUL.md, USER.md, etc. (see "Workspace file layout" above)

# Add an entry to agents.list in openclaw.json, e.g.:
# id: "coding", workspace: "~/.openclaw/workspace-coding", agentDir: "~/.openclaw/agents/coding/agent"
```

---

## 10. Multi-Agent Constraints

### Isolation

| Resource | Level | Notes |
|----------|-------|-------|
| Workspace | ✅ Isolated | Per-agent directory |
| Auth | ✅ Isolated | `auth-profiles.json` per agent |
| Sessions | ✅ Isolated | Session key includes `agentId` |
| Model config | ✅ Isolated | Per-agent |
| Global skills | ⚠️ Read-only shared | `~/.openclaw/skills` |
| Channel connection | ⚠️ Shared | Connection pool shared; routing per agent |

### Critical constraints

1. **Do not share agentDir**  
   Multiple agents using the same `agentDir` causes auth/session/config conflicts. Each agent must have its own (e.g. `~/.openclaw/agents/<id>/agent`).

2. **Auth is not shared automatically**  
   Main agent credentials are not given to other agents; log in per agent or copy `auth-profiles.json` manually.

3. **DM access control is per channel**  
   Pairing/allowlist is configured under `channels.<channel>` and applies to the whole channel, not per agent.

4. **Agent-to-agent must be enabled explicitly**  
   ```json5
   {
     tools: {
       agentToAgent: {
         enabled: false,
         allow: ["home", "work"],
       },
     },
   }
   ```

### Performance and limits

| Metric | Suggested | Notes |
|--------|-----------|-------|
| Agent count | 5–10 | Per gateway instance |
| Concurrent sessions | 10–20 per agent | Depends on model and hardware |
| Memory | ~100MB per agent | Workspace + session cache |
| Startup | +2–5s per agent | Depends on workspace size |

### Security and best practices

- Workspace is the default cwd but not a hard sandbox; absolute paths can access the host. Enable `sandbox` for strict isolation.
- Use `chmod 600` for `openclaw.json` and `auth-profiles.json`.
- You can version-control config but add `agents/*/agent/auth-profiles.json` and `credentials/**` to `.gitignore`.

---

## 11. Troubleshooting

### Common issues

| Symptom | Action |
|---------|--------|
| Wrong routing | `openclaw agents list --bindings`; `openclaw gateway --verbose` for routing logs |
| Auth failure | Check `~/.openclaw/agents/<agentId>/agent/auth-profiles.json`; `openclaw channels login` to re-login |
| Session mix-up | `rm -rf ~/.openclaw/agents/<agentId>/sessions/*` then restart gateway |
| Config not applied | `openclaw config validate`; `openclaw config reload` or restart gateway |

### Debug commands

```bash
openclaw gateway --verbose
openclaw channels status --probe
openclaw agents test-binding --agent <id> --channel <type>
openclaw config export --output debug.json
```

### Install and startup

- **Install fails**: Ensure Node.js ≥ 18 (`node --version`), npm permissions, and if needed `npm cache clean --force`.
- **Startup fails**: Check port (e.g. `lsof -i :8080`), config validation, and verbose logs.

### Update and uninstall

```bash
# Update
curl -fsSL https://openclaw.ai/install.sh | bash
# or npm update -g openclaw / brew upgrade openclaw

# Uninstall
curl -fsSL https://openclaw.ai/uninstall.sh | bash
# or npm uninstall -g openclaw; optionally rm -rf ~/.openclaw (destructive)
```

---

## 12. Links

- [OpenClaw docs](https://docs.openclaw.ai)
- [Multi-Agent Routing](https://docs.openclaw.ai/concepts/multi-agent)
- [Channels](https://docs.openclaw.ai/channels)
- [Docs index llms.txt](https://docs.openclaw.ai/llms.txt)

---

**Last updated**: 2026-02-20
