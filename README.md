# made breaking relase
#infrastructure-modules
test
##added the eks details as well, as mentioned:
hello
semantic version details are referenced from : https://svdoscience.com/2020-10-31/versioning-with-semantic-release
need some changes to the read me file


#Updating the version

### Version and Changelog Management

Steps to update the version and changelog automatically using a specific format.

Version Format: v{major}.{minor}.{patch} → Breaking.New.Fix

Example:
v1.3.4

Tags will be updated based on **commit messages**, the changelog is organized based on the type of changes introduced in each version.

### Major Version
- **Breaking:** This indicates a major change. Provide a brief description of the major changes introduced in this section.
### Minor Version
- **New:** This signifies the addition of new feature(s). Describe the new features introduced in this section.
### Patch Version
- **Fix:** This denotes bug(s) that have been fixed. Describe the bug(s) that were fixed in this section.

### Example Usage

Here's an example to demonstrate the usage of the version and changelog management, suppose we have the following initial version:

- Version: v1.3.4

1. To patch the version to v1.3.5 and changelog, perform the following steps:
Execute the command: `git commit -am "Fix: YOUR_COMMIT_MESSAGE"`.

```diff
- example: git commit -am "Fix: IR-12345 fixed pager duty alerts"
```
- **Fix** keyword will update the patch version
- This command will update the version from v1.3.4 to v1.3.5.
- The changelog will be automatically generated based on the commit message.

2. To update the Minor version
Execute the command: `git commit -am "New: YOUR_COMMIT_MESSAGE"`

```diff
- example: git commit -am "New: IR-12345 deployed prometheus alerts"
```
- **New** keyword will update the major version
- This command will update the version from v1.3.4 to v1.4.0

3. To update the Major version
Execute the command: `git commit -am "Breaking: YOUR_COMMIT_MESSAGE"`

```diff
- example: git commit -am "Breaking: IR-12345 updated EKS version"
```
- **Breaking** keyword will update the major version
- This command will update the version from v1.3.4 to v2.0.0
