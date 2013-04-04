
describe "contrib-auth plugin", =>
  it "should auth configs implement provider methods", =>
    chai.assert.isFunction (new SymfioAuthConfigs).$get
