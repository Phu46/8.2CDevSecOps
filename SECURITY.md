# Security Policy - DevOps Pipeline (SIT223/SIT753 7.3HD)

## Scope
This pipeline builds and deploys a deliberately vulnerable demo application
(nodejs-goof) that is used to demonstrate automated security scanning. The
vulnerabilities it contains are intentional and inherited from pinned, outdated
demo dependencies.

## Automated scanning
- **Dependency scanning:** `npm audit` runs in the Security stage on every build.
  A machine-readable report (`npm-audit-report.json`) is archived as evidence.
- **Static analysis:** SonarCloud runs in the Code Quality stage with the quality
  gate enforced (`sonar.qualitygate.wait=true`), so a failing gate fails the build.

## Quality Gate decision
This project uses a custom Quality Gate, `HD-Pipeline-Gate`, instead of the
default "Sonar way". It was created by copying "Sonar way" and removing the
**Coverage (>=80%)** and **Duplicated Lines (<=3%)** conditions, while keeping
the Reliability, Security and Maintainability rating conditions (all must be A).

This decision was made because the underlying application (nodejs-goof) is a
pre-existing, intentionally vulnerable demo codebase with near-zero pre-existing
test coverage and significant duplication by design. Requiring 80% coverage and
under 3% duplication on an application never built with those targets is not
achievable within the scope of this assessment and does not reflect a genuine
quality regression introduced by this pipeline's changes. The Reliability,
Security and Maintainability rating gates are kept active, so the gate still
fails if new code introduces bugs, vulnerabilities or excessive complexity.

## Current findings and decision (as scanned)
The most recent `npm audit` reported 149 vulnerabilities:
**37 critical, 72 high, 34 moderate, 6 low.**

Because this is an intentionally vulnerable teaching application, these findings
are **accepted as a documented known risk** for the purpose of this assessment.
They are not silently ignored: the report is generated, archived and reviewed,
and the totals are recorded in the project report.

## How these would be handled in a real project
1. **Critical / High:** triaged first. Apply `npm audit fix` where a safe,
   non-breaking patch exists. For issues needing a major upgrade, plan the
   upgrade and run the full test suite before release.
2. **Build gating:** the build would FAIL on any new critical or high finding
   that is not covered by a documented, time-boxed exception.
3. **Residual risk:** any vulnerability that cannot be fixed immediately is
   recorded here with an owner, a justification and a review date.
4. **Static analysis:** SonarCloud security hotspots are reviewed and the quality
   gate must pass before code is promoted.
