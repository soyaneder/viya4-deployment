---
category: security
tocprty: 7
---

# Configuring Kerberos Single Sign-On for the SAS Viya Platform

This README describes the steps necessary to configure the SAS Viya platform for single sign-on
using Kerberos.

## Prerequisites

Before you start the deployment, obtain the Kerberos configuration file and keytab for the HTTP
service account. Make sure you have tested the keytab before proceeding with the installation.

## Installation

1. Copy and then edit the files in the $deploy/sas-bases/examples/kerberos/http directory to the $deploy/site-config/kerberos/http directory. Create the target directory, if it does not already exist.

   * Replace {{ PRINCIPAL-NAME-IN-KEYTAB }} with the name of the principal as it appears in the keytab.
   * Replace {{ SPN }} with the name of the SPN. This should have a format of `HTTP/<hostname>` and may be the same as the principal name in the keytab.
   * See description of the remaining options below that can be uncommented.

2. Copy your Kerberos keytab and configuration files into the `$deploy/site-config/kerberos/http` directory, naming them `keytab` and `krb5.conf` respectively.

3. Make the following changes to the base kustomization.yaml file in the $deploy directory.

   * Add site-config/kerberos/http to the resources block.
   * Add sas-bases/overlays/kerberos/http/transformers.yaml to the transformers block.

4. Use the deployment commands described in [SAS Viya Platform Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm) to apply the new settings.

## Options

#### To enable Kerberos debugging in the JVM
JAVA_OPTION_KRB5_DEBUG=-Dsun.security.krb5.debug=true
JAVA_OPTION_JGSS_DEBUG=-Dsun.security.jgss.debug=true

#### To enable Spring security Kerberos debugging
SAS_LOGON_KERBEROS_DEBUG=true

#### When not using Kerberos unconstrained delegation, disable the warning page when users sign-in
SAS_LOGON_KERBEROS_DISABLEDELEGATIONWARNING=true

#### To enable Kerberos unconstrained delegation
SAS_LOGON_KERBEROS_HOLDONTOGSSCONTEXT=true