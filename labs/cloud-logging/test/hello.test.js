const assert = require('assert');
const { spawn } = require('child_process');
const path = require('path');
const { request } = require('gaxios');
const waitPort = require('wait-port');

const PORT = 8080;

describe('helloGET', function () {
    this.timeout(10000);

    let proc;

    before(async () => {
        const bin = path.join(
            __dirname,
            '..',
            'node_modules',
            '.bin',
            process.platform === 'win32' ? 'functions-framework.cmd' : 'functions-framework',
        );

        proc = spawn(bin, ['--target', 'helloGET', '--port', String(PORT)], {
            cwd: path.join(__dirname, '..'),
            stdio: 'inherit',
        });

        const open = await waitPort({
            host: '127.0.0.1',
            port: PORT,
            timeout: 10000,
        });

        if (!open) {
            throw new Error('Functions Framework failed to start');
        }
    });

    after(() => {
        if (proc && !proc.killed) {
            proc.kill();
        }
    });

    it('echoes the message', async () => {
        const message = 'test-message';
        const res = await request({
            url: `http://127.0.0.1:${PORT}/?message=${message}`,
            method: 'GET',
            responseType: 'text',
        });

        assert.strictEqual(res.data, `Hello World! Message was ${message}`);
    });
});
