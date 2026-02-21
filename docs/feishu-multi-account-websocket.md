# 飞书多账号 WebSocket 长连接配置说明

根据 [OpenClaw 飞书文档](https://docs.openclaw.ai/channels/feishu)，**长连接必须先让 OpenClaw 连上飞书，再在飞书控制台保存「使用长连接接收事件」**，否则长连接会保存失败。

## 官方要求的顺序

文档 Step 6 明确要求：

> ⚠️ **在配置事件订阅前，请务必确保：**
> 1. 已运行 `openclaw channels add` 添加该 Feishu 应用（或该账号已在 config 中且网关会为其建连）
> 2. **网关处于运行状态**（`openclaw gateway status`）
>
> 然后在 **事件订阅** 页面：选择 **使用长连接接收事件**，添加事件 `im.message.receive_v1`。  
> **若网关未启动，长连接设置可能保存失败。**

即：**先有 OpenClaw 侧配置并启动网关（WebSocket 先连上），再在飞书后台为该应用开启长连接。**

## main 与其他账号的差异

- **main**：安装飞书插件时通过 `openclaw channels add`（或 onboarding）配置，网关启动后为该 appId 建立 WebSocket，再在飞书控制台为该应用开启长连接 → 所以 main 能收消息。
- **其余 13 个账号**：是后来在 `openclaw.json` 里手写 `channels.feishu.accounts` 的，**没有**对每个应用单独走一遍「先让网关连上、再在飞书开长连接」的流程，所以长连接未生效。

## 推荐做法：每个应用按「先连上再开长连接」做一遍

对**除 main 以外的每个飞书应用**按下面顺序做一次（共 13 次）：

### 1. 确认该账号已在 OpenClaw 配置中

你的 `~/.openclaw/openclaw.json` 里 `channels.feishu.accounts` 已包含所有账号（含 `connectionMode: "websocket"`），无需再改。

### 2. 启动网关

```bash
openclaw gateway status   # 确认已在运行
# 若未运行：
openclaw gateway
```

保证网关运行后，OpenClaw 会为配置中的每个飞书账号发起 WebSocket 连接。

### 3. 为该应用在飞书后台开启长连接

- 打开该应用在飞书开放平台的「事件订阅」页面：  
  `https://open.feishu.cn/app/<该应用的 app_id>/event`
- 选择 **「使用长连接接收事件」**（WebSocket）
- 添加事件：`im.message.receive_v1`
- 保存

建议在网关已运行、且日志里能看到该账号的 WebSocket 连接尝试或已连接时，再去飞书保存长连接。

### 4. 若仍不生效：用 CLI 为每个账号走一遍「添加渠道」

若仅改 config 仍无法让某应用的长连接生效，可对该应用再跑一次「添加渠道」，让 OpenClaw 明确为该 appId 建连，然后再到飞书开长连接：

```bash
# 每次只处理一个飞书应用
openclaw channels add
```

- 选择 **Feishu**
- 输入**该应用**的 App ID 和 App Secret（见下表）
- 若 CLI 询问 account id，可填对应智能体 id（如 `technical-director`），避免覆盖 main

然后：

```bash
openclaw gateway restart
```

再打开该应用的飞书控制台 → 事件订阅 → 使用长连接接收事件 → 添加 `im.message.receive_v1` → 保存。

### 13 个应用的 App ID 速查

| 账号 id             | App ID              |
|---------------------|---------------------|
| technical-director  | cli_a9130b84a0f89cb5 |
| project-manager     | cli_a91ded35c1389cd6 |
| product-manager     | cli_a91df99fabf8dcd1 |
| system-architect    | cli_a91deea7a078dcba |
| domain-expert       | cli_a91def211478dcc9 |
| ux-designer         | cli_a91df5b2efb89cd4 |
| ui-designer         | cli_a91dfa4714789cb0 |
| backend-engineer    | cli_a91df4a59738dcd3 |
| database-engineer   | cli_a91df50f4ab89cb1 |
| frontend-engineer   | cli_a91dfb1bd078dcc5 |
| mobile-engineer     | cli_a91de84b36f8dcb1 |
| qa-engineer         | cli_a91df7201138dccd |
| ops-engineer        | cli_a91df4116df8dcd3 |

## 小结

- **飞书 WebSocket 长连接**：需要 **OpenClaw 先连上（网关运行 + 该账号在 config 中）**，再在飞书控制台为该应用开启「使用长连接接收事件」。
- main 能用的原因：安装飞书插件时通过向导/CLI 配置并启动了网关，再在 main 对应应用下开了长连接。
- 其余 13 个应用：按上面顺序逐个「确认 config → 启动/重启网关 → 飞书控制台开长连接」，必要时用 `openclaw channels add` 再登记一次该应用后再开长连接。
