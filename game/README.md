# Game team agents

Workspace templates for the **game** multi-agent team: Game Master (orchestrator), Game Designer, Game Architect, and Game Developer. Aligned with the terminology in [README_EN.md](../README_EN.md).

## Roles

| Directory            | Agent id        | Role            | Description |
|----------------------|-----------------|-----------------|-------------|
| `1-game-master/`     | `game-master`   | Game Master     | 游戏主持人 — facilitator and orchestrator; vision, sessions, coordination |
| `2-game-designer/`   | `game-designer` | Game Designer   | 游戏策划 — gameplay, rules, systems, levels, narrative (industry-standard role) |
| `3-game-architect/`  | `game-architect`| Game Architect  | 游戏架构师 — overall game architecture and system design (senior, technical) |
| `4-game-developer/`  | `game-developer`| Game Developer  | 游戏开发/程序开发 — client, server, tools implementation; programming (程序开发) |

## Config fragment

Use `config/openclaw-game-fragment.json`: merge its `agents`, `bindings`, and `tools.agentToAgent` into `~/.openclaw/openclaw.json`. Default agent is `game-master`; it can delegate to `game-designer`, `game-architect`, and `game-developer` via agent-to-agent.

## Quick start

```bash
openclaw agents add game-master
openclaw agents add game-designer
openclaw agents add game-architect
openclaw agents add game-developer
# Merge config/openclaw-game-fragment.json into ~/.openclaw/openclaw.json
# Copy this repo's game/* into your workspace-game/<agentId> paths
```
