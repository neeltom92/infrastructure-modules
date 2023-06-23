# made breaking relase
#infrastructure-modules

##added the eks details as well, as mentioned:
hello
semantic version details are referenced from : https://svdoscience.com/2020-10-31/versioning-with-semantic-release
need some changes to the read me file

# Version and Changelog Management

This guide provides steps to update the version and changelog automatically using a specific format.

Version Format: v{major}.{minor}.{patch} → Breaking.New.Fix
Example: v1.3.4

Tags will be updated based on commit messages.

## Updating the Version

To update the version, follow these steps:

1. Use the command: `git commit -am "Breaking: made version change"`. This command will update the version from v1.3.4 to v2.0.0.

## Changelog Structure

The changelog is organized based on the type of changes introduced in each version.

### Major Version

- **Breaking:** This indicates a major change. Provide a brief description of the major changes introduced in this section.

### Minor Version

- **New:** This signifies the addition of new feature(s). Describe the new features introduced in this section.

### Patch Version

- **Fix:** This denotes bug(s) that have been fixed. Describe the bug(s) that were fixed in this section.

## Example Usage

Here's an example to demonstrate the usage of the version and changelog management:

Suppose we have the following initial version:

- Version: v1.3.4

To update the version and changelog, perform the following steps:

1. Execute the command: `git commit -am "Breaking: made version change"`.
   - This command will update the version from v1.3.4 to v2.0.0.
   - The changelog will be automatically generated based on the commit message.

## Conclusion

By following these steps, you can easily update the version and changelog automatically for your project. This helps in keeping track of the changes made and provides a clear overview of each version's major changes, new features, and bug fixes.

For more information, please refer to the full documentation.
