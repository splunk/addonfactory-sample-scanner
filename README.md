# ADDONFACTORY-SAMPLE-SCANNER

This action scans Splunk Add-on test data for potentialy identifying information which should be anonymized


# v1

This release adds reliability for pulling node distributions from a cache of node releases.

```yaml
steps:
- name: sample-scanner
uses: splunk/addonfactory-sample-scanner@v1
id: sample-scanner
```

The action will check tests/knowledge/* for potentialy identifying data and update the build or pr with annotations identifying violations.

# False positive detection

`.false-positives.yaml` file can be defined in Add-on repository to exclude false positives from the results. Use syntax from [official earlybird documentation](https://github.com/americanexpress/earlybird/blob/main/docs/FALSEPOSITIVES.md)

# Ignoring files

To exclude files from sample-scanner check define `.ge_ignore` file in Add-on repository. File patterns with `*` re supported for this file. [earlybird documentation](https://github.com/americanexpress/earlybird/blob/main/docs/IGNORE.md)

# License

The scripts and documentation in this project are released under the [Apache 2.0 License](LICENSE)

# Contributions

See [our contributor license agreement](https://github.com/splunk/cla-agreement/blob/main/CLA.md)

## Code of Conduct

:wave: Be nice.  See [our code of conduct](https://github.com/splunk/cla-agreement/blob/main/CODE_OF_CONDUCT.md)
