---
platform: android
title: Sensitive Data Stored Unencrypted via DataStore
id: MASTG-TEST-0305
type: [static, dynamic]
weakness: MASWE-0006
best-practices: [MASTG-BEST-0074]
profiles: [L1, L2]
status: new
---

## Overview

This test verifies whether an app stores sensitive data — such as tokens, passwords, or personally identifiable information (PII) — using Jetpack DataStore without encryption.
Both Preferences DataStore (backed by `.preferences_pb` file) and Proto DataStore (backed by `.proto` file) persist data in plaintext by default unless developers explicitly implement and apply an encryption layer (e.g., using `SecurityCrypto` or a custom serializer).
The goal of this test is to detect insecure storage of sensitive information in DataStore files within the app sandbox.

---

## Steps

### Static Analysis
1. Obtain the application package (e.g., APK file) using @MASTG-TECH-0003.
2. Use a static analysis technique (@MASTG-TECH-0014) to identify references to DataStore APIs such as:
    - `androidx.datastore.preferences.preferencesDataStore`
    - `androidx.datastore.core.DataStore` (or usage of generated Proto classes).
    - `dataStore.edit`, `updateData`, or `write` operations.
3. Inspect the code to determine whether:
    - sensitive data is stored using the default, unencrypted implementation.
    - a secure mechanism (e.g., applying an `EncryptedFile.Builder` for Preferences DataStore or using an encrypted custom serializer for Proto DataStore) is explicitly applied to the sensitive fields.

### Dynamic Analysis
1. Install and run the app on a rooted or emulated device (@MASTG-TECH-0005).
2. Trigger app functionality that processes or stores sensitive data.
3. Access the app’s private storage (typically `/data/data/<package_name>/datastore/`) and locate the DataStore files. This requires accessing the app data directories (@MASTG-TECH-0008). File names usually end with:
    - `.preferences_pb` (Preferences DataStore)
    - `.proto` (Proto DataStore)
4. Extract the DataStore files from the device using @MASTG-TECH-0003.
5. Inspect the file content using a suitable tool, applying the technique for Dynamic Analysis (@MASTG-TECH-0015) to confirm whether sensitive data is stored in plaintext. *Note: Proto DataStore files require a Proto decoder for inspection.*

---

## Observation

The output should indicate:
- which DataStore files the app creates,
- whether sensitive data (tokens, secrets, PII) is present inside these files,
- whether the stored values appear in plaintext (or easily reversible format).

---

## Evaluation

The test fails if:
- sensitive data is stored in DataStore files without encryption.
- plaintext tokens, secrets, or PII can be read from the DataStore files through static or dynamic analysis.
