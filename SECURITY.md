# 🔐 Security Policy — Gewerber Open Core

This document describes how security is handled in the **Gewerber** open‑core project, how to report vulnerabilities, and how we protect users and contributors.

Gewerber is used by solo business owners and micro‑enterprises, so security is a top priority.
We take all reports seriously and respond promptly.

---

## 1️⃣ Supported Versions

Gewerber Core follows **semantic versioning (SemVer)**.
We provide security updates for:

- The **latest stable release**
- The **previous minor release**

Older versions may still receive community patches, but maintainers are not obligated to provide fixes.

Commercial modules (banking, tax/ELSTER, employees, subscriptions, AI assistant) follow the SaaS security lifecycle and are **not part of this repository**.

---

## 2️⃣ Reporting a Vulnerability

If you discover a security issue, **do not open a public GitHub issue**.

Instead, report it privately:

**📧 Email:** `security@gewerber.de`
**📝 Subject:** "Security Report — [Short Description]"

Please include:

- A clear description of the vulnerability
- Steps to reproduce
- Impact assessment (if known)
- Suggested fix (optional)
- Your preferred level of anonymity

We will acknowledge your report within **48 hours**.

---

## 3️⃣ What to Report

### ✅ You Should Report:
- Authentication issues
- Authorization or permission bypass
- Data leaks or exposure
- SQL injection, XSS, CSRF
- Serverpod endpoint vulnerabilities
- Flutter Web security issues
- Misconfigured CORS or headers
- Unsafe file uploads
- Weak cryptography
- Dependency vulnerabilities

### ❌ Do Not Report:
- Bugs unrelated to security
- Feature requests
- Issues in closed commercial modules
- UI/UX problems

For non-security issues, use:
**[Issue Template](ISSUE_TEMPLATE/)**

---

## 4️⃣ Security Practices

Gewerber Core follows industry-standard security practices:

### 🔐 Authentication
- JWT-based auth (Serverpod)
- Secure password hashing
- Optional 2FA (future)

### 🔒 Authorization
- Role-based access control
- Tenant isolation for SaaS
- Endpoint-level permission checks

### 🔏 Data Protection
- Encrypted fields (tax numbers, sensitive data)
- HTTPS everywhere
- S3-compatible secure storage
- No plaintext secrets in repo

### 🛡 Serverpod Security
- Endpoint validation
- DTO-based request/response
- Input sanitization
- Database migrations with integrity checks

### 🧱 Flutter Security
- No eval or dynamic code execution
- Sanitized user input
- Safe HTML rendering
- CSP headers for Flutter Web

### 🌐 Jaspr Security
- SSR with safe templating
- No unsafe HTML injection
- Sanitized Markdown for blog

---

## 5️⃣ Dependency Management

We regularly audit:

- Dart packages
- Flutter dependencies
- Serverpod modules
- Jaspr packages
- Docker images
- PostgreSQL version
- S3-compatible storage configuration

Security patches are applied as soon as upstream fixes are available.

---

## 6️⃣ Handling Sensitive Modules (Closed Source)

The following modules are **not part of the open‑source repository** and have their own internal security policies:

- **Banking (PSD2)**
- **Tax/ELSTER**
- **Employees & payroll**
- **Subscriptions & billing**
- **AI assistant**

These modules undergo:

- Internal audits
- External audits (when required)
- Penetration testing
- Compliance checks

---

## 7️⃣ Disclosure Policy

We follow **responsible disclosure**:

- You report privately
- We investigate
- We fix the issue
- We release a patch
- We publish a security advisory
- You may be credited (optional)

We do **not** support zero‑day public disclosure.

---

## 8️⃣ Security Roadmap

Planned improvements:

- Stronger tenant isolation
- Optional 2FA for OSS
- Secure secrets management
- Automated dependency scanning
- Automated CI security checks
- Hardened Docker images
- CSP improvements for Flutter Web
- Secure plugin architecture

See full roadmap:
**[ROADMAP.md](../ROADMAP.md)**

---

## 9️⃣ Related Documents

- **[CONTRIBUTING.md](CONTRIBUTING.md)**
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)**
- **[TECHNICAL_SPECIFICATION.md](../TECHNICAL_SPECIFICATION.md)**
- **[PRD.md](../PRD.md)**
- **[LICENSE.md](../LICENSE.md)**

---

## 🔟 Thank You

We appreciate your help in keeping Gewerber secure.
Your efforts protect thousands of solo business owners and strengthen the open‑source ecosystem.