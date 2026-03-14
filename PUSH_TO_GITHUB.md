# 推送到 GitHub

由于 gh CLI 未安装，请手动执行以下步骤：

## 方式一：在 GitHub 网页创建仓库

1. 打开 https://github.com/new
2. 仓库名：`claude-skill-ai-news`
3. 描述：`AI News Skill for Claude Code - 自动抓取、分析 AI 领域最新动态`
4. 选择 Public
5. 不要勾选 "Add a README file"
6. 点击 "Create repository"

然后在终端执行：

```bash
cd ~/Documents/Claude/claude-skill-ai-news
git remote add origin https://github.com/你的用户名/claude-skill-ai-news.git
git push -u origin main
```

## 方式二：安装 gh CLI 后自动创建

```bash
# 安装 gh
brew install gh

# 登录
gh auth login

# 创建并推送
cd ~/Documents/Claude/claude-skill-ai-news
gh repo create claude-skill-ai-news --public --source=. --push --description "AI News Skill for Claude Code - 自动抓取、分析 AI 领域最新动态"
```

## 仓库结构

```
claude-skill-ai-news/
├── README.md           # 项目说明
├── ai-news/
│   └── SKILL.md        # 主技能文件
├── docs/
│   └── DESIGN.md       # 设计思路文档
└── scripts/
    └── fetch-raw-data.sh  # 数据抓取脚本
```
