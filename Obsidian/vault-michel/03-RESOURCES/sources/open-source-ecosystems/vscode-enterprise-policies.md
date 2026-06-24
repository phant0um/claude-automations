---
title: "Centrally Manage VS Code Settings with Policies"
type: source
source_url: "https://code.visualstudio.com/docs/enterprise/policies"
author: "[[03-RESOURCES/entities/Microsoft]]"
published: 2021-11-03
created: 2026-05-01
updated: 2026-05-01
tags: [source, vscode, enterprise, policies, developer-tools, configuration-management]
triagem_score: 6
---

# Centrally Manage VS Code Settings with Policies

**Source:** [code.visualstudio.com/docs/enterprise/policies](https://code.visualstudio.com/docs/enterprise/policies)
**Author:** [[03-RESOURCES/entities/Microsoft]]
**Clipping date:** 2026-05-01

## Summary

Official Microsoft documentation covering how IT administrators can enforce VS Code settings across an organization using OS-native policy mechanisms. Policies override all user/workspace settings — they represent the highest-priority configuration layer.

See concept page: [[03-RESOURCES/concepts/vscode-enterprise-policy-management]]

---

## Core Concept

When a policy value is set, it overrides VS Code settings at **every level** — default, user, and workspace. The Settings editor shows affected settings as "Managed by your organization" with a lock icon.

---

## Platform Implementation Matrix

| OS | Mechanism | File Path | Available Since |
|----|-----------|-----------|----------------|
| Windows | Registry-based Group Policy (ADMX/ADML) | `C:\Windows\PolicyDefinitions\vscode.admx` | VS Code 1.69 |
| macOS | Configuration Profiles (`.mobileconfig`) | System Settings > Privacy & Security > Profiles | VS Code 1.99 |
| Linux | JSON file | `/etc/vscode/policy.json` | VS Code 1.106 |

---

## Windows Group Policy (ADMX/ADML)

### Files
- `vscode.admx` — main policy definition
- `locales/en-US/vscode.adml` — localized strings
- Located in `<install>/policies/` directory

### Deployment options
- **MDM at scale:** Microsoft Intune, Active Directory Group Policy Central Store
- **Local test:** Local Group Policy Editor (`gpedit.msc`)

### GPO paths
- `Computer Configuration > Administrative Templates > Microsoft VS Code`
- `User Configuration > Administrative Templates > Microsoft VS Code`
- Computer-level takes precedence over user-level.

---

## macOS Configuration Profiles

### File format
`.mobileconfig` XML file; sample ships with VS Code 1.99+ at:
`/Applications/Visual Studio Code.app/Contents/Resources/app/policies/vscode-sample.mobileconfig`

### Deployment
- **MDM at scale:** Microsoft Intune, Apple Business Manager
- **Local test:** Double-click `.mobileconfig` in Finder → System Settings installs it

### Remove profile
System Settings > Privacy & Security > Profiles > select profile > Remove (-)

---

## Linux JSON Policies

### File location
`/etc/vscode/policy.json` — requires root; permissions should be `644`, owner `root:root`

### Deployment
Configuration management tools: Ansible, Puppet, Chef, Salt

### Local test steps
```bash
sudo mkdir -p /etc/vscode
sudo cp /tmp/policy.json /etc/vscode/policy.json
sudo chmod 644 /etc/vscode/policy.json
sudo chown root:root /etc/vscode/policy.json
```

---

## Policy Value Types

All three OS platforms share the same logical policy types:

**String policies** — text or JSON:
```xml
<key>AllowedExtensions</key>
<string>{"microsoft": true, "github": true}</string>

<key>UpdateMode</key>
<string>start</string>
```

**Boolean policies:**
```xml
<key>EnableFeedback</key>
<true/>

<key>EnableTelemetry</key>
<false/>
```

> Syntax errors silently skip the policy. Check Window Log (`⇧⌘P` → Show Window Log).

---

## Policy Diagnostics

Command: `Developer: Policy Diagnostics`
- Opens a Markdown report of current policy state (cross-platform)
- Sections: System Info, Account Info, Account Policy Gate, Policy-Controlled Settings, Authentication Info

**Account Policy Gate states:** `inactive` | `satisfied` | `restricted`
- Restricted sub-reasons: `noAccount`, `wrongProvider`, `orgNotApproved`, `policyNotResolved`
- Fix `policyNotResolved`: run `Developer: Sync Account Policy`

> Caution: report contains sensitive data (account IDs, session details, extension access).

---

## Full Policy Reference

| Policy ID | Description |
|-----------|-------------|
| `ExtensionGalleryServiceUrl` | Override Marketplace service URL |
| `McpGalleryServiceUrl` | Override MCP Gallery URL |
| `ChatApprovedAccountOrganizations` | Gate all AI features on GitHub org membership; `*` = any GitHub/GHE account |
| `AllowedExtensions` | Allowlist of permitted extensions by publisher |
| `ChatToolsAutoApprove` | YOLO mode — disables all tool approval prompts; **never recommended** |
| `ChatToolsEligibleForAutoApproval` | Per-tool auto-approval eligibility |
| `ChatMCP` | Controls access to installed MCP servers |
| `ChatAgentExtensionTools` | Allow tools from third-party extensions |
| `ChatPluginsEnabled` | Enable agent plugin integration |
| `ChatAgentMode` | Enable/disable agent mode globally |
| `ChatAgentNetworkFilter` | Restrict network access for agent tools |
| `ChatAgentAllowedNetworkDomains` | Allowlist for agent network access; supports wildcards |
| `ChatAgentDeniedNetworkDomains` | Denylist for agent network access; takes precedence |
| `DeprecatedEditModeHidden` | Hide Edit mode from chat mode picker |
| `ChatHooks` | Control chat hooks execution in agent workflow |
| `ChatToolsTerminalEnableAutoApprove` | Auto-approve terminal tool |
| `ChatAgentSandboxEnabled` | Sandbox agent tools (terminal restricted environment) |
| `UpdateMode` | Auto-update behavior |
| `TelemetryLevel` | Telemetry verbosity level |
| `EnableFeedback` | Issue reporter, surveys, feedback options |
| `BrowserChatTools` | Allow chat agents to use Integrated Browser |
| `CopilotNextEditSuggestions` | Next Edit Suggestions (NES) |
| `CopilotReviewSelection` | Code review on selection |
| `CopilotReviewAgent` | Code review agent |
| `Claude3PIntegration` | **Enable Claude Agent sessions in VS Code** — Anthropic Claude Agent SDK via Copilot subscription |

---

## Notable Security Observations

- `ChatToolsAutoApprove` ("YOLO mode") is described by Microsoft as "**extremely dangerous**" and "**never recommended**" even in Codespaces/Dev Containers because user keys are forwarded into the container
- `ChatAgentNetworkFilter` + `ChatAgentAllowedNetworkDomains`/`ChatAgentDeniedNetworkDomains` provide domain-level sandboxing for agent browsing and fetch tools
- `ChatAgentSandboxEnabled` adds terminal sandboxing on top of network filtering
- `Claude3PIntegration` policy: [[03-RESOURCES/entities/Microsoft]] has native integration point for [[03-RESOURCES/entities/anthropic]] Claude Agent SDK via GitHub Copilot subscription — requires policy unlock at org level

---

## Key Insight

Policies represent the **zero-trust override layer** for VS Code — they sit above all user/workspace settings and enable IT to lock down or gate AI features (Copilot, MCP, agent mode, Claude integration) at organization scale. The `ChatApprovedAccountOrganizations` policy is the primary mechanism for restricting AI to employees of specific GitHub orgs.

---

## Related Pages
- [[03-RESOURCES/entities/vs-code]] — VS Code entity
- [[03-RESOURCES/entities/Microsoft]] — Microsoft entity
- [[03-RESOURCES/concepts/vscode-enterprise-policy-management]] — concept breakdown
- [[03-RESOURCES/concepts/claude-code-tooling/mcp-model-context-protocol]] — MCP Gallery policy ties into MCP
- [[03-RESOURCES/entities/Claude Code]] — Claude3PIntegration links Claude Code into VS Code
