# OpenClaw Agents

OpenClaw 多智能体配置说明与示例，遵循 [OpenClaw Multi-Agent](https://docs.openclaw.ai/concepts/multi-agent) 官方约定：在一个网关实例中运行多个隔离智能体（独立 workspace、agentDir、sessions），通过 bindings 路由入站消息。

> **官方文档**  
> - [Multi-Agent Routing](https://docs.openclaw.ai/concepts/multi-agent)（路径、单/多智能体、Agent helper、路由规则）

---

## 两件必知的事

### 如何快速把智能体配置加到 OpenClaw

1. **确认 OpenClaw 已安装**（未安装见 [§1 系统要求与安装](#1-系统要求与安装)）。
2. **准备配置**  
   若你使用本仓库提供的 **config 片段**：用任意文本编辑器打开片段，将其中占位路径（如 `<REPO_ROOT>`）**全部**替换为你的实际路径（**绝对路径**，例如 `~/.openclaw` 或 `/home/you/openclaw-agents`）。
3. **合并并重启**  
   把片段中的 `agents`、`bindings`、`tools.agentToAgent` 合并进 `~/.openclaw/openclaw.json`（若已有同名键，将 `agents.list` 与现有 list 合并，其余按需覆盖）。执行 `openclaw gateway restart`（或 `openclaw gateway` 启动）。
4. **验证**  
   `openclaw agents list --bindings`、`openclaw channels status --probe`。

以上过程不依赖任何本地或私有目录名；路径以你本机为准，与 [官方路径约定](https://docs.openclaw.ai/concepts/multi-agent#paths-quick-map) 一致（Config、State dir、Workspace、Agent dir、Sessions）。

### 如何添加新的智能体

- **方式一（推荐，与官方一致）**：执行 `openclaw agents add <agentId>`（如 `openclaw agents add work`）。向导会创建独立 workspace（如 `~/.openclaw/workspace-work`）、`agentDir`（如 `~/.openclaw/agents/work/agent`）和 session 存储。再在 `~/.openclaw/openclaw.json` 中为该智能体设置 `workspace`（**绝对路径**）、`agentDir`（**禁止**与其它智能体共用），并按需添加 `bindings` 做路由。
- **方式二**：手动创建目录 `~/.openclaw/workspace-<agentId>`，放入 SOUL.md、AGENTS.md、可选 USER.md 等；创建 `~/.openclaw/agents/<agentId>/agent` 与 `sessions`；在 `agents.list` 中增加一项，填写 `id`、`workspace`、`agentDir`。
- 详细步骤与字段说明见 [§4 创建智能体](#4-创建智能体) 和 [§5 配置智能体](#5-配置智能体)。

---

## 目录

1. [系统要求与安装](#1-系统要求与安装)
2. [快速开始与首次配置](#2-快速开始与首次配置)
3. [什么是「一个智能体」](#3-什么是「一个智能体」)
4. [创建智能体](#4-创建智能体)
5. [配置智能体](#5-配置智能体)
6. [多智能体路由](#6-多智能体路由)
7. [完整配置示例](#7-完整配置示例)
8. [路径与部署](#8-路径与部署)
9. [模板与智能体对照](#9-模板与智能体对照)
10. [Multi-Agent 约束说明](#10-multi-agent-约束说明)
11. [故障排查](#11-故障排查)
12. [相关链接](#12-相关链接)

---

## 1. 系统要求与安装

### 系统要求

| 组件 | 最低要求 | 推荐 |
|------|----------|------|
| **操作系统** | macOS 12+ / Linux (Ubuntu 20.04+) / Windows 11 (WSL2) | macOS 14+ / Ubuntu 22.04+ |
| **Node.js** | 18.0.0+ | 20.0.0+ LTS |
| **内存** | 4GB RAM | 8GB+ RAM |
| **磁盘** | 2GB 可用空间 | 10GB+ SSD |
| **网络** | 稳定互联网连接 | - |

### 安装方式

**方式一：官方安装脚本（推荐）**

```bash
# macOS / Linux
curl -fsSL https://openclaw.ai/install.sh | bash
# 或
wget -qO- https://openclaw.ai/install.sh | bash

source ~/.bashrc   # 或 ~/.zshrc
```

**方式二：npm**

```bash
npm install -g openclaw
# 或使用 npx
npx openclaw@latest
```

**方式三：Homebrew（macOS/Linux）**

```bash
brew tap openclaw/tap
brew install openclaw
brew upgrade openclaw   # 更新
```

**方式四：从源码安装**

```bash
git clone https://github.com/openclaw/openclaw.git
cd openclaw && npm install && npm run build && npm link
```

### 验证安装

```bash
openclaw --version
openclaw --help
openclaw doctor
```

---

## 2. 快速开始与首次配置

### 首次运行

```bash
# 配置向导
openclaw init
# 或快速配置
openclaw init --quick
```

向导会引导：配置目录、默认模型、API Key、渠道登录（可选）。

### 手动创建基础配置

```bash
mkdir -p ~/.openclaw
mkdir -p ~/.openclaw/workspace ~/.openclaw/agents/main/agent
```

`~/.openclaw/openclaw.json` 最小示例：

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

### 配置 API Key

- **环境变量**：`ANTHROPIC_API_KEY`、`OPENAI_API_KEY`、`DEEPSEEK_API_KEY` 等，写入 `~/.bashrc` 或 `~/.zshrc` 后 `source`。
- **配置文件**：在 `~/.openclaw/agents/main/agent/auth-profiles.json` 中配置 profiles（name + apiKey），并执行 `chmod 600` 保护。

### 启动网关

```bash
openclaw gateway              # 前台
openclaw gateway --daemon     # 后台
openclaw gateway --port 8080  # 指定端口
```

---

## 3. 什么是「一个智能体」

每个**智能体（Agent）**是独立范围的「大脑」，拥有自己的：

| 组件 | 描述 | 路径 |
|------|------|------|
| **工作空间（Workspace）** | 文件、AGENTS.md/SOUL.md/USER.md、本地笔记、角色规则 | `~/.openclaw/workspace-<agentId>` 或配置的路径 |
| **状态目录（agentDir）** | 认证、模型注册表、智能体专属配置 | `~/.openclaw/agents/<agentId>/agent` |
| **会话存储** | 聊天历史与路由状态 | `~/.openclaw/agents/<agentId>/sessions` |

**单智能体模式（默认）**：不配置多智能体时，`agentId` 默认为 `main`，工作空间为 `~/.openclaw/workspace`，状态为 `~/.openclaw/agents/main/agent`。

---

## 4. 创建智能体

### 方法一：使用向导（推荐）

```bash
openclaw agents add
openclaw agents add work
openclaw agents add personal
```

向导会引导：命名、工作空间路径、状态目录路径、渠道绑定（可选）。

### 方法二：手动创建

```bash
mkdir -p ~/.openclaw/workspace-work
cd ~/.openclaw/workspace-work
touch AGENTS.md SOUL.md USER.md

mkdir -p ~/.openclaw/agents/work/agent
mkdir -p ~/.openclaw/agents/work/sessions

vim ~/.openclaw/openclaw.json
```

在 `agents.list` 中新增：

```json5
{
  id: "work",
  name: "Work",
  workspace: "~/.openclaw/workspace-work",
  agentDir: "~/.openclaw/agents/work/agent",
}
```

### 方法三：复制现有智能体

```bash
cp -r ~/.openclaw/workspace ~/.openclaw/workspace-copy
cp -r ~/.openclaw/agents/main ~/.openclaw/agents/copy
# 在 openclaw.json 中增加 copy 的 list 项，并修改 id/workspace/agentDir
```

---

## 5. 配置智能体

### 配置文件位置

主配置：`~/.openclaw/openclaw.json`（支持 JSON5）。可通过 `OPENCLAW_CONFIG_PATH` 覆盖。

### 智能体配置字段

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `id` | string | 是 | 唯一标识，用于路由 |
| `name` | string | 否 | 显示名称 |
| `default` | boolean | 否 | 是否为默认智能体（回退路由） |
| `workspace` | string | 是 | 工作空间**绝对路径** |
| `agentDir` | string | 是 | 状态目录，**禁止**多智能体共用 |
| `model` | string | 否 | 默认模型 |

### 工作空间文件说明

| 文件 | 用途 | 修改建议 |
|------|------|----------|
| `AGENTS.md` | 智能体定义、工具、约束 | 修改角色与能力 |
| `SOUL.md` | 个性、语气、行为风格 | 修改回复风格 |
| `USER.md` | 用户偏好、上下文 | 修改用户设置 |
| `BOOTSTRAP.md` | 启动行为、初始化 | 修改初始化逻辑 |
| `HEARTBEAT.md` | 定时任务、周期行为 | 修改周期行为 |
| `TOOLS.md` | 工具使用说明 | 修改工具配置 |
| `IDENTITY.md` | 身份信息 | 可选 |

### 修改渠道绑定

在 `bindings` 中按 `channel`、`accountId`、`peer` 等配置；见下文「多智能体路由」。

### 修改渠道配置

```json5
{
  channels: {
    whatsapp: {
      accounts: {
        biz: {
          authDir: "~/.custom-credentials/whatsapp/biz",  // 覆盖默认凭据路径
        }
      }
    }
  }
}
```

### 配置热重载与验证

```bash
openclaw config validate
openclaw config reload
# 或发送 SIGHUP：kill -HUP <gateway_pid>
```

```bash
openclaw agents list --bindings
openclaw agents validate --id work
openclaw agents test-binding --agent work --channel whatsapp
```

### 删除智能体

```bash
openclaw agents remove --id work
# 可选：手动删除工作空间与状态（谨慎）
# rm -rf ~/.openclaw/workspace-work ~/.openclaw/agents/work
```

### 备份与恢复

```bash
# 备份
tar czf work-backup.tar.gz ~/.openclaw/workspace-work
tar czf work-agent-backup.tar.gz ~/.openclaw/agents/work
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 恢复：解压并恢复配置
tar xzf work-backup.tar.gz -C ~/
tar xzf work-agent-backup.tar.gz -C ~/
cp ~/.openclaw/openclaw.json.backup ~/.openclaw/openclaw.json
```

---

## 6. 多智能体路由

### 路由规则（最具体优先）

1. `peer` 匹配（精确 DM/群组/渠道 ID）
2. `parentPeer` 匹配（线程继承）
3. `guildId + roles`（Discord 角色）
4. `guildId`（Discord）
5. `teamId`（Slack）
6. 渠道的 `accountId` 匹配
7. 渠道级别匹配（`accountId: "*"`）
8. 回退到默认智能体（`default: true` 或列表首项）

### 绑定示例

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

### 匹配字段说明

| 字段 | 说明 | 示例 |
|------|------|------|
| `channel` | 渠道类型 | `whatsapp`, `telegram`, `discord` |
| `accountId` | 渠道账号标识 | `personal`, `biz`, `default` |
| `peer.kind` | 对话类型 | `direct`（私聊）, `group`（群组） |
| `peer.id` | 对话唯一标识 | 手机号、群组 ID、频道 ID |
| `guildId` | Discord 服务器 ID | `"123456789012345678"` |

---

## 7. 完整配置示例

### WhatsApp 多账号（私人 + 工作）

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

### 按渠道分流（WhatsApp 日常 + Telegram 深度）

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

## 8. 路径与部署

### 路径速查表

| 路径 | 环境变量 | 默认值 | 说明 |
|------|----------|--------|------|
| 配置文件 | `OPENCLAW_CONFIG_PATH` | `~/.openclaw/openclaw.json` | 主配置 |
| 状态目录 | `OPENCLAW_STATE_DIR` | `~/.openclaw` | 所有状态数据 |
| 工作空间 | `OPENCLAW_WORKSPACE` / `OPENCLAW_PROFILE` | `~/.openclaw/workspace` | 默认工作空间 |
| 智能体目录 | - | `~/.openclaw/agents/<agentId>/agent` | 智能体状态 |
| 会话存储 | - | `~/.openclaw/agents/<agentId>/sessions` | 聊天历史 |
| 全局技能 | - | `~/.openclaw/skills` | 共享技能目录 |

### 目录结构

```
~/.openclaw/
├── openclaw.json
├── workspace/                 # 默认工作空间 (main)
│   ├── AGENTS.md, SOUL.md, USER.md, BOOTSTRAP.md, HEARTBEAT.md
│   └── skills/
├── workspace-<agentId>/
├── agents/
│   ├── main/
│   │   ├── agent/            # auth-profiles.json, config.json
│   │   └── sessions/
│   └── <agentId>/
├── credentials/               # 渠道凭据
└── skills/                    # 全局共享技能
```

### 环境变量部署

```bash
# 开发
export OPENCLAW_CONFIG_PATH="$HOME/.openclaw/openclaw.dev.json"
export OPENCLAW_STATE_DIR="$HOME/.openclaw-dev"

# 生产
export OPENCLAW_CONFIG_PATH="/etc/openclaw/openclaw.json"
export OPENCLAW_STATE_DIR="/var/lib/openclaw"
```

### systemd（Linux）

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

### 权限与备份

```bash
chmod 700 ~/.openclaw
chmod 600 ~/.openclaw/openclaw.json
chmod 600 ~/.openclaw/agents/*/agent/auth-profiles.json
```

定时备份示例：备份 `openclaw.json`、`workspace*`、`agents` 到带日期的 tar.gz，并保留最近 N 份。

---

## 9. 模板与智能体对照

### 智能体工作空间文件结构

```
<agent-name>/
├── AGENTS.md      # 智能体定义、工具、约束
├── SOUL.md        # 个性、语气、行为风格
├── USER.md        # 用户偏好、上下文
├── BOOTSTRAP.md   # 启动行为、初始化
├── HEARTBEAT.md   # 定时任务、周期行为
├── IDENTITY.md    # 身份信息（可选）
└── TOOLS.md       # 工具使用说明（可选）
```

### 智能体类型示例（以官方路径为准）

以下为**概念示例**，路径均采用 [官方约定](https://docs.openclaw.ai/concepts/multi-agent#paths-quick-map)（`~/.openclaw/workspace-<agentId>`、`~/.openclaw/agents/<agentId>/agent`）：

| 工作空间路径（示例） | 用途说明 |
|----------------------|----------|
| `~/.openclaw/workspace` | 默认主智能体 (main)，通用对话 |
| `~/.openclaw/workspace-work` | 工作场景 |
| `~/.openclaw/workspace-personal` | 个人场景 |
| `~/.openclaw/workspace-coding` | 编程辅助 |
| `~/.openclaw/workspace-social` | 社交/内容 |

每个智能体需独立 `agentDir`（如 `~/.openclaw/agents/work/agent`），不可共用。

### 使用已有目录创建智能体

```bash
# 若你已有工作空间目录（如从某处复制或自己创建）
mkdir -p ~/.openclaw/workspace-coding
# 放入 AGENTS.md、SOUL.md、USER.md 等（参见上文「工作空间文件结构」）

# 在 openclaw.json 的 agents.list 中增加一项，例如：
# id: "coding", workspace: "~/.openclaw/workspace-coding", agentDir: "~/.openclaw/agents/coding/agent"
```

---

## 10. Multi-Agent 约束说明

### 隔离性

| 资源 | 隔离级别 | 说明 |
|------|----------|------|
| 工作空间 | ✅ 完全隔离 | 每个智能体独立目录 |
| 认证配置 | ✅ 完全隔离 | `auth-profiles.json` 按智能体 |
| 会话存储 | ✅ 完全隔离 | 会话键含 `agentId` |
| 模型配置 | ✅ 完全隔离 | 每智能体可独立配置 |
| 全局技能 | ⚠️ 只读共享 | `~/.openclaw/skills` 所有智能体可读 |
| 渠道连接 | ⚠️ 共享连接 | 连接池共享，消息路由隔离 |

### 重要约束

1. **禁止共享 agentDir**  
   多个智能体使用同一 `agentDir` 会导致认证冲突、会话混乱、配置覆盖。每个智能体必须使用独立的 `agentDir`（如 `~/.openclaw/agents/<id>/agent`）。

2. **认证不自动共享**  
   主智能体的凭据不会自动给其他智能体；需单独登录或手动复制 `auth-profiles.json`。

3. **DM 访问控制是渠道全局的**  
   配对/白名单在 `channels.<channel>` 下配置，对整个渠道生效，不是按智能体。

4. **智能体间通信需显式启用**  
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

### 性能与限制

| 指标 | 建议值 | 说明 |
|------|--------|------|
| 智能体数量 | 5–10 个 | 单网关实例 |
| 并发会话 | 每智能体 10–20 | 视模型与硬件而定 |
| 内存占用 | 每智能体约 100MB | 工作空间 + 会话缓存 |
| 启动时间 | 每智能体约 +2–5s | 视工作空间大小而定 |

### 安全与最佳实践

- 工作空间为默认 cwd，但非硬沙盒；绝对路径可访问主机其他位置；如需严格隔离可启用 `sandbox`。
- 敏感文件权限：`chmod 600` 用于 `openclaw.json` 和 `auth-profiles.json`。
- 配置可纳入版本控制，但需将 `agents/*/agent/auth-profiles.json` 和 `credentials/**` 加入 `.gitignore`。

---

## 11. 故障排查

### 常见问题

| 现象 | 处理 |
|------|------|
| 路由错误 | `openclaw agents list --bindings` 检查绑定；`openclaw gateway --verbose` 看路由日志 |
| 认证失败 | 检查 `~/.openclaw/agents/<agentId>/agent/auth-profiles.json` 是否存在；`openclaw channels login` 重新登录 |
| 会话混乱 | `rm -rf ~/.openclaw/agents/<agentId>/sessions/*` 后重启网关 |
| 配置不生效 | `openclaw config validate`；`openclaw config reload` 或重启网关 |

### 调试命令

```bash
openclaw gateway --verbose
openclaw channels status --probe
openclaw agents test-binding --agent <id> --channel <type>
openclaw config export --output debug.json
```

### 安装与启动问题

- **安装失败**：确认 Node.js ≥ 18（`node --version`）、npm 权限、必要时 `npm cache clean --force`。
- **启动失败**：检查端口占用（如 `lsof -i :8080`）、配置校验、详细日志。

### 更新与卸载

```bash
# 更新
curl -fsSL https://openclaw.ai/install.sh | bash
# 或 npm update -g openclaw / brew upgrade openclaw

# 卸载
curl -fsSL https://openclaw.ai/uninstall.sh | bash
# 或 npm uninstall -g openclaw；谨慎：rm -rf ~/.openclaw
```

---

## 12. 相关链接

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [Multi-Agent Routing](https://docs.openclaw.ai/concepts/multi-agent)
- [渠道配置](https://docs.openclaw.ai/channels)
- [文档索引 llms.txt](https://docs.openclaw.ai/llms.txt)

---

**最后更新**: 2026-02-20
