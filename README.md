# Spark Manager Client

A pip-installable Python client for the [cdm-kube-spark-manager](https://github.com/kbase/cdm-kube-spark-manager) API.

## Overview

This repository contains a Python client library used to interact programmatically with the `cdm-kube-spark-manager` API. It allows you to start, stop, and monitor Spark applications from any Python environment.

The client itself is auto-generated from the manager's OpenAPI specification  to ensure it stays in sync with the latest API changes. To generate it, please use [run.sh](run.sh), commit the changes to github, and tag a release.


## Prerequisites

* Python 3.8+
* `pip`
* `git`

## Installation

You can install this client directly from the GitHub repository using `pip` using a specific version tag

```
cdm-spark-manager-client @ git+https://github.com/kbase/cdm-kube-spark-manager-client.git@0.0.1
```
