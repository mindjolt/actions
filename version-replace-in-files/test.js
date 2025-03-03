const { before } = require('lodash');

const mockCore = {
  getInput: jest.fn(),
  getMultilineInput: jest.fn(),
  info: jest.fn(),
  setFailed: jest.fn()
};
jest.mock('@actions/core', () => mockCore);

const fs = jest.requireActual('fs');
const mockFs = {
  readFile: jest.fn(),
  writeFile: jest.fn()
};
jest.mock('fs', () => mockFs);

const fileData = fs.readFileSync('testData/input.txt', 'utf-8');
const expectedOutput = fs.readFileSync('testData/output.txt', 'utf-8');

beforeEach(() => {
  jest.resetAllMocks();
  jest.resetModules();
});

describe("should replace version in files", () => {
  test("should replace version in files", async () => {
    mockCore.getInput.mockReturnValueOnce("0.1.1");
    mockCore.getInput.mockReturnValueOnce("0.1.2");
    mockCore.getMultilineInput.mockReturnValueOnce(["file1", "file2"]);

    mockFs.readFile.mockImplementation((file, encoding, cb) => {
      cb(null, fileData);
    });
    mockFs.writeFile.mockImplementation((file, data, encoding, cb) => {
      cb(null);
    });

    await require('./index');

    expect(mockCore.getInput).toHaveBeenCalledWith("from-version");
    expect(mockCore.getInput).toHaveBeenCalledWith("to-version");
    expect(mockCore.getMultilineInput).toHaveBeenCalledWith("files");

    expect(mockFs.readFile).toHaveBeenCalledWith("file1", "utf-8", expect.any(Function));
    expect(mockFs.readFile).toHaveBeenCalledWith("file2", "utf-8", expect.any(Function));

    expect(mockFs.writeFile).toHaveBeenCalledWith("file1", expectedOutput, "utf-8", expect.any(Function));
    expect(mockFs.writeFile).toHaveBeenCalledWith("file2", expectedOutput, "utf-8", expect.any(Function));

    expect(mockCore.setFailed).not.toHaveBeenCalled();

    expect(mockCore.info).toHaveBeenCalledTimes(2);
    expect(mockCore.info).toHaveBeenCalledWith("Updated file file1");
    expect(mockCore.info).toHaveBeenCalledWith("Updated file file2");
  });

  test("should fail if file missing", async () => {
    mockCore.getInput.mockReturnValueOnce("0.1.1");
    mockCore.getInput.mockReturnValueOnce("0.1.2");
    mockCore.getMultilineInput.mockReturnValueOnce(["file1"]);

    mockFs.readFile.mockImplementation((file, encoding, cb) => {
      cb("missing");
    });

    await require('./index');

    expect(mockCore.getInput).toHaveBeenCalledWith("from-version");
    expect(mockCore.getInput).toHaveBeenCalledWith("to-version");
    expect(mockCore.getMultilineInput).toHaveBeenCalledWith("files");

    expect(mockFs.readFile).toHaveBeenCalledWith("file1", "utf-8", expect.any(Function));

    expect(mockFs.writeFile).not.toHaveBeenCalled();

    expect(mockCore.info).not.toHaveBeenCalled();

    expect(mockCore.setFailed).toHaveBeenCalledTimes(1);
    expect(mockCore.setFailed).toHaveBeenCalledWith("Failed to read from file file1");
  });

  test("should fail if file write fails", async () => {
    mockCore.getInput.mockReturnValueOnce("0.1.1");
    mockCore.getInput.mockReturnValueOnce("0.1.2");
    mockCore.getMultilineInput.mockReturnValueOnce(["file1"]);

    mockFs.readFile.mockImplementation((file, encoding, cb) => {
      cb(null, fileData);
    });
    mockFs.writeFile.mockImplementation((file, data, encoding, cb) => {
      cb("fail");
    });

    await require('./index');

    expect(mockCore.getInput).toHaveBeenCalledWith("from-version");
    expect(mockCore.getInput).toHaveBeenCalledWith("to-version");
    expect(mockCore.getMultilineInput).toHaveBeenCalledWith("files");

    expect(mockFs.readFile).toHaveBeenCalledWith("file1", "utf-8", expect.any(Function));

    expect(mockFs.writeFile).toHaveBeenCalledWith("file1", expectedOutput, "utf-8", expect.any(Function));

    expect(mockCore.info).not.toHaveBeenCalled();

    expect(mockCore.setFailed).toHaveBeenCalledTimes(1);
    expect(mockCore.setFailed).toHaveBeenCalledWith("Failed to write to file file1");
  });
});
