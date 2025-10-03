#!/usr/bin/env node
// Small helper to start the server (index.js) and create an ngrok tunnel
const { spawn } = require('child_process');
const ngrok = require('ngrok');
const path = require('path');

const PORT = process.env.PORT || 3000;
const NGROK_TOKEN = process.env.NGROK_AUTH_TOKEN || process.env.NGROK_TOKEN;

(async () => {
  // Start the server
  const serverPathCandidates = [
    path.resolve(__dirname, 'index.js'),
    path.resolve(__dirname, '..', 'server', 'index.js'),
  ];

  let serverPath = serverPathCandidates.find(p => require('fs').existsSync(p));
  if (!serverPath) {
    console.error('Cannot find server index.js at', serverPathCandidates);
    process.exit(1);
  }

  const child = spawn('node', [serverPath], { stdio: 'inherit', env: process.env });

  child.on('exit', (code) => {
    console.log('Server process exited', code);
    process.exit(code);
  });

  // Start ngrok tunnel
  if (!NGROK_TOKEN) {
    console.error('Please set NGROK_AUTH_TOKEN or NGROK_TOKEN in env to start ngrok');
    console.error('Server is running locally at http://localhost:' + PORT);
    return;
  }

  try {
    const url = await ngrok.connect({ authtoken: NGROK_TOKEN, addr: PORT });
    console.log('ngrok tunnel established:', url);
    console.log('Use this URL in your MT5 WebRequest and Netlify admin server field.');
  } catch (err) {
    console.error('ngrok failed to start:', err);
  }
})();
