# 🤖 AI News Skill for Claude Code

一个为 Claude Code 设计的 AI 新闻智能简报技能，自动抓取、分析、总结 AI 领域最新动态。

## 功能特点

- 📰 **多源聚合**：整合 Twitter/X、RSS、YouTube、GitHub 等多个信息源
- 🧠 **智能分析**：对重点新闻进行影响推演和观点输出
- 🛠️ **工具发现**：主动搜索热门 AI 工具、Skill、MCP Server
- 🎯 **个性化推荐**：根据用户背景筛选适合的工具
- 📝 **双模式输出**：完整简报存 Obsidian，快讯摘要留对话

## 安装

```bash
# 方式一：直接复制到 Claude skills 目录
cp -r ai-news ~/.claude/skills/

# 方式二：使用 Claude Code 安装（如果支持）
claude skill install shakely/ai-news
```

## 使用方式

```
/ai-news        # 完整简报（保存到 Obsidian）
/ai-news quick  # 快速模式（仅 Top 5）
/新闻           # 完整简报快捷方式
/快讯           # Top 5 快捷方式
```

## 依赖

- **RSSHub**：本地 Docker 运行，用于抓取 RSS 数据
  ```bash
  docker run -d --name rsshub -p 1200:1200 diygod/rsshub
  ```
- **数据抓取脚本**：`fetch-raw-data.sh`（见 `scripts/` 目录）

## 输出示例

### 对话中展示（快讯摘要）

```markdown
# 🤖 AI 快讯 - 03月14日

1. **Claude 支持交互式图表** - 可在对话中直接生成图表和图示 [链接]
2. **OpenAI 收购 Promptfoo** - 加强 Agent 安全测试能力 [链接]
3. **Karpathy 谈 autoresearch** - 下一步是异步大规模协作 [链接]
4. **GPT-5.4 用户反馈积极** - Sam Altman 称是最喜欢的对话模型 [链接]
5. **Anthropic 扩展澳新市场** - 悉尼办公室即将开设 [链接]

💡 **今日一句**：Claude 的交互式图表功能值得立即尝试

📄 完整简报已保存：`news/2026-03-14_智能简报.md`
```

### 完整简报（保存到 Obsidian）

包含 5 个板块：
1. 📌 今日重点（含影响推演和观点）
2. 🔥 公司动态
3. 🇨🇳 中文圈热议
4. 🛠️ AI 工具与技巧
5. 🧠 今日总结

## 文件结构

```
ai-news/
├── SKILL.md           # 主技能文件
├── README.md          # 说明文档
├── scripts/
│   └── fetch-raw-data.sh  # 数据抓取脚本
└── docs/
    └── DESIGN.md      # 设计思路文档
```

## 自定义

### 修改数据源

编辑 `scripts/fetch-raw-data.sh` 中的 Twitter 账号列表：

```bash
# Twitter AI 公司
for handle in AnthropicAI claudeai OpenAI deepmind; do
    ...
done

# Twitter 中文圈
for handle in dotey op7418 xiaohuggg ...; do
    ...
done
```

### 修改用户背景

编辑 `SKILL.md` 中的「用户背景」部分，调整个性化推荐逻辑。

## 版本历史

- **v4.1** (2026-03-14)
  - 新增深度分析：重点新闻影响推演
  - 新增工具发现：主动搜索 GitHub/YouTube/X
  - 优化上下文管理：完整简报存文件，对话只展示快讯
- **v4.0** (2026-03-14)
  - 简化流程为 4 步
  - 精简输出格式
- **v3.0** (2026-03-14)
  - 初始版本

## License

MIT
