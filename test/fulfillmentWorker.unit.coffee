"use strict"
assert = require "assert"
FulfillmentWorker = require "../lib/fulfillmentWorker"
error = require "../lib/error"
config = undefined

testRequiresConfigParameter = (config, propName) ->
  delete config[propName]

  try
    new FulfillmentWorker config
    assert.fail "Expected a ConfigurationMissingError."
  catch err
    assert err instanceof error.ConfigurationMissingError
    assert.deepEqual err.missingProperties, [propName]
  return

describe "FulfillmentWorker unit tests", ->
  beforeEach ->
    config =
      region: "fakeRegion"
      accessKeyId: "fakeAccessKeyId"
      secretAccessKey: "fakeSecretAccessKey"
      domain: "fakeDomain"
      name: "fakeWorkerName"
      version: "fakeWorkerVersion"

  describe "constructor", ->
    it "Requires a config", ->
      try
        new FulfillmentWorker()
        assert.fail "Expected a ConfigurationMustBeObjectError."
      catch err
        assert err instanceof error.ConfigurationMustBeObjectError
        assert.strictEqual err.suppliedType, "undefined"

    it "Requires that the config be an object", ->
      try
        new FulfillmentWorker("not an object")
        assert.fail "Expected a ConfigurationMustBeObjectError."
      catch err
        assert err instanceof error.ConfigurationMustBeObjectError
        assert.strictEqual err.suppliedType, "string"

    it "Requires config.region", ->
      testRequiresConfigParameter config, "region"

    it "Requires config.domain", ->
      testRequiresConfigParameter config, "domain"

    it "Requires config.workerName", ->
      testRequiresConfigParameter config, "name"

    it "Requires config.workerVersion", ->
      testRequiresConfigParameter config, "version"
