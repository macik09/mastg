---
platform: android
title: Sensitive Data Stored Unencrypted via SQLite
id: MASTG-TEST-0304
type: [static, dynamic]
weakness: MASWE-0006
best-practices: [MASTG-BEST-0074]
profiles: [L1, L2]
status: new
---

## Overview

This test verifies whether an app stores sensitive data — such as tokens, credentials, or personally identifiable information (PII) — in SQLite databases (@MASTG-KNOW-0037) without encryption.
SQLite databases created using APIs like `SQLiteOpenHelper` or `context.openOrCreateDatabase` are not encrypted by default.
The goal of this test is to determine whether the app relies on plaintext SQLite storage instead of secure alternatives (e.g., SQLCipher or encrypted database frameworks).

---

## Steps

### Static Analysis

1. Obtain the application package (e.g., APK file) using @MASTG-TECH-0003.

2. Use a static analysis technique (@MASTG-TECH-0014) to review the code and identify references to SQLite APIs such as:
    - `SQLiteOpenHelper`
    - `context.openOrCreateDatabase`
    - `SQLiteDatabase#insert`, `query`, `execSQL`, etc.

3. Review database creation and insertion logic to determine whether:
    - the database is created using default (unencrypted) SQLite,
    - no encryption layer or secure wrapper is applied (e.g., SQLCipher),
    - sensitive fields (tokens, secrets, PII) are inserted without transformation or protection.

### Dynamic Analysis

1. Install and run the app on a rooted or emulated device (@MASTG-TECH-0005).

2. Trigger app functionality that processes or stores sensitive data.

3. Access the app's private storage and locate SQLite database files (e.g., files with `db`, `sqlite`, `sqlite3`). This requires accessing the app data directories (@MASTG-TECH-0008).

4. Extract the database file from the device to the host machine using @MASTG-TECH-0003.

5. Inspect the database content using a suitable tool, applying the technique for Dynamic Analysis (@MASTG-TECH-0015) to confirm whether sensitive data is stored in plaintext.

---

## Observation

The output should indicate:

- which SQLite databases the app creates,
- whether sensitive data (tokens, secrets, PII) is present inside these databases,
- whether the stored values appear in plaintext.

---

## Evaluation

The test fails if:

- sensitive data is stored using the default, unencrypted SQLite implementation,
- no encryption mechanism (SQLCipher or equivalent) protects the stored data,
- sensitive values inside the database can be read in plaintext through static or dynamic analysis.
