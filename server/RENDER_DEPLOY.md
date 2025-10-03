Deploying the license server to Render (Docker)

This guide shows how to deploy the `server/` app to Render using Docker. Render will host the API at a public HTTPS URL which you can point your Netlify admin panel and EA to.

Steps
1. Create a GitHub repo (if you don't already) and push the project, including the `server/` folder at the repo root or as a subfolder. Ensure `package.json` and `index.js` are in `server/`.

2. On Render:
   - Sign in to https://render.com and click New → Web Service.
   - Choose "Connect a repository" and pick your GitHub repo + branch.
   - Under "Environment", choose Docker.
   - For Build Command leave blank (we use Dockerfile).
   - For Start Command leave blank (Dockerfile handles start).

3. Set Environment Variables in Render's dashboard (secure):
   - FIRESTORE_ENABLED (true or false)
   - JWT_SECRET (e.g. a long random string)
   - ALLOW_AUTO_CREATE (true/false)
   - SERVICE_ACCOUNT_JSON (optional) — The full service-account JSON contents. Because Render exposes env vars, you may prefer to base64-encode the JSON and paste it in as one line. Our `start.sh` will write it to a file and set GOOGLE_APPLICATION_CREDENTIALS.
     - To base64 encode locally: `cat /path/to/ea.json | base64 -w0`
     - In Render set SERVICE_ACCOUNT_JSON to the base64 string and also set `START_SERVICE_ACCOUNT_BASE64=true` (optional).

4. Deploy — Render will build the Docker image from the `server/Dockerfile` and start the service. Render will provide an HTTPS URL like `https://my-license-server.onrender.com`.

5. Point the Netlify admin panel at the Render URL:
   - Open: `https://your-panel-xxxxx.netlify.app/?server=https://my-license-server.onrender.com`
   - Or open the panel and paste the server URL into the Server input, then Save.

6. Update the EA (`rsivwap.mq5`) LicenseServer input to use the same URL and add it to MT5 WebRequest allowed URLs.

Notes
- SECURITY: Storing service-account JSON in an env var is convenient but not ideal — prefer provider secrets or Vault. If Render supports file secrets, use that.
- If you prefer Render's non-Docker option, set the environment to Node and set Start Command to `node index.js`, then configure the same env vars and upload service account JSON as a secret.

Troubleshooting
- If Firestore reports permission errors, verify the service account JSON matches the Firestore project and has proper roles.
- If you see CORS or 502 errors, check server logs on Render and the health endpoint `/health`.

If you want, I can also generate a `docker-compose.yml` for local testing or produce a one-click Deploy button for GitHub. Let me know.