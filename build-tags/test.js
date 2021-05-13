const assert = require("assert");
const t = require("./tags");

//const warning = (msg) => console.log(msg);
let called = false;
let warnMsg = "";
const warning = (msg) => {
  called = true;
  warnMsg = msg;
  //console.log(msg);
};

let tags = t.getTags("f593409", "refs/pull/9/merge", "0.1.1", warning);
assert.deepStrictEqual(
  tags,
  ["pull-9", "pull-9-f593409", "0.1.1-pull-9", "0.1.1-pull-9-f593409"],
  "pull request and buildVersion"
);

tags = t.getTags("f593409", "refs/pull/9/merge", undefined, warning);
assert.deepStrictEqual(tags, ["pull-9", "pull-9-f593409"], "pull request only");

tags = t.getTags("f593409", "refs/heads/main", "0.1.1", warning);
assert.deepStrictEqual(
  tags,
  [
    "main",
    "main-f593409",
    "0.1.1-main",
    "0.1.1-main-f593409",
    "0.1.1",
    "0.1.1-f593409",
  ],
  "main branch and buildVersion"
);

tags = t.getTags("f593409", "refs/heads/develop", "0.1.1", warning);
assert.deepStrictEqual(
  tags,
  ["develop", "develop-f593409", "0.1.1-develop", "0.1.1-develop-f593409"],
  "develop branch and buildVersion"
);

tags = t.getTags("f593409", "refs/heads/main", undefined, warning);
assert.deepStrictEqual(tags, ["main", "main-f593409"], "main branch only");

assert.ok(called == false, "warning called");

tags = t.getTags("f593409", "refs/heads/release/1.0.1", "0.1.1", warning);
assert.deepStrictEqual(
  tags,
  ["1.0.1-rc", "1.0.1-rc-f593409"],
  "release branch match buildVersion"
);

assert.ok(called, "warning called");
called = false;

tags = t.getTags("f593409", "refs/heads/release/1.0.1", "1.0.1", warning);
assert.deepStrictEqual(
  tags,
  ["1.0.1-rc", "1.0.1-rc-f593409"],
  "release branch match buildVersion"
);

assert.ok(!called, "warning called");
called = false;

tags = t.getTags("f593409", "refs/tag/v1.0.1", "0.1.1", warning);
assert.deepStrictEqual(
  tags,
  ["v1.0.1", "v1.0.1-f593409", "1.0.1", "1.0.1-f593409"],
  "tag push with match incorrect buildVersion"
);

assert.ok(called, "warning not called");
called = false;

tags = t.getTags("f593409", "refs/tag/1.0.1", "1.0.1", warning);
assert.deepStrictEqual(
  tags,
  ["1.0.1", "1.0.1-f593409"],
  "tag push without v with match incorrect buildVersion"
);
assert.ok(!called, "warning called");

tags = t.getTags("f593409", "refs/tag/goodVersion", "1.0.1", warning);
assert.deepStrictEqual(
  tags,
  ["goodVersion", "goodVersion-f593409"],
  "tag push without v with match incorrect buildVersion"
);
assert.ok(called, "warning not called");

console.log("Tests ok");