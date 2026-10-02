// Automated HTTP integration tests for the DevOps pipeline (Test stage).
// These exercise the running Express application via supertest without
// requiring a database, so they give real pass/fail signal in CI.

const assert = require('assert');
const request = require('supertest');
const app = require('../app');

describe('Application HTTP integration tests', function () {

  it('GET /health returns HTTP 200', async function () {
    const res = await request(app).get('/health');
    assert.strictEqual(res.status, 200);
  });

  it('GET /health returns the body "OK"', async function () {
    const res = await request(app).get('/health');
    assert.strictEqual(res.text, 'OK');
  });

  it('GET /health returns a non-empty response body', async function () {
    const res = await request(app).get('/health');
    assert.ok(res.text && res.text.length > 0, 'health body should not be empty');
  });

  it('GET an unknown route returns HTTP 404', async function () {
    const res = await request(app).get('/this-route-does-not-exist-12345');
    assert.strictEqual(res.status, 404);
  });

});
