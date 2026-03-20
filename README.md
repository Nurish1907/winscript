Windows Endpoint Optimization Toolkit
Automated Maintenance & GPO-Bypass Utilities for Enterprise Environments

This toolkit was developed to streamline the management of 500+ Windows assets across multiple logistics and e-commerce facilities. It addresses common "system lag" issues, automates deep hygiene tasks, and ensures system uptime during critical maintenance windows by bypassing restrictive Power GPOs.

🛠 Features
System Diagnostics: Real-time CPU load and Disk space analysis with visual alerts.

Deep Hygiene: Automated purging of Temp, Prefetch, and SoftwareDistribution (Windows Update) caches.

GPO-Bypass (Stay-Awake): A VBScript-based "heartbeat" that prevents idle-sleep/lock triggers in managed environments.

Update Orchestration: Utilizes usoclient to trigger patch installations when standard APIs are locked by policy.

Admin Provisioning: Secure local account creation with "Password Never Expires" logic.

Security Compliance
Credential Safety: No hardcoded passwords; utilizes interactive input and SecureString objects.

Safety Snapshots: Attempts to trigger a System Restore Point before executing deep cleanup.

Principle of Least Privilege: Designed to be executed via Run as Administrator for scoped system changes.
