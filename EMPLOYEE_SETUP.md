# Token Tracker — Employee Setup Guide

Track your AI coding tool usage (Claude Code, Cursor, Kiro, Gemini, Codex, etc.) and see how you compare with the team on the company leaderboard.

**Dashboard**: https://token-tracker-staging.mumzstage.com

---

## Quick Start (2 minutes)

### 1. Install the CLI

Requires **Node.js 20+**. Check with `node --version`.

```bash
npm i -g tokentracker-cli
```

### 2. Initialize hooks

```bash
tokentracker init
```

This detects your installed AI tools and sets up lightweight hooks to track token usage. Nothing is changed until you confirm.

### 3. Configure cloud sync

```bash
# Set the company backend URL and your device token
cat > ~/.tokentracker/tracker/config.json << 'EOF'
{"baseUrl":"https://v3fpjv72.us-east.insforge.app"}
EOF
```

### 4. Sign in on the dashboard

1. Open https://token-tracker-staging.mumzstage.com
2. Click **Sign in with Google** using your `@mumzworld.com` account
3. You're in — your dashboard is ready

### 5. Get your device token

Ask your team lead or IT for a device token, then add it to your config:

```bash
# Replace YOUR_DEVICE_TOKEN with the token you received
cat > ~/.tokentracker/tracker/config.json << EOF
{"baseUrl":"https://v3fpjv72.us-east.insforge.app","deviceToken":"YOUR_DEVICE_TOKEN"}
EOF
```

### 6. Sync your data

```bash
tokentracker sync
```

Your usage data will appear on the dashboard and leaderboard within 5 minutes.

---

## Daily Usage

You don't need to do anything — hooks track usage automatically. To manually sync:

```bash
tokentracker sync          # Push latest usage to cloud
tokentracker serve         # Open local dashboard at localhost:7680
tokentracker status        # Check which AI tools are being tracked
tokentracker doctor        # Diagnose any issues
```

---

## Supported AI Tools

| Tool | Detection |
|---|---|
| Claude Code | ✅ Auto |
| Cursor | ✅ Auto |
| Kiro | ✅ Auto |
| Codex CLI | ✅ Auto |
| Gemini CLI | ✅ Auto |
| OpenCode | ✅ Auto |
| GitHub Copilot | ✅ Auto |

All hooks are installed automatically by `tokentracker init`.

---

## What Gets Tracked

- ✅ Token counts (input, output, cached, reasoning)
- ✅ Model names and timestamps
- ✅ Cost estimates
- ❌ **Never** prompts, responses, or file contents

All data stays local until you run `sync`. Only token counts and timestamps are uploaded.

---

## Troubleshooting

**`tokentracker: command not found`**
```bash
npm i -g tokentracker-cli
```

**`sync` says "no device token"**
Check your config file:
```bash
cat ~/.tokentracker/tracker/config.json
```
Make sure it has both `baseUrl` and `deviceToken`.

**A tool isn't being detected**
```bash
tokentracker status    # See what's detected
tokentracker doctor    # Full health check
```

**Dashboard shows no data after sync**
Wait 5 minutes for the leaderboard refresh, or try a hard refresh (Ctrl+Shift+R) on the dashboard.

---

## Need Help?

Reach out to IT or post in the #token-tracker Slack channel.
