#!/usr/bin/env bash
# 使用 openclaw agents add 添加 IT 团队 13 个智能体（与 OpenClaw Docs 一致）
# 若智能体已存在会提示 "Agent ... already exists."，可忽略。
# 用法: bash scripts/agents-add-it-team.sh

set -e
OPENCLAW_CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-$HOME/.openclaw/openclaw.json}"

echo "Adding IT team agents (openclaw agents add) ..."

openclaw agents add technical-director  --workspace "$HOME/.openclaw/workspace-technical-director"  --agent-dir "$HOME/.openclaw/agents/technical-director/agent"   --model zai/glm-4.7  --bind feishu:technical-director  --non-interactive || true
openclaw agents add project-manager     --workspace "$HOME/.openclaw/workspace-project-manager"     --agent-dir "$HOME/.openclaw/agents/project-manager/agent"       --model zai/glm-4.7  --bind feishu:project-manager       --non-interactive || true
openclaw agents add product-manager    --workspace "$HOME/.openclaw/workspace-product-manager"    --agent-dir "$HOME/.openclaw/agents/product-manager/agent"      --model zai/glm-4.7  --bind feishu:product-manager      --non-interactive || true
openclaw agents add system-architect   --workspace "$HOME/.openclaw/workspace-system-architect"   --agent-dir "$HOME/.openclaw/agents/system-architect/agent"   --model zai/glm-5   --bind feishu:system-architect   --non-interactive || true
openclaw agents add domain-expert     --workspace "$HOME/.openclaw/workspace-domain-expert"     --agent-dir "$HOME/.openclaw/agents/domain-expert/agent"       --model zai/glm-5   --bind feishu:domain-expert       --non-interactive || true
openclaw agents add ux-designer        --workspace "$HOME/.openclaw/workspace-ux-designer"        --agent-dir "$HOME/.openclaw/agents/ux-designer/agent"          --model minimax-cn/MiniMax-M2.5  --bind feishu:ux-designer          --non-interactive || true
openclaw agents add ui-designer        --workspace "$HOME/.openclaw/workspace-ui-designer"        --agent-dir "$HOME/.openclaw/agents/ui-designer/agent"          --model minimax-cn/MiniMax-M2.5  --bind feishu:ui-designer          --non-interactive || true
openclaw agents add backend-engineer   --workspace "$HOME/.openclaw/workspace-backend-engineer"   --agent-dir "$HOME/.openclaw/agents/backend-engineer/agent"   --model zai/glm-4.7 --bind feishu:backend-engineer   --non-interactive || true
openclaw agents add database-engineer  --workspace "$HOME/.openclaw/workspace-database-engineer"  --agent-dir "$HOME/.openclaw/agents/database-engineer/agent"  --model zai/glm-4.7 --bind feishu:database-engineer  --non-interactive || true
openclaw agents add frontend-engineer  --workspace "$HOME/.openclaw/workspace-frontend-engineer"  --agent-dir "$HOME/.openclaw/agents/frontend-engineer/agent"  --model minimax-cn/MiniMax-M2.5  --bind feishu:frontend-engineer  --non-interactive || true
openclaw agents add mobile-engineer    --workspace "$HOME/.openclaw/workspace-mobile-engineer"    --agent-dir "$HOME/.openclaw/agents/mobile-engineer/agent"      --model minimax-cn/MiniMax-M2.5  --bind feishu:mobile-engineer      --non-interactive || true
openclaw agents add qa-engineer        --workspace "$HOME/.openclaw/workspace-qa-engineer"        --agent-dir "$HOME/.openclaw/agents/qa-engineer/agent"          --model zai/glm-4.7 --bind feishu:qa-engineer          --non-interactive || true
openclaw agents add ops-engineer       --workspace "$HOME/.openclaw/workspace-ops-engineer"       --agent-dir "$HOME/.openclaw/agents/ops-engineer/agent"         --model zai/glm-4.7 --bind feishu:ops-engineer         --non-interactive || true

echo "Done. Run: openclaw agents list --bindings"
