# 🤝 Contributing to Gewerber (Open Core)

Thank you for your interest in contributing to **Gewerber Core**! This document explains how to participate, submit changes, and collaborate with the community.

Gewerber follows an **open‑core model**:

- **Open Source:** invoicing, time tracking, basic accounting, guidance, UI kit
- **Closed Source:** banking, tax/ELSTER, employees, subscriptions, AI assistant

Please read this document carefully before contributing.

---

## 📜 Code of Conduct

By participating, you agree to uphold our community standards:

- **Be respectful**
- **Be constructive**
- **Help newcomers**
- **No harassment or discrimination**

See **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** for full details.

See also **[GOVERNANCE.md](GOVERNANCE.md)** for project governance information.

---

## 📁 Repository Structure

This document lives in the `.github` repository (`Gewerber/.github`). Each entry below is a separate git repository under the Gewerber GitHub organization.

See **[ORGANIZATION.md](ORGANIZATION.md)** for the full structure.

### Public Repositories

| **Subdirectory** | **Remote** | **Purpose** |
|---|---|---|
| `gewerber-app` | `Gewerber/gewerber-app` | Flutter Web app |
| `gewerber-backend` | `Gewerber/gewerber-backend` | Serverpod backend (OSS) |
| `gewerber-backend-stubs` | `Gewerber/gewerber-backend-stubs` | Public placeholder packages of the commercial module |
| `gewerber-website` | `Gewerber/gewerber-website` | Jaspr SSR marketing site (`gewerber.de`) |
| `gewerber-docs` | `Gewerber/gewerber-docs` | Documentation site |
| `gewerber-examples` | `Gewerber/gewerber-examples` | Example projects |
| `gewerber-mcp` | `Gewerber/gewerber-mcp` | Open integration tooling — MCP server (Dart, `dart_mcp`) for admins and end users; per-user data isolation enforced server-side |
| `.github` | `Gewerber/.github` | Organization profile README |

### Private Repositories

| **Repository** | **Remote** | **Purpose** |
|---|---|---|
| `gewerber-backend-commercial` | `Gewerber/gewerber-backend-commercial` | Banking adapters (PSD2), ELSTER, advanced accounting |
| `gewerber-app-commercial` | `Gewerber/gewerber-app-commercial` | Closed app feature packages + production composition root |
| `gewerber-business` | `Gewerber/gewerber-business` | Product strategy, PRD, business roadmap, marketing |
| `gewerber-payments` | `Gewerber/gewerber-payments` | Stripe, subscriptions, billing, feature gating |
| `gewerber-infra` | `Gewerber/gewerber-infra` | Terraform, Helm, CI/CD secrets, production deployment |
| `gewerber-ops` | `Gewerber/gewerber-ops` | Monitoring, alerts, runbooks, incident playbooks |

Commercial modules are not part of this repository.

---

## 🌿 Branching & Release Model

Every repository in the Gewerber organization uses two **long-lived branches**:

| **Branch** | **Purpose** | **Protection** |
|---|---|---|
| `main` | Production-ready code | Protected — direct pushes are blocked for everyone, including administrators |
| `develop` | Integration branch and the source of staging deployments | Protected the same way |

### Day-to-Day Development

- All development happens on **short-lived branches created from `develop`**
- Branch naming: `feature/<short-name>`, `fix/<short-name>`, `chore/<short-name>`
- Pull requests always target `develop` — never `main`
- Delete your feature branch after it is merged

### Releases

Releases ship through a dedicated release pull request: the maintainer opens a PR from `develop` into `main`, and merging it ships the release to production. Staging gets updated automatically from `develop`.

```text
feature/* ──► PR ──► develop ──► PR (release) ──► main

staging    ◄── develop
production ◄── main
```

---

## 🚀 How to Contribute

### 1️⃣ Pick an Area to Work On

You can contribute to:

- **Invoicing**
- **Time Tracking**
- **Basic Accounting**
- **Guidance System**
- **UI Kit**
- **Documentation**
- **Bug fixes**
- **Performance improvements**

### 2️⃣ Fork the Repository

Create your own fork and clone it locally.

### 3️⃣ Create a Feature Branch

Always branch from the freshest `develop`:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/my-change
```

### 4️⃣ Make Your Changes

Follow the coding guidelines below.

### 5️⃣ Run Tests

```bash
dart test
flutter test
```

### 6️⃣ Submit a Pull Request

Pull requests must target the **`develop`** branch — never `main`. Direct pushes to `main` or `develop` are rejected by branch protection.

#### Include:

- Description of the change
- Screenshots (if UI)
- Tests (if applicable)
- Reference to related issues

---

## 📏 Coding Guidelines

### 🐦 Dart & Flutter

- Use `dart format`
- Follow Effective Dart
- Keep widgets small and composable
- Use Bloc (depending on project conventions)

### 🖥 Serverpod

- Keep endpoints modular
- Use DTOs for request/response
- Avoid business logic in endpoints
- Write migrations for schema changes

### 🌐 Jaspr

- Keep pages small
- Use components for reusable UI
- Avoid heavy logic in templates

---

## 🚫 What You Cannot Contribute To

The following modules are closed source and not open for contributions:

- **Banking**
- **Tax/ELSTER**
- **Employees**
- **Subscriptions**
- **AI assistant**
- **Multi‑currency invoicing**
- **Advanced accounting**

Pull requests touching these areas will be rejected.

---

## 🧪 Testing

We use:

- `dart test` for backend logic
- `flutter test` for UI logic
- Manual testing for Flutter Web
- Integration tests (future)

---

## 🗺 Roadmap

You can contribute to any open‑source roadmap item:

- OSS invoicing improvements
- OSS time tracking enhancements
- OSS accounting improvements
- Guidance system expansion
- UI kit components

See **[ROADMAP.md](https://github.com/Gewerber/gewerber-docs/blob/main/ROADMAP.md)** for details.

---

## 🙌 Thank You

Your contributions help Gewerber grow into a powerful, friendly platform for small business owners in Germany.

If you have questions, open an issue or join the discussion.