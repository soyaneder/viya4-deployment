---
category: SAS Risk Cirrus Core
tocprty: 2
---

# Preparing and Configuring Risk Cirrus Core for Deployment

## Overview of the Pre-Deployment Process

Before you can deploy a SAS Risk Cirrus solution, it is important to understand that your solution
content is integrated with the SAS Risk Cirrus platform. The platform includes a common layer (Risk
Cirrus Core) that is used by all SAS Risk Cirrus solutions. Therefore, in order to fully deploy your
solution, you must deploy, at minimum, the Risk Cirrus Core content in addition to your solution.

In order to deploy Risk Cirrus Core, you must first complete the following pre-deployment tasks:

1. [Review the Risk Cirrus Objects README file.](#review-the-risk-cirrus-objects-readme-file)

2. (For deployments that use external PostgreSQL databases)
   [Deploy and stage an external PostgreSQL database](#deploy-and-stage-an-external-database).

3. [Deploy an additional PostgreSQL cluster](#deploy-an-additional-postgresql-cluster-for-the-sas-common-data-store)
   for the SAS Common Data Store.

4. [Specify a Persistent Volume Claim for Risk Cirrus Core](#specify-a-persistent-volume-claim-for-risk-cirrus-core)
   by updating the SAS Viya platform customization file (kustomization.yaml).

5. [Modify the Configuration for Risk Cirrus Core](#modify-the-configuration-for-risk-cirrus-core).

6. [Review any solution README files for additional deployment-related tasks](#review-solution-readme-files-for-additional-tasks).

7. [Complete the deployment process](#complete-the-deployment-process).

8. [Verify your access control settings](#verify-your-access-control-settings).

9. [Verify that the configuration overrides have been applied successfully](#verify-that-the-configuration-overrides-have-been-applied-successfully).

## Review the Risk Cirrus Objects README File

If you plan to have multiple environments, follow the steps described in Risk Cirrus Objects README file located at `$deploy/sas-bases/examples/sas-risk-cirrus-objects/resources/README.md` (for Markdown-formatted instructions) and `$deploy/sas-bases/docs/configure_environment_id_settings_for_sas_risk_cirrus_builder_microservice.htm` (for HTML-formatted instructions). These instructions will help you to make changes to the sas_risk_cirrus_objects_transform.yaml and configure an environment ID for the target environment. The environment ID is used in the deployment process to set a new default Source System Code in the format <solution_shortname>_<environment_ID>. This configuration prevents object conflicts during promotion between environments and enables users to identify the environment in which a given object was created.

When selecting the value of the environment ID:

- Only ASCII characters are supported.
- The value must not exceed 10 characters.
- Common examples include: PROD, PRE_PROD, DEV, TEST or UAT.

You must set a unique environment ID for each environment. Do not use the same environment ID for multiple environments. Once the environment ID is set for a target environment, it's not recommended to change it.

## Deploy and Stage an External Database

**IMPORTANT:** This task is required only if you are deploying an external PostgreSQL database
instance for a solution that supports its use.

If your solution supports the use of an external PostgreSQL database instance, ensure that you have completed the following pre-deployment
tasks:

- deploy an external database that meets the SAS Viya platform requirements. For detailed
  information see [External PostgreSQL Requirements](https://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=itopssr&docsetTarget=p05lfgkwib3zxbn1t6nyihexp12n.htm#p1wq8ouke3c6ixn1la636df9oa1u).
- configure the LTREE extension for use by the database. A quick validation can be performed running
  the following SQL query: `select * from pg_available_extensions;`
- set the database locale to C/POSIX (for example, by specifying the `--locale=C` parameter). You
  can validate the database locale running the following command in your Linux terminal: `psql -l` ,
  or running the following SQL query: `select * from pg_database;` OR `show LC_COLLATE;`

The process for configuring the LTREE extension and setting the database locale varies depending on
the cloud provider and operating system.

For specific instructions on performing these tasks, consult your cloud provider documentation.

## Deploy an Additional PostgreSQL Cluster for the SAS Common Data Store

The Risk Data Service requires the deployment of an additional PostgreSQL cluster called SAS Common
Data Store (also called CDS PostgreSQL). This cluster is configured separately from the required
platform PostgreSQL cluster that supports the SAS Infrastructure Data Server.

**Note:** Your SAS Common Data Store must match the state (external or internal) of the SAS
Infrastructure Data Server. So if the SAS Infrastructure Data Server is on an external PostgreSQL
instance, an external PostgreSQL instance must also be used for the SAS Common Data Store cluster
(and vice versa).

For more information about configuring the SAS Common Data Store cluster, see the README file
located at `$deploy/sas-bases/examples/postgres/README.md` (for Markdown-formatted instructions) or `$deploy/sas-bases/docs/configure_postgresql.htm` (for HTML-formatted instructions).

## Specify a Persistent Volume Claim for Risk Cirrus Core

The best option for storing any code that is needed for SAS programming run-time environment
sessions is a Network File Sharing (NFS) server that all programming run-time Kubernetes pods can
access. In order for SAS Risk Cirrus solutions to operate properly, you must specify a Persistent
Volume Claim (PVC) for Risk Cirrus Core in the SAS Viya platform. This is done by adding
`sas-risk-cirrus-core` to the comma-separated set of PVCs in the `annotationSelector` section of
configuration code in your top-level kustomization.yaml file.

The following is a sample excerpt from that file with `sas-risk-cirrus-core` added to the
comma-separated list of PVCs.

```yaml
patches:
- path: site-config/storageclass.yaml
  target:
    kind: PersistentVolumeClaim
    annotationSelector: sas.com/component-name in (sas-backup-job,sas-data-quality-services,
    sas-commonfiles,sas-cas-operator,sas-pyconfig,sas-risk-cirrus-core)
```

For additional information about this process, see
[Specify PersistentVolumeClaims to Use ReadWriteMany StorageClass](https://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=n08u2yg8tdkb4jn18u8zsi6yfv3d.htm#p0la9vh2963b2kn17f03ylvpiluu).

## Modify the Configuration for Risk Cirrus Core

### Overview of Configuration Parameters for Risk Cirrus Core

Risk Cirrus Core provides a ConfigMap whose values control various aspects of its deployment process.  This
includes variables such as logging level for the deployment, deployment steps to skip, etc.  SAS provides
default values for these variables as described in the next section.  You can override these default values
by configuring a `configuration.env` file with your override values and configuring your `kustomization.yaml`
file to apply these overrides.

For a list of variables that can be overridden and their default values, see
[Risk Cirrus Core Configuration Parameters](#risk-cirrus-core-configuration-parameters).

For the steps needed to override the default values with your own values, see
[Apply your own overrides to the configuration parameters](#apply-overrides-to-the-configuration-parameters).

### Risk Cirrus Core Configuration Parameters

The following table contains a list of parameters that can be specified in the Risk Cirrus Core `.env`
configuration file.  These parameters can all be found in the template configuration file (`configuration.env`)
but are commented out in the template file.  Lines with a '#' at the beginning are commented out, and their values
will not be applied during deployment.  If you want to override a SAS-provided default for a given variable, you
must uncomment the line by removing the '#' at the beginning of the line.

| Parameter Name                                   | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SAS_LOG_LEVEL_RISKCIRRUSDEPLOYER                 | Specifies a logging level for the deployment. The logging level value: `"INFO"` is used if the variable is not overridden by your `.env` file. For a more verbose level of logging, specify value: `"DEBUG"`.                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| SAS_RISK_CIRRUS_DEPLOYER_SKIP_SPECIFIC_INSTALL_STEPS                 | Specifies whether you want to skip specific steps during the deployment of SAS Risk Cirrus Core. <br>**Note:** Typically, you should set this value blank: `""`.  The value: `""` is used if the variable is not overridden by your `.env` file.  This means no deployment steps will be explicitly skipped.                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| SAS_RISK_CIRRUS_DEPLOYER_RUN_SPECIFIC_INSTALL_STEPS                 | Specifies whether you want to run specific steps during the deployment of SAS Risk Cirrus Core. <br>**Note:** Typically, you should set this value blank: `""`.  The value: `""` is used if the variable is not overridden by your `.env` file.  This means all deployment steps will be executed.                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| SAS_RISK_CIRRUS_SET_WORKFLOW_SERVICE_ACCOUNT_FLG | Specifies whether the value of the SAS_RISK_CIRRUS_WORKFLOW_DEFAULT_SERVICE_ACCOUNT variable is used to set SAS Workflow Manager default service account. If the value is `"N"`, the deployment process does not set the workflow default service account.  The value: `"N"` is used if the variable is not overridden by your `.env` file.  This means the deployment will not set a default service account for SAS Workflow Manager.   You can still set a default service account after deployment via SAS Environment Manager.                                                                                                                                                                                                                                                                                                                                                                                                                  |
| SAS_RISK_CIRRUS_WORKFLOW_DEFAULT_SERVICE_ACCOUNT | The user account to be configured in the SAS Workflow Manager in order to use workflow service tasks (if SAS_RISK_CIRRUS_SET_WORKFLOW_SERVICE_ACCOUNT_FLG is set to `"Y"`). Using the SAS administrator user account for this purpose is not advised because it might allow file access rights that are not secure enough for the workflow client account. <br>**IMPORTANT:** Make sure to review the information about configuring the workflow client default service account in the section ["Configuring the Workflow Client"](https://documentation.sas.com/?cdcId=wfscdc&cdcVersion=default&docsetId=wfsag&docsetTarget=p1j1q517695r6cn17osi5y1xa6vq.htm) in the SAS Workflow Manager: Administrator's Guide. It contains important information to secure a successful deployment. The value: `""` is used if the variable is not overridden by your `.env` file.|

### Apply Overrides to the Configuration Parameters

If you want to override any of the Risk Cirrus Core configuration parameters rather than using
the default values, complete these steps:

1. If you have a `$deploy/site-config/sas-risk-cirrus-core` directory, delete it and its contents.
   Then, edit your base `kustomization.yaml` file (`$deploy/kustomization.yaml`) to remove the
   following line from the `transformers` section:

   ```  - site-config/sas-risk-cirrus-core/resources/core_transform.yaml```

   This step should only be necessary if you are upgrading from a cadence prior to 2025.02.

2. Copy the `configuration.env` from `$deploy/sas-bases/examples/sas-risk-cirrus-rcc` to the
   `$deploy/site-config/sas-risk-cirrus-rcc` directory. Create the destination directory if
   one does not exist. If the directory already exists and already has the expected `.env` file,
   [verify that the overrides](#verify-that-configuration-overrides-have-been-applied-successfully)
   have been correctly applied. No further actions are required, unless you want to apply different
   overrides.

3. In the base kustomization.yaml file, add the `sas-risk-cirrus-core-parameters` ConfigMap to the
   `configMapGenerator` block.  If that block does not exist, create it. Here is an example of what
   the inserted code block should look like in the kustomization.yaml file:

   ```yaml
   configMapGenerator:
   ...
   - name: sas-risk-cirrus-core-parameters
     behavior: merge
     envs:
       - site-config/sas-risk-cirrus-rcc/configuration.env
   ...
   ```

4. Save the kustomization.yaml file.

5. Modify the configuration.env file in the `$deploy/site-config/sas-risk-cirrus-rcc` directory. If
   there are any parameters for which you want to override the default value, uncomment that variable's
   line in your `configuration.env` file and replace the placeholder with the desired value.

   The following is an example of a `configuration.env` file that you could use for Risk Cirrus Core.
   This example will use all of the default values provided by SAS except for the two workflow-related
   variables. In this case, it will set a default service account in SAS Workflow to the user
   `workflowacct` during deployment.

   ```env
   # SAS_LOG_LEVEL_RISKCIRRUSDEPLOYER={{ INFO-or-DEBUG }}
   # SAS_RISK_CIRRUS_DEPLOYER_SKIP_SPECIFIC_INSTALL_STEPS={{ COMMA-SEPARATED-STEPS-IDS-TO-SKIP }}
   # SAS_RISK_CIRRUS_DEPLOYER_RUN_SPECIFIC_INSTALL_STEPS={{ COMMA-SEPARATED-STEPS-IDS-TO-RUN }}
   SAS_RISK_CIRRUS_SET_WORKFLOW_SERVICE_ACCOUNT_FLG=Y
   SAS_RISK_CIRRUS_WORKFLOW_DEFAULT_SERVICE_ACCOUNT=workflowacct
   ```

   For a list of variables that can be overridden and their default values, see [Risk Cirrus Core Configuration Parameters](#risk-cirrus-core-configuration-parameters).

6. Save the `configuration.env` file.


## Review Solution README Files for Additional Tasks

After you have completed your pre-deployment configurations for Risk Cirrus Core, ensure that you
review the solution README files for any Cirrus applications that you are deploying. These files
contain additional pre-deployment instructions that you must follow to make changes to the
kustomization.yaml file as well as to solution-specific configuration files, as part of the
overall SAS Viya platform deployment. You can also refer to the solution-specific administrative
documentation for further details as needed.

## Complete the Deployment Process

When you have finished configuring your deployment using the README files that are provided,
complete the deployment steps to apply the new settings. The method by which the manifest is applied
depends on what deployment method is being used. For more information, see
[Deploy the Software](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm).

## Verify Your Access Control Settings

When deploying Risk Cirrus Core, you can determine whether to enable Linux Access Control Lists
(ACL) to set permissions on Analysis Run directories. By default, when Risk Cirrus Core is deployed,
the 'requireACL' flag in SAS Environment Manager is set to OFF. If you are upgrading from an
existing deployment and had previously set 'requireACL=ON', that setting will remain. When
'requireACL=ON', users might encounter issues when executing an analysis run, depending upon the
setup of their analysis run folders and security permissions. If you do not require ACL security,
turn it off to avoid these issues.

To turn ACL security off, perform the following steps:

1. Log into SAS Environment Manager.

2. Click on the Configuration menu item.

3. In the search bar, enter "risk cirrus".

4. Select the Risk Cirrus Core service.

5. In the Configuration pane on the right, update the requireACL field to OFF.

6. Save your changes.

Using 'requireACL=ON' enables restricted sharing mode. This mode guarantees that only the user/owner
(including group) running the analysis run has write permissions to the analysis run directory in
the PVC. Using 'requireACL=OFF' enables unrestricted sharing mode. This mode allows any user/owner
(including group and others) running the analysis run to have write permissions to the analysis run
directory in the PVC. For more information about configuration settings in SAS Environment Manager,
see
[Configuration Page](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=evfun&docsetTarget=p19rd04uy9qnlkn10vwoajl66nxq.htm)

## Verify That the Configuration Overrides Have Been Applied Successfully

**Note:** If you configured overrides during a past deployment, your overrides should be available
in the SAS Risk Cirrus Core ConfigMap.  To verify that your overrides were applied successfully
to the ConfigMap, run the following command:

```sh
kubectl describe configmap sas-risk-cirrus-core-parameters -n <name-of-namespace>
```

Verify that the output contains your configured overrides.
