#!/bin/bash
# AI 新闻原始数据抓取脚本
# 输出 JSON 格式，供 Claude 分析

set -e

RSSHUB_BASE="http://localhost:1200"
DATA_DIR="/Users/shakely2020/Documents/Claude/ai-news-aggregator/data"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)

mkdir -p "$DATA_DIR"

# 检查 RSSHub
check_rsshub() {
    if ! curl -s "$RSSHUB_BASE" > /dev/null 2>&1; then
        echo "❌ RSSHub 未运行" >&2
        exit 1
    fi
}

# 提取 RSS 数据（标题+链接+描述）
fetch_rss_json() {
    local source="$1"
    local url="$2"
    local limit="${3:-10}"

    local content=$(curl -s "${RSSHUB_BASE}${url}" 2>/dev/null)

    if echo "$content" | grep -q "<item>"; then
        echo "$content" | python3 -c "
import sys
import re
import json

content = sys.stdin.read()
items = re.findall(r'<item>(.*?)</item>', content, re.DOTALL)[:${limit}]

results = []
for item in items:
    title = re.search(r'<title>(?:<!\[CDATA\[)?(.*?)(?:\]\]>)?</title>', item)
    link = re.search(r'<link>(.*?)</link>', item)
    desc = re.search(r'<description>(?:<!\[CDATA\[)?(.*?)(?:\]\]>)?</description>', item, re.DOTALL)

    results.append({
        'title': title.group(1).strip() if title else '',
        'link': link.group(1).strip() if link else '',
        'description': (desc.group(1).strip()[:500] if desc else '')[:500]
    })

for r in results:
    print(json.dumps(r, ensure_ascii=False))
" 2>/dev/null
    fi
}

# 生成完整 JSON 数据
generate_json() {
    local output_file="$DATA_DIR/${DATE}_raw.json"

    {
        echo "{"
        echo "  \"date\": \"$DATE\","
        echo "  \"time\": \"$TIME\","
        echo "  \"sources\": {"

        # Twitter AI 公司
        echo "    \"twitter_companies\": ["
        for handle in AnthropicAI claudeai OpenAI deepmind; do
            fetch_rss_json "Twitter" "/twitter/user/${handle}" 3
        done | jq -s '.' | sed 's/^\[/      /;s/^\]/    ]/'
        echo "    ],"

        # Twitter AI 领袖
        echo "    \"twitter_leaders\": ["
        for handle in sama karpathy ylecun DrJimFan EMostaque; do
            fetch_rss_json "Twitter" "/twitter/user/${handle}" 3
        done | jq -s '.' | sed 's/^\[/      /;s/^\]/    ]/'
        echo "    ],"

        # Twitter 中文圈
        echo "    \"twitter_chinese\": ["
        for handle in dotey op7418 xiaohuggg oran_ge AiBreakfast tuturetom 9hills FinanceYF5 Gorden_Sun Barret_China AiToolsClub shao__meng; do
            fetch_rss_json "Twitter" "/twitter/user/${handle}" 2
        done | jq -s '.' | sed 's/^\[/      /;s/^\]/    ]/'
        echo "    ],"

        # Anthropic 官方
        echo "    \"anthropic\": ["
        fetch_rss_json "Anthropic" "/anthropic/news" 5 | jq -s '.' | sed 's/^\[/      /;s/^\]/    ]/'
        echo "    ],"

        # HuggingFace 论文
        echo "    \"huggingface\": ["
        fetch_rss_json "HuggingFace" "/huggingface/daily-papers" 10 | jq -s '.' | sed 's/^\[/      /;s/^\]/    ]/'
        echo "    ],"

        # 36kr
        echo "    \"36kr\": ["
        fetch_rss_json "36kr" "/36kr/newsflashes" 15 | jq -s '.' | sed 's/^\[/      /;s/^\]/    ]/'
        echo "    ],"

        # YouTube
        echo "    \"youtube\": ["
        for handle in "@AndrejKarpathy" "@lexfridman" "@TwoMinutePapers" "@YannicKilcher" "@Fireship" "@aiadvantage"; do
            fetch_rss_json "YouTube" "/youtube/user/${handle}" 2
        done | jq -s '.' | sed 's/^\[/      /;s/^\]/    ]/'
        echo "    ]"

        echo "  }"
        echo "}"
    } > "$output_file"

    echo "$output_file"
}

check_rsshub
generate_json
