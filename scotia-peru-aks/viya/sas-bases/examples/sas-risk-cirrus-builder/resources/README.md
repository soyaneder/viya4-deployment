---
category: SAS Risk Cirrus Builder Microservice
tocprty: 2
---

# Configure Default Settings for SAS Risk Cirrus Builder Microservice

## Overview

SAS Risk Cirrus Builder Microservice is the Go service that backs the Solution Builder.
The service manages the lifecycle of solutions and their customizations.

By default, SAS Risk Cirrus Builder Microservice is deployed with some
default settings. These settings can be overridden via the
sas_risk_cirrus_builder_transform.yaml file. There is a template (in
`$deploy/sas-bases/examples/sas-risk-cirrus-builder/resources`) that
should be used as a starting point.

There is no requirement to configure this transform.  Currently all fields in the transform are optional (with the default value documented here used as default if not supplied).

**Note:** For more information about the SAS Risk Cirrus Builder Microservice, see 
[Introduction to SAS Risk Cirrus](https://go.documentation.sas.com/doc/en/cirruscdc/default/cirrusag/n0dswnd6mu8lkdn181uyij4dutln.htm)
in the _SAS Risk Cirrus: Administrator's Guide_.

## Installation

1. Copy the files in `$deploy/sas-bases/examples/sas-risk-cirrus-builder/resources`
   to the `$deploy/site-config/sas-risk-cirrus-builder/resources` directory. Create a
   destination directory if one does not exist.

**IMPORTANT:** If the destination directory already exists, verify that the
overlay default settings (#verify-overlay-default-settings) have been
correctly applied. No further actions are required, unless you want to change
the default settings to different values.

2. Modify the sas_risk_cirrus_builder_transform.yaml file (located in the
   `$deploy/site-config/sas-risk-cirrus-builder/resources` directory) to specify your
   settings as follows:

- For RISK_CIRRUS_UI_SAVE_ENABLED, replace {{ ENABLE-ARTIFACTS-SAVE }} with the desired value.
  Use 'true' to enable saving the UI artifacts in the solution builder UI. Use 'false' to disable saving the UI artifacts.
  **Note:** In 'production' or 'test' systems, this should be set to 'false' so that the UI artifacts cannot be
  accidentally updated in the configured repository.  Activation of existing commits will be allowed regardless of this value.
  If not configured, the default is 'true'
- For DEFAULT_EMAIL_ADDRESS, replace {{ EMAIL-ADDRESS }} with the email address to use for connecting to git if the logged in user does not have an email address defined.  If not configured, the system will default to '{logged in userid}@email.address.com'
- For SAS_LOG_LEVEL_RISKCIRRUSBUILDER, replace {{ INFO-OR-DEBUG }} with the logging level desired.  If not configured, the default is 'INFO'.
- For SAS_LOG_LEVEL_RISKCIRRUSCOMMONS, replace {{ INFO-OR-DEBUG }} with the logging level desired.  If not configured, the default is 'INFO'.
- For SAS_LOG_LEVEL, replace {{ INFO-OR-DEBUG }} with the logging level desired.  If not configured, the default is 'INFO'.
  **Note:** Setting this to DEBUG will result in the logging for all the other SAS Microservices that SAS Risk Cirrus Builder
  communicates with, thereby increasing the size of the log.

3. In the base kustomization.yaml file in the $deploy directory, add
   site-config/risk-cirrus-builder/resources/sas_risk_cirrus_builder_transform.yaml to the transformers
   block. Here is an example:

   ```yaml
   transformers:
     - site-config/risk-cirrus-builder/resources/sas_risk_cirrus_builder_transform.yaml
   ```

4. Complete the deployment steps to apply the new settings. See [Deploy the
   Software](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm)
   in the _SAS Viya Platform: Deployment Guide_.

**Note:** This overlay can be applied during the initial deployment of the SAS Viya platform.
or after the deployment of the SAS Viya platform.

- If you are applying the overlay during the initial deployment of the SAS Viya platform,
  complete all the tasks in the README files that you want to use, and then
  run `kustomize build` to create and apply the manifests.
- If the overlay is applied after the initial deployment of the SAS Viya platform, run
  `kustomize build` to create and apply the manifests.

## Verify Overlay Default Settings

1. Run the following command to verify whether the overlay has been applied to
   the configuration map:

   ```sh
   kubectl -n <name-of-namespace> get configmap | grep sas-risk-cirrus-builder
   ```

   The above will return the ConfigMap defined for sas-risk-cirrus-builder.
   Here is an example:

   ```yaml
   sas-risk-cirrus-builder-parameters-<id>                      9      6d19h
   ```

2. Execute the following:

   ```sh
   kubectl describe configmap sas-risk-cirrus-builder-parameters-<id> -n
   <name-of-namespace>
   ```

3. Verify that the output contains the settings that you configured.

   ```yaml
   Name:         sas-risk-cirrus-builder-parameters-<id>
   Namespace:    <name-of-namespace>
   Labels:       sas.com/admin=cluster-local
                  sas.com/deployment=sas-viya
   Annotations:  <none>

   Data
   ====
   SAS_LOG_LEVEL_RISKCIRRUSBUILDER:
   ----
   INFO
   SAS_LOG_LEVEL_RISKCIRRUSCOMMONS:
   ----
   INFO
   RISK_CIRRUS_UI_SAVE_ENABLED:
   ----
   true
   DEFAULT_EMAIL_ADDRESS:
   ----
   admin@myhost.com
   ```