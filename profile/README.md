# 📘 Gewerber — Open Core Business Platform for Solo Gewerbe Owners

**Gewerber** is a Dart‑based open‑core platform designed for Einzelunternehmer, Kleingewerbe, and micro‑business owners in Germany. It simplifies invoicing, time tracking, basic accounting, and business guidance through a unified codebase:

- **Backend:** Serverpod
- **Web App:** Flutter Web (`https://app.gewerber.de`)
- **Mobile/Desktop:** Flutter
- **Marketing Site:** Jaspr
- **Open Core:** OSS modules
- **Commercial Extensions:** banking, tax/ELSTER, employees, subscriptions, AI assistant

Gewerber is built for users who find German bureaucracy overwhelming. The open‑source core provides essential tools, while commercial modules enable advanced business operations.

---

## 🎯 Features (Open Source Core)

### 💰 Invoicing
- PDF generation
- **EN/RU/DE** templates
- **Kleinunternehmer §19** logic
- **VAT** logic
- CSV/JSON export

### ⏱ Time Tracking
- Projects & tasks
- Start/stop timer
- Manual entries
- Rounding rules
- Reports

### 📊 Basic Accounting
- Income & expense tracking
- Receipt upload
- Categorization
- Basic **P&L**
- Export for Steuerberater

### 📖 Guidance System
- Tooltips
- Checklists
- **"What is this?"** popups
- Blog integration

### 🎨 UI Kit
- Shared Flutter components
- Forms, tables, cards, layouts

---

## 🔒 Commercial Modules (Closed Source)

These modules are part of the Gewerber SaaS and not included in the open‑source core:

### 🏦 Banking Integration
### 📋 Tax/ELSTER Integration
### 👥 Employees & Payroll
### 💳 Subscriptions & Billing
### 🤖 AI Assistant

They provide advanced functionality for Pro/Business users.

---

## 🏗 Architecture

Gewerber uses a single‑language Dart stack:

- **Serverpod** for backend services
- **Flutter Web** for the application UI
- **Flutter Mobile/Desktop** for native apps
- **Jaspr** for the marketing site
- **PostgreSQL** for data
- **S3-compatible** storage for documents

The project is organized as separate git repositories under the Gewerber GitHub organization. See **[ORGANIZATION.md](https://github.com/Gewerber/.github/blob/main/ORGANIZATION.md)** for the full repository structure.

---

## 🚀 Getting Started

### 📋 Requirements
- **Dart SDK**
- **Flutter SDK**
- **Serverpod CLI**
- **PostgreSQL**
- **Docker** (optional)

### ▶️ Running the backend
```bash
cd gewerber-backend-core
serverpod run
```

### ▶️ Running the Flutter Web app
```bash
cd gewerber-app
flutter run -d chrome
```

### ▶️ Running the Jaspr site
```bash
cd gewerber-website
jaspr serve
```

### 📁 Repository Structure

The Gewerber organization is composed of multiple repositories:

#### Public Repositories

| **Repository** | **Purpose** |
|---|---|
| **gewerber-app** | Flutter application: mobile, web, desktop. Includes UI Kit and client packages. |
| **gewerber-backend-core** | Serverpod backend for the open-source core: auth, invoicing (without payments), time tracking, guidance. |
| **gewerber-website** | Jaspr SSR marketing site (`gewerber.de`). |
| **gewerber-examples** | Deployment examples, Docker Compose, demo projects, quickstart setups. |
| **gewerber-docs** *(optional)* | Centralized documentation, architecture, guides. |
| **.github** | Organization-wide documentation, issue/PR templates, global policies. |

#### Private Repositories

| **Repository** | **Purpose** |
|---|---|
| **gewerber-backend-commercial** | Banking adapters (PSD2), ELSTER, advanced accounting, closed APIs. |
| **gewerber-business** | Product strategy, PRD, detailed business roadmap, marketing. |
| **gewerber-payments** | Stripe, subscriptions, billing, feature gating. |
| **gewerber-infra** | Terraform, Helm, CI/CD secrets, production deployment. |
| **gewerber-ops** | Monitoring, alerts, runbooks, incident playbooks. |

Commercial modules live in private repositories.

---

## 📄 License

**Gewerber Core** is licensed under **MIT**. Commercial modules are proprietary and not part of this repository.

See **[LICENSE.md](https://github.com/Gewerber/.github/blob/main/LICENSE.md)** for details.

---

## 🤝 Contributing

We welcome contributions! See **[CONTRIBUTING.md](https://github.com/Gewerber/.github/blob/main/CONTRIBUTING.md)** for details.

---

## 📞 Contact

For commercial licensing or SaaS access:

**https://gewerber.de**