# 🤖 AI News Skill for Claude Code

一个为 Claude Code 设计的 AI 新闻智能简报技能，自动抓取、分析、总结 AI 领域最新动态。

---

## 创作初衷

作为一个 AI 应用开发者和内容创作者，我每天需要跟踪 AI 领域的最新动态。但信息源太分散了：

- Twitter/X 上的 AI 大佬动态（Sam Altman、Karpathy、Yann LeCun...）
- 各公司官方博客（Anthropic、OpenAI、DeepMind...）
- GitHub 上的新项目和工具
- YouTube 上的教程视频
- 中文圈的讨论（宝玉、歸藏、9hills...）

手动浏览这些信息源既耗时又容易遗漏重要内容。我需要一个工具来：

1. **自动聚合**：把分散的信息源整合到一起
2. **智能筛选**：区分重要新闻和日常噪音
3. **深度分析**：不只是「发生了什么」，还要「意味着什么」
4. **个性化推荐**：根据我的工作背景推荐相关工具

于是，这个 Skill 诞生了。

---

## 创作过程

### 第一阶段：基础版本（v1.0 - v2.0）

最初的版本很简单：用 RSSHub 抓取数据，然后让 Claude 总结。

**遇到的问题**：
- 信息太多，没有重点
- 只是罗列新闻，没有分析
- 全部输出到对话，上下文很快就满了

### 第二阶段：增加筛选和分析（v3.0）

引入了重要性分级（S/A/B/C），只报道重要新闻。添加了影响推演和观点输出。

**重要性分级标准**：
- **S 级**：新模型发布、重大产品功能、公司战略（收购/融资 >$1B）
- **A 级**：功能更新、技术论文、大佬重要观点
- **B 级**：工具推荐、中文圈讨论
- **C 级**：日常转发（跳过）

**遇到的问题**：
- 输出太长，污染对话上下文
- 后续对话质量下降

### 第三阶段：分离存储（v4.0）

关键洞察：**完整简报和对话展示是两个不同的需求**。

解决方案：
- 完整简报 → 保存到 Obsidian 文件（永久存储）
- 快讯摘要 → 展示在对话中（保持上下文干净）

这样既保留了详细内容，又不会污染对话上下文。

### 第四阶段：工具发现（v4.1 - v4.2）

被动等待 RSS 推送不够，需要主动搜索：

- **GitHub Trending**：新的 Skill、MCP Server、Agent 框架
- **YouTube**：AI 工具教程、Claude Code 技巧
- **X/Twitter**：带 github.com 链接的推文

同时增加了个性化推荐逻辑，根据用户背景判断工具是否适合。

---

## 设计原则

1. **信息密度优先**：宁可少报，不可乱报
2. **观点要有依据**：每个判断都要说明理由
3. **个性化是核心**：通用推荐没有价值
4. **上下文是资源**：不要浪费在中间数据上
5. **文件是持久化**：重要内容必须落盘

详细设计思路见 [docs/DESIGN.md](docs/DESIGN.md)

---

## 功能特点

- 📰 **多源聚合**：整合 Twitter/X、RSS、YouTube、GitHub 等多个信息源
- 🧠 **智能分析**：对重点新闻进行影响推演和观点输出
- 🛠️ **工具发现**：主动搜索热门 AI 工具、Skill、MCP Server
- 🎯 **个性化推荐**：根据用户背景筛选适合的工具
- 📝 **双模式输出**：完整简报存 Obsidian，快讯摘要留对话

---

## 安装

```bash
# 方式一：直接复制到 Claude skills 目录
cp -r ai-news ~/.claude/skills/

# 方式二：使用 Claude Code 安装（如果支持）
claude skill install newyounghe-design/ai-news
```

---

## 使用方式

| 命令 | 功能 | 说明 |
|------|------|------|
| `/ai-news` | 完整简报 | 保存到 Obsidian + 对话展示快讯 |
| `/ai-news quick` | 快速模式 | 仅 Top 5，不保存文件 |
| `/ai-news tools` | 工具推荐 | 搜索热门 AI 工具 |
| `/ai-news history` | 历史记录 | 查看最近的简报列表 |
| `/新闻` | 快捷方式 | 等同于 `/ai-news` |
| `/快讯` | 快捷方式 | 等同于 `/ai-news quick` |

---

## 依赖

- **RSSHub**：本地 Docker 运行，用于抓取 RSS 数据
  ```bash
  docker run -d --name rsshub -p 1200:1200 diygod/rsshub
  ```
- **数据抓取脚本**：`fetch-raw-data.sh`（见 `scripts/` 目录）

---

## 输出示例

### 对话中展示（快讯摘要）

```markdown
# 🤖 AI 快讯 - 03月14日

1. **Claude 支持交互式图表** - 可在对话中直接生成图表和图示 [链接]
2. **OpenAI 收购 Promptfoo** - 加强 Agent 安全测试能力 [链接]
3. **Karpathy 谈 autoresearch** - 下一步是异步大规模协作 [链接]
4. **GPT-5.4 用户反馈积极** - Sam Altman 称是最喜欢的对话模型 [链接]
5. **Claude 100万上下文正式开放** - 召回率 78.3% 远超 GPT-5.4 [链接]

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

完整示例见 [examples/2026-03-14_sample.md](examples/2026-03-14_sample.md)

---

## 文件结构

```
claude-skill-ai-news/
├── README.md              # 项目说明（本文件）
├── ai-news/
│   └── SKILL.md           # 主技能文件
├── docs/
│   └── DESIGN.md          # 设计思路文档
├── scripts/
│   └── fetch-raw-data.sh  # 数据抓取脚本
└── examples/
    └── 2026-03-14_sample.md  # 输出示例
```

---

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

编辑 `ai-news/SKILL.md` 中的「用户背景」部分，调整个性化推荐逻辑。

### 修改保存路径

编辑 `ai-news/SKILL.md` 开头的配置表，修改简报保存目录和数据目录。

---

## 版本历史

- **v4.2** (2026-03-14)
  - 增加命令系统（类似 /handoff）
  - 优化配置表格式
  - 完善文档和示例
- **v4.1** (2026-03-14)
  - 新增深度分析：重点新闻影响推演
  - 新增工具发现：主动搜索 GitHub/YouTube/X
  - 优化上下文管理：完整简报存文件，对话只展示快讯
- **v4.0** (2026-03-14)
  - 简化流程为 4 步
  - 精简输出格式
- **v3.0** (2026-03-14)
  - 初始版本

---

## License

MIT
