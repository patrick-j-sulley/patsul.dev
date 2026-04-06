/**
 * Serves Astro static output on 0.0.0.0 so private-network peers (e.g. Railway nginx) can connect.
 * Uses PORT from the environment (Railway sets this); defaults to 4321 for local checks.
 */
import { spawn } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const port = process.env.PORT || '4321';
const listen = `tcp://0.0.0.0:${port}`;

const serveCli = path.join(root, 'node_modules', 'serve', 'build', 'main.js');
const child = spawn(process.execPath, [serveCli, 'dist', '-s', '-l', listen], {
  cwd: root,
  stdio: 'inherit',
});

child.on('exit', (code, signal) => {
  if (signal) process.kill(process.pid, signal);
  process.exit(code ?? 1);
});
