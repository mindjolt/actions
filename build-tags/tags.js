//Removes initial v
function getTagVersion(tag) {
  return tag.toLowerCase().startsWith("v") ? tag.slice(1) : tag;
}

//interpolate tags
function buildTags(baseName, shortSHA, buildVersion, includeTagAlone) {
  let tags = [];
  tags.push(baseName, `${baseName}-${shortSHA}`);
  if (buildVersion) {
    tags.push(
      `${buildVersion}-${baseName}`,
      `${buildVersion}-${baseName}-${shortSHA}`
    );
    if (includeTagAlone) {
        tags.push(buildVersion, `${buildVersion}-${shortSHA}`);
    }
  }
  
  return tags;
}

function checkVersions(tag, buildVersion, warning) {
  //if git tag -> ignore buildVersion
  if (buildVersion && getTagVersion(buildVersion) !== getTagVersion(tag)) {
    warning &&
      warning(
        `Derived tag ${tag} does not match provided build version ${buildVersion}`
      );
    return false;
  }
  return true;
}

function removeDuplicates(tags) {
  return tags.filter((tag, index) => {
    return tags.indexOf(tag) === index;
  });
}

/**
 * Interprets the git ref and apply tag rules
 * ```
 * "ref": "refs/pull/9/merge" pr-9
 * "ref": "refs/heads/main",  concrete version
 * "ref": "refs/heads/release/1.0.1", release candidate version
 * "ref": "refs/tag/v1.0.1",  concrete version
 * ```
 *
 * @param {string} sha short commit sha
 * @param {string} ref git ref
 * @param {string} buildVersion version from the service's build system
 * @param {function} warning function that receives the warning message
 * @returns
 */
function getTags(sha, ref, buildVersion, warning) {
  const refType = ref.split("/")[1];
  const branchName = ref.split("/").slice(-1)[0];
  let tags = [];

  //for pull request, add pr-# tags
  if (refType == "pull") { 
    let pr = ref.split("/").splice(1, 2).join("-");
    tags = buildTags(pr, sha, buildVersion, false);
  }

  // for branch push, add branch-sha & build-version-sha tags
  if (refType == "heads") {
    const isReleaseBranch = ref.startsWith("refs/heads/release/");
    
    //if master or main -> create a version tag without sha
    if (branchName == "main" || branchName == "master") {
      tags = buildTags(branchName, sha, buildVersion, true);
    } else if (isReleaseBranch) {
      //if release then create a rc (release candidate) tag
      tags = buildTags(branchName + "-rc", sha, undefined, false);
      checkVersions(branchName, buildVersion, warning);
    } else {
      tags = buildTags(branchName, sha, buildVersion, false);
    }
  }
  
  //if it is a tag, add tag-sha & tag 
  if (refType == "tag") {
    checkVersions(branchName, buildVersion, warning);
    tags = buildTags(branchName, sha);
    tags.push( ...buildTags(getTagVersion(branchName), sha) )
  }
  return  removeDuplicates(tags);
}

exports.getTags = getTags;
