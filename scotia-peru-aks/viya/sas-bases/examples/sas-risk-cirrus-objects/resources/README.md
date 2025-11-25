---
category: SAS Risk Cirrus Objects Microservice
tocprty: 2
---

# Configure Environment ID Settings for SAS Risk Cirrus Objects Microservice

## Overview

The SAS Risk Cirrus Objects Microservice stores information related to business object definitions and business
object instances such as analysis data, analysis runs, models, or model reviews. Cirrus Objects also stores and
retrieves items related to business objects, such as attachments. These business objects are associated with the
Risk Cirrus Platform that underlies most Risk offerings.

SAS Risk Cirrus Objects is deployed with some default settings. These settings can be overridden by using
the `$deploy/sas-bases/examples/sas-risk-cirrus-objects/resources/sas_risk_cirrus_objects_transform.yaml` file
as a starting point.

There is no requirement to configure this transform. Currently, all fields in the transform are optional (with the
default value documented here used if no value is supplied).

**Note:** For more information about the SAS Risk Cirrus Objects Microservice,
see [Administrator's Guide: Cirrus Objects](https://go.documentation.sas.com/doc/en/cirruscdc/v_024/cirrusag/about-cirrus-objects.htm).

## Installation

1. Copy the files in `$deploy/sas-bases/examples/sas-risk-cirrus-objects/resources`
   to the `$deploy/site-config/sas-risk-cirrus-objects/resources` directory. Create a
   destination directory if one does not exist.

   **IMPORTANT:** If the destination directory already exists, verify that the
   [overlay default settings](#verify-overlay-default-settings) have been correctly applied. No further actions are
   required, unless
   you want to change the default settings to different values.

2. Modify the new copy of `sas_risk_cirrus_objects_transform.yaml` to specify your
   settings as follows:

   - For JAVA_OPTION_ENVIRONMENT_ID, replace {{ MY-ENVIRONMENT-ID }} with the identifier you have chosen for
      this particular environment.

   - If not configured, the system will default to no environment identifier.

3. In the base `kustomization.yaml` file in the `$deploy` directory, add
   `site-config/risk-cirrus-objects/resources/sas_risk_cirrus_objects_transform.yaml` to the **transformers**
   block. Here is an example:

   ```yaml
   transformers:
   - site-config/risk-cirrus-objects/resources/sas_risk_cirrus_objects_transform.yaml
   ```

4. Complete the deployment steps to apply the new settings.
   See [Deployment Tasks: Deploy SAS Risk Cirrus](https://go.documentation.sas.com/doc/en/cirruscdc/default/cirrusag/overview-pre-deployment-tasks.htm).

**Note:** This overlay can be applied during the initial deployment of the SAS Viya platform. or after the deployment of
the SAS Viya platform.

- If you are applying the overlay during the initial deployment of the SAS Viya platform,
  complete all the tasks in the README files that you want to use, and then
  run `kustomize build` to create and apply the manifests.
- If the overlay is applied after the initial deployment of the SAS Viya platform, run
  `kustomize build` to create and apply the manifests.

## Verify Overlay Default Settings

1. Run the following command to verify whether the overlay has been applied to
   the configuration map:

   ```sh
   kubectl -n <name-of-namespace> get configmap | grep sas-risk-cirrus-objects
   ```

   The command returns the ConfigMaps defined for sas-risk-cirrus-objects.
   Here is an example:

   ```sh
   sas-risk-cirrus-objects-parameters-<id>                  9      6d19h
   sas-risk-cirrus-objects-config-<id>                      9      6d19h
   ```

2. Execute the following:

   ```sh
   kubectl describe configmap sas-risk-cirrus-objects-config-<id> -n <name-of-namespace>
   ```

3. Verify that the output contains the settings that you configured.

   ```yaml
   Name:         sas-risk-cirrus-objects-config-g5dg72m87g
   Namespace:    d89282
   Labels:       sas.com/admin=cluster-local
     sas.com/deployment=sas-viya
   Annotations:  <none>
   
     Data
     ====
   JAVA_OPTION_CIRRUS_ENVIRONMENT_ID:
     ----
     -Dcirrus.environment.id=MY_DEV_123
   JAVA_OPTION_XMX:
     ----
     -Xmx512m
   JAVA_OPTION_XPREFETCH:
     ----
     -Dsas.event.consumer.prefetchCount=8
   SEARCH_ENABLED:
     ----
     true
   JAVA_OPTION_JAVA_LOCALE_USEOLDISOCODES:
     ----
     -Djava.locale.useOldISOCodes=true
   JAVA_OPTION_XSS:
     ----
     -Xss1048576
   
     BinaryData
     ====

   Events:  <none>
   ```

   Tip: Use filtering to focus on a specific setting:

   ```sh
   kubectl describe configmap sas-risk-cirrus-objects-config-<id> -n <name-of-namespace> | grep environment
   ```

   Result:

   ```yaml
   JAVA_OPTION_CIRRUS_ENVIRONMENT_ID:
     -Dcirrus.environment.id=MY_DEV_123
   ```