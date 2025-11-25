---
category: openSourceConfiguration
tocprty: 1
---


# Configure Python and R Integration with the SAS Viya Platform

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Deployment Workflow](#deployment-workflow):
  1. [Installation of Python from Source](#1-installation-of-python-from-source)
  2. [Installation of R from Source](#2-installation-of-r-from-source)
  3. [Mount Directories for Python and R](#3--mount-directories-for-python-and-r)
  4. [Configure the SAS Viya Platform to Connect to Python and R](#4-configure-the-sas-viya-platform-to-connect-to-python-and-r)
  5. [Enable LOCKDOWN Access Methods](#5-enable-lockdown-access-methods)
  6. [Configure External Access to CAS](#6-configure-external-access-to-cas)
  7. [(Optional) Configure SAS Model Repository Service for Python and R Models](#7-optional-configure-sas-model-repository-service-for-python-and-r-models)
- [Additional Resources](#additional-resources)

## Overview

The SAS Viya platform can allow two-way communication between SAS (CAS and Compute
engines) and open-source environments (Python and R). With open-source language
integration, SAS users can decide which language they want to use for a given task.
This README provides an overview of the steps to install, configure, and deploy
Python and R for integration with the SAS Viya platform.

For comprehensive documentation related to the configuration of open-source
language integration, including the use of the SAS Configurator for Open Source
tool that partially automates the setup, see [SAS Viya Platform:
Integration with External Languages](https://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyexternlang&docsetTarget=titlepage.htm).

## Prerequisites

The SAS Viya platform provides YAML files that the Kustomize tool uses to configure
Python. Before you use those files, verify that you have fulfilled the system requirements:

- Persistent storage for your SAS Viya platform deployment, such as an NFS server
that can be mounted as a persistent volume. For more information, see
[Requirements for Open-Source Integration](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/n05j01yd16icw8n1qd03ty4c4jan.htm).
- Access to the public internet so that you can download and install Python or R.

If your SAS Viya platform environment does not have public internet access, you
must first download, install, and configure Python or R onto a separate internet-connected
Linux environment. Then package up the directories (in a tarball, for
example) and copy them to the persistent storage available to your SAS Viya
platform environment. For more information, see [Install Python](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p06p36ppspce2nn128wmk4ttgf7r.htm) or [Install R](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/n1njppp7m1d2fgn1ltsogu5da4z0.htm).

## Deployment Workflow

Each of the following numbered sections provides details about installation and
configuration steps required to enable various open source integration points.

- To enable the use of Python and R code in SAS programs for data processing and
model development in the SAS Viya platform, complete Steps 1-6.
- To enable external access to CAS from open-source programming languages, including
Python and R, complete Step 6.
- To enable the registration and publishing of open-source models using SAS
Model Manager, complete Steps 1-5 (to enable open-source modeling) and Step 7.

### 1. Installation of Python from Source

Install Python from source in a persistent volume that will be mounted to the
SAS Viya platform pods. For more information, see [Install Python](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p06p36ppspce2nn128wmk4ttgf7r.htm).

SAS provides the SAS Configurator for Open Source utility
to partially automate the download and installation of Python from source. For
more information, see
[Deploying and Using SAS Configurator for Open Source](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p0thq20dh3hv7qn19lo6gmlp6vir.htm).

Python is installed into a persistent volume that is mounted to the SAS Viya
platform pods in [Step 3](#3-mount-directories-for-python-and-r).

### 2. Installation of R from Source

Install R from source in a persistent volume that will be mounted to the SAS Viya
platform pods. For more information, see [Install R](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/n1njppp7m1d2fgn1ltsogu5da4z0.htm).

SAS provides the SAS Configurator for Open Source utility
to partially automate the download and installation of R from source. For
more information, see
[Deploying and Using SAS Configurator for Open Source](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p0thq20dh3hv7qn19lo6gmlp6vir.htm).

R is installed into a persistent volume that is mounted to the SAS Viya platform
pods in [Step 3](#3--mount-directories-for-python-and-r).

After installing R, you should also download and install all desired R packages
(for example, by starting an R session and executing the
`install.packages(my-desired-package)` command). The
[official documentation](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/n1vzd0rlkcwu42n1rxcya8h62xez.htm#n1pnrpz7srq53jn1omu14cymlult)
provides advice about modifying the R and Rscript files, which contain some hardcoded
paths, and copying shared libraries.

### 3. Mount Directories for Python and R

Add NFS mounts for Python and R directories. Now that Python and R are installed
in your persistent storage, you need to mount those directories so that they
are available for the SAS Viya platform pods. Do this by copying transformers
for Python and R from the
`$deploy/sas-bases/examples/sas-open-source-config/python` and
 `$deploy/sas-bases/examples/sas-open-source-config/r` directories into your
 `$deploy/site-config/sas-open-source-config` directories for Python and R. For
 the steps, see the following sections of the official documentation:

- For Python, [Configure and Enable the Connection to Python](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p1m8h0fdcaxddfn178z3h3xaos6c.htm)
- For R, [Configure and Enable the Connection to R](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/n0f9aytxpxatsxn158a5yquzxf1v.htm)

### 4. Configure the SAS Viya Platform to Connect to Python and R

Now enable the SAS Viya platform to connect to the Python and R
binaries that you installed in the mounted persistent storage volumes.
If you are using SAS Configurator for Open Source, see:

- [Configure Python Integration Using SAS Configurator for Open Source](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p0g316mrti30tbn1ikah8dph7twz.htm)
- [Configure R Integration Using SAS Configurator for Open Source](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p0fjbgird05b8yn1okslacke4cpl.htm)

These steps involve updating the Python- and R-specific `kustomization.yaml`
files. These YAML files create environment variables that are made
available in the SAS Viya platform pods, providing the locations of the Python
and R executables and libraries.

If you have licensed SAS/IML, you also need to set two environment variables
that enable `PROC IML` to call R from a SAS program. You can automate the
creation of these environment variables by adding them to
 `$deploy/site-config/sas-open-source-config/r/kustomization.yaml`, or after
the SAS Viya platform deployment has completed, you can use SAS Environment Manager
to add them. For more information, see
[Requirements for SAS/IML](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/n01wvjxr2qv3h5n1dieons09vxmg.htm#n0m5jes0anrvdqn17q8xq06g78if).

If you plan to use the EXTLANG package that is required for FCMP and PROC TSMODEL,
both Python and R require you to create an extlang XML file to provide
external language settings. For more information, see
[Use an extlang.xml File](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p1ahtg50rjoy6vn15h69jzaor9ej.htm#n1mkb2ixjg9qzdn1sv84je1g57ex).

### 5. Enable LOCKDOWN Access Methods

This step opens up communication between Python or R and the SAS Viya platform.
LOCKDOWN  is a security feature in SAS that restricts access to specific system
files and language features. LOCKDOWN is enabled by default for the SAS Viya
platform Compute server.

You must manually enable `python` and `python_embed` methods for most, if not
all, Python integration points in order to bypass LOCKDOWN restrictions. The
`socket` method is also required to enable `PROC PYTHON` and the Python Code
Editor. For more information, see [Enable LOCKDOWN Access Methods](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p0w7q1enfoar5tn1xlpuh6aid83u.htm#n00uqhlap03y53n11zgg88ekgn2p)
in the official documentation.

### 6. Configure External Access to CAS

By default, CAS resources can be accessed by Python or R from within the cluster,
but not from clients that are external to the cluster. Additional configuration
steps are required to enable end users to access CAS resources
from outside the cluster (such as from an existing JupyterHub deployment elsewhere
or from a desktop installation of R-Studio). For more information, see
 [Configure External Access to the CAS Server](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/n1v5hyvyczigzsn13lacueqzljg3.htm).

External connections to the SAS Viya platform, including connections to the CAS
server, can also be made using resources that SAS provides for developers,
open-source programmers, and system administrators who want to leverage or
manage the computational capabilities of the SAS Viya platform from open-source
coding interfaces. See the [SAS Developer Home page](https://developer.sas.com/home.html)
for information about the various collections of resources.

### 7. (Optional) Configure SAS Model Repository Service for Python and R Models

The SAS Viya platform must be configured to enable users to register and
publish open-source models in the SAS Viya platform. The steps to take are
provided within the official documentation. For more information, see the
following:

- [Requirements for the SAS Model Repository Service](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/n01wvjxr2qv3h5n1dieons09vxmg.htm#n02q85napamjvin12jikzg2af1yc)
- [Enable the SAS Model Repository Service](https://documentation.sas.com/doc/en/itopscdc/default/dplyexternlang/p1gh3tbu0r6jihn1hndt965nuvic.htm)
- [SAS Viya Platform: Publishing Destinations](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calpubdest&docsetTarget=n1i7t4fs3kdr88n1uj6h47e39w1b.htm)
- [SAS Viya Platform: Models Administration -- Configuring Support for Open-Source Models](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calmodels&docsetTarget=n11vwdrly0qi10n1pq1h13t890e2.htm)
- [SAS Model Manager: Administrator's Guide -- Configuring Support for Python Code Files](https://documentation.sas.com/?cdcId=mdlmgrcdc&cdcVersion=default&docsetId=mdlmgrag&docsetTarget=p1pux2up89u0nln1fub8zb2aqets.htm)
- [SAS GitHub: Model Management Resources](https://github.com/sassoftware/model-management-resources/tree/main/addons)

## Additional Resources

The SAS Viya platform also supports direct integration with Git within the SAS
Studio interface. Update the properties described in the following resources:

- [SAS Studio Administrator's Guide: Configuration Properties for Git Integration](https://documentation.sas.com/?cdcId=webeditorcdc&cdcVersion=default&docsetId=webeditorag&docsetTarget=p1a2vn20wzwkumn1freonkz81mx5.htm):
Identifies the relevant configuration properties to enable Git integration
- [SAS Studio Administrator's Guide: General Configuration Properties](https://documentation.sas.com/?cdcId=webeditorcdc&cdcVersion=default&docsetId=webeditorag&docsetTarget=n0kxc7fd8os3nbn14nrddoli75x2.htm):
Describes configuration properties that are required to enable Git functionality

You can find additional useful information related to open-source integration in
the following documents:

- [SAS Viya Platform System Requirements: Integrating Open Source Tools](https://documentation.sas.com/doc/en/itopscdc/default/itopssr/p1n66p7u2cm8fjn13yeggzbxcqqg.htm#p19cpvrrjw3lurn135ih46tjm7oi)
- [SAS Viya Platform Deployment: Configure External Access to CAS](https://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=n08u2yg8tdkb4jn18u8zsi6yfv3d.htm#n0exq3y1b5gs73n18vi9o78y2dg3)
- [Python-SWAT GitHub repository](https://github.com/sassoftware/Python-swat/)
- [R-SWAT GitHub repository](https://github.com/sassoftware/R-swat/)
- [SAS Developer Home page](https://developer.sas.com/home.html)
