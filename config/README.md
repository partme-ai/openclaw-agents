# 配置片段说明

本目录提供可合并进 `~/.openclaw/openclaw.json` 的配置片段。

## 片段列表

| 文件 | 用途 |
|------|------|
| `openclaw-agents-fragment.json` | 通用多智能体示例（含 main、pm、design、dev、ops、blog 及 12 个 it 角色）；需将 `<REPO_ROOT>` 替换为实际路径。 |
| `openclaw-it-fragment.json` | **it 软件开发团队**专用：技术总监（编排者）+ 12 个子角色，单网关内协作。 |
| `openclaw-scrm-fragment.json` | **SCRM 运营团队**专用：6 阶段（引流、获客、客资、建联、客服、私域）+ 客服 3 子角色（presale/aftersale/tech）；多网关时使用 profile `scrm`，端口 18819，状态目录 `~/.openclaw-scrm`；合并前将路径中的 `~/.openclaw-scrm` 按实际 STATE_DIR 替换。wecom-kf 需按账号/会话细化 bindings 时见 partme-docs 客服技术方案。 |
| `openclaw-web3-fragment.json` | **Web3 团队**专用：chain-analyst、defi-scout、risk-monitor、portfolio-manager 四 Agent；多网关时使用 profile `web3`，端口 18869，状态目录 `~/.openclaw-web3`；合并前将路径中的 `~/.openclaw-web3` 按实际 STATE_DIR 替换。 |

## it 软件开发团队（openclaw-it-fragment.json）

- **workspace 路径**：使用**无编号**名称（如 `~/.openclaw/workspace-it/technical-director`、`~/.openclaw/workspace-it/project-manager`），与 agent id 一致。仓库中 `it/1-technical-director` 等编号仅表示顺序，部署时复制或链接到上述无编号路径即可。
- **agent-to-agent**：片段中已设置 `tools.agentToAgent.enabled: true`，`allow` 包含 technical-director 及全部 12 个子角色 id。
- **合并方式**：将片段中的 `agents`、`bindings`、`tools` 合并进你的 `openclaw.json`；若已有同名键，将 `agents.list` 与现有列表合并。多 profile 时 it 实例需独立的 `OPENCLAW_CONFIG_PATH`、`OPENCLAW_STATE_DIR` 与端口（见主 README §3 多网关）。

## SCRM 运营团队（openclaw-scrm-fragment.json）

- **workspace 路径**：使用 `~/.openclaw-scrm/workspace-scrm/<agentId>`（多 profile 时 STATE_DIR 为 `~/.openclaw-scrm`）。仓库 `scrm/lead-gen`、`scrm/acquisition` 等复制或链接到对应 workspace；客服 3 个 Agent（presale、aftersale、tech）可复用 `wecom-kf/` 下模板。
- **bindings**：片段默认将 telegram、discord、wecom-kf 均路由到 scrm-orchestrator；若需 wecom-kf 按账号直连 presale/aftersale/tech，请按 partme-docs 客服技术方案增加 `match.accountId` 或 `match.peer` 的绑定。
- **合并方式**：同 it；多 profile 时使用 `openclaw --profile scrm gateway --port 18819`，配置与状态目录见主 README §3、§9。

## Web3 团队（openclaw-web3-fragment.json）

- **workspace 路径**：使用 `~/.openclaw-web3/workspace-web3/<agentId>`（profile web3 时 STATE_DIR 为 `~/.openclaw-web3`）。将仓库 `web3/chain-analyst`、`web3/defi-scout` 等复制或链接到对应 workspace。
- **合并方式**：同 it；多 profile 时使用 `openclaw --profile web3 gateway --port 18869`。能力与架构见 partme-docs `8、OpenClaw-垂直领域应用分析/Web3`。
