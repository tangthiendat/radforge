# Severity Guide

Use this guide to keep review findings consistent.

## High

Use when the issue is likely to cause incorrect behavior, data loss, broken installs, security exposure, or a misleading success claim.

Typical signals:

- a behavior path is wrong or incomplete
- a migration, install, or uninstall path can damage the environment
- validation is so weak that the claimed outcome is not actually supported

## Medium

Use when the issue is likely to create confusion, operational risk, or a probable follow-up defect, but the primary path may still work.

Typical signals:

- docs or instructions drift from the real behavior
- a changed surface is missing a nearby update that users depend on
- a regression path is plausible but not yet proven severe

## Low

Use when the issue is real but mostly about maintainability, clarity, or small future-risk reduction.

Typical signals:

- wording or structure makes future mistakes more likely
- a low-risk edge case or cleanup gap is visible

## No Findings

If nothing material is wrong, say so directly.

Still note:

- skipped validation
- environment limits
- any residual risk that keeps the review from being fully exhaustive
