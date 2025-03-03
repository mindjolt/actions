const fs = require("fs");
const core = require("@actions/core");

const blockRegex = /(^(#|\/\/) start x-gs-replace-version.*[\n\r]+)(^.*[\n\r]+)(^(#|\/\/) end x-gs-replace-version.*[\n\r]+)/gm;
const inlineRegex = /(^.*)((#|\/\/) x-gs-replace-version.*$)/gm;

try {
  const fromVersion = core.getInput("from-version");
  const toVersion = core.getInput("to-version");
  const files = core.getMultilineInput("files");

  files.forEach(file => {
    fs.readFile(file, "utf-8", (err, data) => {
      if (err) {
        throw new Error(`Failed to read from file ${file}`);
      }
      const replacedContents = data.replaceAll(blockRegex, (m, cg1, cg2, cg3, cg4) => {
        return cg1.concat(cg3.replaceAll(fromVersion, toVersion)).concat(cg4);
      }).replaceAll(inlineRegex, (m, cg1, cg2) => {
        return cg1.replaceAll(fromVersion, toVersion).concat(cg2);
      });
      fs.writeFile(file, replacedContents, "utf-8", (err) => {
        if (err) {
          throw new Error(`Failed to write to file ${file}`);
        }
        core.info(`Updated file ${file}`);
      });
    });
  });
} catch (error) {
  core.setFailed(error.message);
}