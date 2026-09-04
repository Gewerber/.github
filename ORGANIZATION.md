# 🏛 Gewerber — GitHub Organization Structure

This document describes the repository architecture inside the **Gewerber** GitHub organization, the principles behind code separation, the roles of each repository, and how they interact. It serves as a guide for developers, contributors, and internal teams.

---

## 🎯 Goals of the Organization Structure

- Clear separation of client, server, and infrastructure repositories
- Support for the **open‑core** model: open-source core + closed commercial modules
- Easy navigation for external contributors
- Security and isolation of private modules
- Scalability as the product grows

---

## 🧱 Core Principles

- **Public repositories** contain only the open-source core and documentation
- **Private repositories** contain commercial modules, integrations, and infrastructure
- **Client and server are separated** into different repositories
- **Flutter application is unified**: mobile + web + desktop in one repo
- **Backend is split**: OSS core separate from commercial modules
- **Documentation is centralized** in the default `.github` repository

---

## 📁 Repository Structure

### 🌐 Public Repositories

| **Repository** | **Purpose** |
|---|---|
| **gewerber-app** | Flutter application shell: mobile, web, desktop. Includes UI Kit, client packages and the `AppFeature` extension point for private features. |
| **gewerber-backend** | Serverpod backend for the open-source core: auth, invoicing (without payments), time tracking, guidance. Renamed from `gewerber-backend-core`. |
| **gewerber-backend-stubs** | Public placeholder packages of the commercial module; resolves OSS builds and CI without private access. |
| **gewerber-website** | Jaspr SSR marketing site (`gewerber.de`). |
| **gewerber-examples** | Deployment examples, Docker Compose, demo projects, quickstart setups. |
| **gewerber-docs** *(optional)* | Centralized documentation, architecture, guides. |
| **gewerber-mcp** | Open integration tooling: MCP server (Dart, dart_mcp) talking to the backend exclusively through Serverpod endpoints — an admin/moderator toolset plus a per-user mode; data access is isolated server-side per account. Positioned as integration tooling, not an AI assistant. |
| **.github** | Organization-wide documentation, issue/PR templates, global policies. |

---

### 🔒 Private Repositories

| **Repository** | **Purpose** |
|---|---|
| **gewerber-backend-commercial** | Banking adapters (PSD2), ELSTER, advanced accounting, closed APIs (Serverpod module `commercial`). |
| **gewerber-app-commercial** | Closed app feature packages + production composition root (`apps/product`) building `app.gewerber.de`. |
| **gewerber-business** | Product strategy, PRD, detailed business roadmap, marketing. |
| **gewerber-payments** | Stripe, subscriptions, billing, feature gating. |
| **gewerber-infra** | Terraform, Helm, CI/CD secrets, production deployment. |
| **gewerber-ops** | Monitoring, alerts, runbooks, incident playbooks. |

---

## 🔗 Repository Interactions

### 👉 Client → Backend
The Flutter application uses the generated client SDK from `gewerber-backend`.

### 👉 Backend → Commercial
The open-source core provides stable API contracts.
Commercial modules extend functionality through private endpoints.

### 👉 Open-Core Dependency Wiring
No public artifact references a private repository. OSS pubspecs resolve the
commercial module against the public `gewerber-backend-stubs` packages;
insiders override them via gitignored `pubspec_overrides.yaml`, and release
CI/Docker injects the real module with a token. Closed app features implement
the `AppFeature` contract of the OSS shell and are composed in
`gewerber-app-commercial/apps/product`.

### 👉 Documentation → All Repositories
Documentation in `.github` acts as the central entry point.

---

## 🔓 Open‑Core Boundaries

### ✔️ Open-Source Modules (OSS)
- Invoicing (without payments)
- Time tracking
- Basic accounting
- Guidance system
- UI Kit
- Core platform

### 🔒 Closed Modules (Commercial)
- Banking (PSD2)
- Tax/ELSTER
- Employees & payroll
- Subscriptions & billing
- AI assistant
- Advanced accounting

Pull requests affecting closed modules will be rejected.

---

## 🧭 Navigation Within the Organization

### 🏠 Main Entry Points

- Organization homepage: `.github/profile/README.md`
- **[Contributing Guide](CONTRIBUTING.md)**
- **[Code of Conduct](CODE_OF_CONDUCT.md)**
- **[Security Policy](SECURITY.md)**
- **[Governance](GOVERNANCE.md)**
- **[Support](SUPPORT.md)**
- **[Roadmap](https://github.com/Gewerber/gewerber-docs/blob/main/ROADMAP.md)**

---

## 🛠 CI/CD and Automation

### 🌐 Public Repositories
- Linting
- Unit tests
- Flutter Web builds
- Serverpod → Dart client code generation

### 🔒 Private Repositories
- Integration tests
- Access to secrets
- Production deployment pipelines

---

## 👥 Roles and Teams

- **Maintainers** — repository management, reviews, releases
- **App Developers** — Flutter client development
- **Backend Developers** — OSS backend development
- **Commercial Developers** — private module development
- **Ops** — infrastructure, monitoring, deployment

---

## 📄 Files in the `.github` Repository

- `profile/README.md` — organization homepage
- `CODE_OF_CONDUCT.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `SUPPORT.md`
- `GOVERNANCE.md`
- `ORGANIZATION.md` *(this document)*
- `ISSUE_TEMPLATE/`
- `PULL_REQUEST_TEMPLATE.md`
- `FUNDING.yml` *(optional)*
- `workflows/` *(optional)*

---

## 📚 Additional Resources

- **Technical Specification** — [Technical Spec](https://github.com/Gewerber/gewerber-docs/blob/main/TECHNICAL_SPECIFICATION.md)

---

## 🙌 Conclusion

This structure ensures:

- Transparency for the community
- Security for commercial modules
- A clean developer experience
- Scalability as the product evolves