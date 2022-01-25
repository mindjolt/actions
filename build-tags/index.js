const core = require("@actions/core");
const T = require("./tags");

try {
  const buildTag = core.getInput("build-version");
  const tagSep = core.getInput("tag-separator") || '\n';
  const baseTags = core.getMultilineInput("base-tags") || [];

  const repoName = process.env.GITHUB_REPOSITORY.split("/").slice(-1)[0];
  const shortSHA = process.env.GITHUB_SHA.substring(0, 7);

  const ref = process.env.GITHUB_REF || "unknown";

  let tags = T.getTags(shortSHA, ref, buildTag);
  core.info(`Generated tags ${outTags}`);

  const outTags = tags.concat(baseTags).join(tagSep);

  core.setOutput("repo", repoName);
  core.setOutput("sha", shortSHA);
  core.setOutput("tags", outTags);

  core.info(`Output tags ${outTags}`);

} catch (error) {
  core.setFailed(error.message);
}
