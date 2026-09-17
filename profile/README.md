# Gewerber — Business. Simplified.

**Gewerber** is a free, open-source, MIT-licensed platform for solo business owners in Germany who find German bureaucracy overwhelming. We handle the paperwork so you can focus on what matters: running your business.

---

## What You Get

**Invoicing**
Create professional invoices with PDF generation, EN/RU/DE templates, and automatic Kleinunternehmer §19 and VAT logic. Export to CSV or JSON.

**Time Tracking**
Track projects and tasks with a start/stop timer, manual entries, rounding rules, and detailed reports.

**Basic Accounting**
Monitor income and expenses, upload receipts, categorize transactions, and generate basic P&L statements — ready for your Steuerberater.

**Guidance System**
Tooltips, checklists, and "What is this?" popups guide you through every screen. Integrated blog content keeps you informed.

**UI Kit**
A shared component library of forms, tables, cards, and layouts — built for consistency across every Gewerber experience.

---

## Pro & Business Features

For users who need more, Gewerber offers additional modules as part of our SaaS platform:

- **Banking Integration** — Connect your accounts and streamline cash flow
- **Tax/ELSTER** — Electronic tax filing built for German compliance
- **Employees & Payroll** — Manage your team with confidence
- **Subscriptions & Billing** — Recurring revenue management
- **AI Assistant** — Smart suggestions to save time

These advanced features are available through Gewerber's commercial offering.

---

## Architecture

Gewerber runs on a single-language Dart stack:

- **Serverpod** — Backend services and API
- **Flutter Web** — Application UI
- **Flutter Mobile/Desktop** — Native apps
- **Jaspr** — Marketing site (gewerber.de)
- **PostgreSQL** — Data storage
- **S3-compatible storage** — Document handling

The project spans multiple repositories under the Gewerber GitHub organization. See [ORGANIZATION.md](https://github.com/Gewerber/.github/blob/main/ORGANIZATION.md) for the full structure.

---

## Getting Started

Ready to simplify your business? Here's how to get involved:

**Try the live apps:**
- **[app.gewerber.de](https://app.gewerber.de)** — The web application
- **[gewerber.de](https://gewerber.de)** — Marketing site and documentation

**Build from source:**

| **Repository** | **Purpose** |
|---|---|
| **gewerber-app** | Flutter application shell: mobile, web, desktop. Includes UI Kit, client packages, and the `AppFeature` extension point for private features. |
| **gewerber-backend** | Serverpod backend for the open-source core: auth, invoicing (without payments), time tracking, guidance. |
| **gewerber-backend-stubs** | Public contract packages of the commercial module (health endpoint, waitlist API, billing-wiring entrypoint — no closed API surface); resolves OSS builds and CI without private access. |
| **gewerber-examples** | Deployment examples, Docker Compose, demo projects, quickstart setups. |
| **gewerber-docs** | Centralized documentation, architecture, guides. |
| **gewerber-mcp** | Open integration tooling: MCP server (Dart, `dart_mcp`) over stdio — staff-facing admin/moderator toolset; talks to the backend exclusively through Serverpod endpoints. Positioned as integration tooling, not an AI assistant. |
| **.github** | Organization-wide documentation, issue/PR templates, global policies. |

> **Note:** The table above lists public repositories only. **gewerber-website** is a **private** repository — the site output at `gewerber.de` is public. See [ORGANIZATION.md](https://github.com/Gewerber/.github/blob/main/ORGANIZATION.md) for the full list including private repos.

---

## License

Gewerber Core is **free, open-source, and MIT-licensed**. You can use, modify, and distribute it without restriction. Commercial modules are available as part of the Gewerber SaaS platform.

See [LICENSE.md](https://github.com/Gewerber/.github/blob/main/LICENSE.md) for details.

---

## Links

- **[Security Policy](https://github.com/Gewerber/.github/blob/main/SECURITY.md)**
- **[Support](https://github.com/Gewerber/.github/blob/main/SUPPORT.md)**
- **[Community](https://github.com/Gewerber/.github/blob/main/COMMUNITY.md)**
- **[Contributing](https://github.com/Gewerber/.github/blob/main/CONTRIBUTING.md)**

---

## Contact

Interested in commercial licensing or SaaS access? Visit **[gewerber.de](https://gewerber.de)** for details.

Need support? Reach out at **support@gewerber.de**.
