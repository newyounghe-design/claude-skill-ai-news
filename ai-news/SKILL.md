---
description: AI 新闻智能简报 - 自动抓取、翻译、分析 AI 领域最新动态
user_invocable: true
argument-hint: "[quick|full|tools|history] - 不同模式"
---

# AI 新闻智能简报 v4.2

## ⚙️ 配置（使用前请确认路径）

| 配置项 | 当前值 | 说明 |
|--------|--------|------|
| 简报保存目录 | `/Users/shakely2020/Documents/obsidian笔记库/100-Project/AI之路/news/` | 完整简报保存位置 |
| 数据目录 | `/Users/shakely2020/Documents/Claude/ai-news-aggregator/data/` | RSS 原始数据 |
| 抓取脚本 | `/Users/shakely2020/Documents/Claude/ai-news-aggregator/fetch-raw-data.sh` | 数据抓取脚本 |

> **分享给他人时**：请修改上述路径为目标系统的实际路径

---

## 命令一览

| 命令 | 功能 | 示例 |
|------|------|------|
| `/ai-news` | 生成完整简报（存文件）+ 快讯摘要（展示） | `/ai-news` |
| `/ai-news quick` | 仅生成 Top 5 快讯（不存文件） | `/ai-news quick` |
| `/ai-news tools` | 仅搜索热门 AI 工具推荐 | `/ai-news tools` |
| `/ai-news history` | 查看最近的简报列表 | `/ai-news history` |
| `/新闻` | `/ai-news` 的快捷方式 | `/新闻` |
| `/快讯` | `/ai-news quick` 的快捷方式 | `/快讯` |

---

## 执行原则

**上下文保持干净**：
- 不要在对话中输出原始 JSON 数据
- 不要逐条列出所有新闻
- 中间处理过程静默执行，不需要向用户汇报
- **完整简报直接保存到 Obsidian，对话中只展示快讯摘要**

---

## 操作流程

### `/ai-news` — 生成完整简报

#### Step 1：抓取 RSS 数据（静默执行）

```bash
/Users/shakely2020/Documents/Claude/ai-news-aggregator/fetch-raw-data.sh
```

**失败处理：**
- 如果报错 "RSSHub 未运行"，提示用户：`docker start rsshub`
- 如果部分源失败，继续用可用数据

#### Step 2：主动搜索工具资讯（静默执行）

使用 WebSearch 搜索以下内容（每个搜索独立执行）：

**2.1 GitHub Trending AI 工具**
```
搜索词：site:github.com AI tool OR MCP server OR Claude skill trending 2026
```
关注：
- 新的 Claude Code Skill
- MCP Server 项目
- AI Agent 框架
- 提示词工程工具

**2.2 YouTube AI 工具教程**
```
搜索词：site:youtube.com AI tools tutorial 2026 OR Claude Code tips OR MCP server
```
关注频道：Fireship、AI Advantage、All About AI、Matt Wolfe

**2.3 X/Twitter 工具推荐**
从 RSS 数据中提取带有 `github.com` 链接的推文，特别关注：
- 9hills、shao__meng、Barret_China 推荐的工具
- 带有 #AITools #MCP #ClaudeCode 标签的内容

#### Step 3：读取并分析数据（静默执行）

读取 JSON 文件：`{数据目录}/{今天日期}_raw.json`

**重要：不要在对话中输出原始数据，直接在内部处理**

**数据清洗（必须执行）：**
1. 移除 HTML：`<br>`, `<img>`, `<video>`, `&lt;`, `&gt;`, `&amp;`, `&#39;` → 对应字符
2. 跳过：纯 RT 无评论、空 title、纯表情
3. 去重：同一事件保留信息最完整的一条

**重要性分级：**
- **S 级**：新模型发布、重大产品功能、公司战略（收购/融资 >$1B）、安全政策事件
- **A 级**：功能更新、技术论文、大佬重要观点、开源项目发布
- **B 级**：工具推荐、中文圈讨论、教程视频
- **C 级**：日常转发、非 AI 内容（跳过）

#### Step 4：生成并保存简报

1. **完整简报** → 保存到 `{简报保存目录}/{YYYY-MM-DD}_智能简报.md`
2. **快讯摘要** → 在对话中展示给用户

**对话中展示的内容：**
```markdown
# 🤖 AI 快讯 - {MM月DD日}

1. **{标题}** - {一句话} [链接]
2. ...
3. ...
4. ...
5. ...

💡 **今日一句**：{最值得关注的一件事}

📄 完整简报已保存：`news/{YYYY-MM-DD}_智能简报.md`
```

---

### `/ai-news quick` — 仅生成快讯

跳过 Step 2（工具搜索），只执行 Step 1、3，输出 Top 5 快讯，不保存文件。

---

### `/ai-news tools` — 工具推荐

只执行 Step 2（工具搜索），输出：

```markdown
# 🛠️ 本周热门 AI 工具

## Claude Code Skills
- **{skill-name}**：{作用}
  - 安装：`claude skill install {slug}`
  - **为什么适合你**：{原因}

## MCP Server
- **{mcp-name}**：{作用}
  - 安装：`{命令}`
  - **为什么适合你**：{原因}

## 其他工具
| 工具名 | 类型 | 作用 | 适合你吗？ | 链接 |
|--------|------|------|-----------|------|
| ... | ... | ... | ✅/❌ | ... |
```

---

### `/ai-news history` — 查看历史

列出最近 10 份简报：

```bash
ls -lt {简报保存目录}/*.md | head -10
```

输出格式：
```markdown
# 📚 最近的 AI 简报

| 日期 | 文件名 |
|------|--------|
| 2026-03-14 | 2026-03-14_智能简报.md |
| 2026-03-13 | 2026-03-13_智能简报.md |
| ... | ... |

💡 使用 `open {文件路径}` 在 Obsidian 中查看
```

---

## 输出格式

### 完整简报模板（保存到文件）

```markdown
---
date: {YYYY-MM-DD}
tags: [ai-news, daily-briefing]
created: {YYYY-MM-DD HH:MM}
---

# 🤖 AI 简报 - {MM月DD日}

## 📌 今日重点

> {一句话总结今天最重要的事}

### 1. {新闻标题}
{2-3 句话说明} [→ 原文]({url})

#### 🔮 影响推演
- **短期（1-3个月）**：{具体会发生什么变化}
- **中期（3-12个月）**：{行业格局如何演变}
- **对你的影响**：{作为 Claude 用户/内容创作者，你应该怎么做}

#### 💭 我的观点
{2-3 句话的独立判断，可以是看好/看衰/存疑，要有理由}

### 2. ...
（共 3-5 条，S 级必须有完整影响推演，A 级至少有"对你的影响"）

---

## 🔥 公司动态

**Anthropic/Claude**
- {要点}

**OpenAI**
- {要点}

**其他**
- {要点}

---

## 🇨🇳 中文圈热议

{汇总宝玉、歸藏等人的讨论，提炼 2-3 个热点}

---

## 🛠️ AI 工具与技巧

### 本周热门工具

| 工具名 | 类型 | 作用 | 适合你吗？ | 链接 |
|--------|------|------|-----------|------|
| {name} | Skill/MCP/CLI/App | {一句话描述} | ✅/❌ {原因} | [GitHub]({url}) |

### Claude Code Skills 推荐
- **{skill-name}**：{作用}
  - 安装：`claude skill install {slug}`
  - 适合场景：{什么时候用}
  - **为什么适合你**：{结合用户背景说明}

### MCP Server 推荐
- **{mcp-name}**：{作用}
  - 安装：`{安装命令}`
  - 适合场景：{什么时候用}
  - **为什么适合你**：{结合用户背景说明}

### YouTube 教程推荐
- [{视频标题}]({url}) - {频道名}
  - {一句话说明为什么值得看}
  - 时长：{xx分钟}

---

## 🧠 今日总结

### 趋势判断
{用 3-5 句话总结今天 AI 领域的整体动向，要有观点，不要只是罗列}

### 行动建议
- 🛠️ **立即尝试**：{今天就可以做的事}
- 📚 **本周关注**：{值得持续跟进的内容}

---

*{HH:MM} 生成 | 数据来源: RSSHub + WebSearch*
```

---

## 特殊情况处理

**无重要新闻时：**
```
今天 AI 圈比较平静。值得关注：{一条 B 级内容}
```

**WebSearch 失败时：**
- 跳过工具搜索步骤，用 RSS 数据中的工具推荐
- 在简报末尾注明：`⚠️ 工具搜索不可用，仅展示 RSS 数据`

**数据不完整时：**
在简报末尾注明：`⚠️ 部分数据源不可用：{列出}`

**RSSHub 未运行时：**
```
❌ RSSHub 未运行，请先启动：
docker start rsshub
```

---

## 用户背景（个性化推荐依据）

- **身份**：AI 应用开发者、内容创作者
- **主力工具**：Claude Code、Obsidian
- **内容方向**：电影解说短视频（小楼风格）
- **技术兴趣**：AI 工具、提示词工程、Agent 开发、MCP 生态

### 工具推荐优先级

**高度相关（✅ 推荐）：**
1. Claude Code Skill - 直接提升开发效率
2. MCP Server - 扩展 Claude 能力
3. 视频/内容创作工具 - 辅助电影解说
4. Obsidian 插件 - 知识管理增强
5. 提示词工程工具 - 优化 AI 交互

**一般相关（⚠️ 可选）：**
- 通用开发工具
- 其他 AI 模型的工具

**不推荐（❌）：**
- 需要高额付费且无明显优势
- 与工作流完全无关
- 过于早期、不稳定的项目
- 已有更好替代方案的工具

### 推荐说明模板

当推荐工具时，必须说明：
1. 这个工具做什么
2. 为什么适合/不适合用户
3. 具体使用场景举例
