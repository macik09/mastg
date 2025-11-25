---
platform: android
title: Sensitive Data in Unencrypted SQLite
id: MASTG-DEMO-0068
code: [kotlin]
test: MASTG-TEST-0304
status: new
---

### Sample

The snippet below shows sample code that uses the default SQLite API (`context.openOrCreateDatabase`) to store sensitive data, including PII and an access token, without any encryption.

{{ MastgTest.kt }}

### Steps

1. Install the application on a test device.
2. Open the app and exercise it to trigger the database creation and data insertion.
3. Execute the analysis script **`run.sh`**.
4. The script pulls the database file (`PrivateUnencryptedData.db`) and queries its content.

{{ run.sh }}

### Observation

The `output.txt` file contains the extracted content from the `Users` table, showing the sensitive PII (email address) and the access token stored in **plaintext**.

{{ output.txt }}

### Evaluation

This test fails because the application stores highly sensitive data (Access Token and PII like the user's email address) using the standard SQLite API. By default, SQLite stores data in an unencrypted file within the app's private sandbox, violating the **MASVS-STORAGE** requirement (MASWE-0006). This data is trivially accessible if an attacker achieves privileged access to the device (e.g., via root).
