# 🏛 Gewerber Governance

This document describes how the Gewerber open-source project is governed, including roles, decision-making processes, and contribution workflows.

---

## 🎯 Mission

Gewerber aims to become the most friendly, modern, and modular platform for Einzelunternehmer, Kleingewerbe, and micro‑business owners in Germany.

---

## 👥 Roles & Responsibilities

### 🏆 Maintainers

Maintainers are responsible for:

- Reviewing and merging pull requests
- Managing releases
- Ensuring code quality and consistency
- Guiding contributors
- Enforcing the Code of Conduct

**Current Maintainers:**

- **Dmytro** — Founder & Lead Developer

### 🧑‍🤝‍🧑 Contributors

Anyone who submits a PR, issue, translation, documentation update, or helps in discussions.

### 🌱 New Contributors

We welcome beginners! See the **"Good first issues"** label on GitHub.

### 👥 Commercial Developers

Private module developers who work on closed-source repositories. They do not participate in OSS governance.

---

## 🗳 Decision Making

### 🔧 Technical Decisions

- **Minor changes** (bug fixes, small enhancements): Approved by any maintainer
- **Major changes** (new modules, breaking changes): Require maintainer discussion and approval
- **Architectural decisions**: Require consensus among maintainers

### 📝 RFC Process

For significant changes:

1. Open a discussion on GitHub
2. Propose an RFC (Request for Comments)
3. Gather community feedback
4. Maintainers review and decide
5. Implementation begins

### 🗳 Voting

When consensus cannot be reached, maintainers vote. A simple majority is required.

---

## 🔄 Release Process

### Versioning

- **OSS Core:** Semantic Versioning (SemVer)
- **Commercial Modules:** SaaS versioning (feature-based)

### Release Cadence

- **Patch releases:** As needed (bug fixes)
- **Minor releases:** Monthly
- **Major releases:** Quarterly (or as needed)

### Release Checklist

1. Code complete and tested
2. Documentation updated
3. Changelog updated
4. Version bumped
5. Release tagged
6. Release notes published

---

## 🤝 Contribution Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests (`dart test`, `flutter test`)
5. Run `dart format`
6. Submit a pull request
7. A maintainer reviews your PR
8. Changes are merged or feedback is provided

See **[CONTRIBUTING.md](CONTRIBUTING.md)** for full details.

---

## 🔒 Open-Core Boundaries

Only contribute to **open-source modules**:

- Invoicing (no payments)
- Time tracking
- Basic accounting
- Guidance system
- UI Kit
- Core platform

**Do not touch** (PRs will be rejected):

- Banking, tax/ELSTER, employees, subscriptions, AI assistant
- Multi-currency invoicing, advanced accounting

---

## 🏛 Code of Conduct

All participants must follow the **[Code of Conduct](CODE_OF_CONDUCT.md)**.

---

## 📚 Related Documents

- **[CONTRIBUTING.md](CONTRIBUTING.md)**
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)**
- **[SECURITY.md](SECURITY.md)**
- **[ORGANIZATION.md](ORGANIZATION.md)**
- **[ROADMAP.md](../ROADMAP.md)**