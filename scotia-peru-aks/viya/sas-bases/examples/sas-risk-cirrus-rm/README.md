---
category: SAS Risk Modeling
tocprty: 2
---

# Preparing and Configuring SAS Risk Modeling for Deployment

## Prerequisites

When SAS Risk Modeling is deployed, its content is integrated with the SAS Risk
Cirrus platform. The platform includes a common layer, Cirrus Core, that is used
by multiple solutions. Therefore, in order to deploy the SAS Risk Modeling
solution successfully, you must deploy the Cirrus Core content in addition to
the solution content. Preparing and configuring Cirrus Core for deployment is
described in the Cirrus Core README at
`$deploy/sas-bases/examples/sas-risk-cirrus-rcc/README.md` (Markdown
format) or
`$deploy/sas-bases/docs/preparing_and_configuring_cirrus_core_for_deployment.htm`
(HTML format).

The Risk Cirrus Core README also contains information about storage options, such as external databases, for your solution. You must complete the pre-deployment described in the Risk Cirrus Core README before deploying SAS Risk Modeling. Please read that document for important information about the deployment tasks that should be completed prior to deploying SAS Risk Modeling.

**IMPORTANT:** You must complete the step `Modify the Configuration for Risk Cirrus Core`. Because SAS Risk Modeling uses workflow service tasks, a user account must be configured for a workflow client. If you know which user account you want to use and want to configure it during installation, set the `SAS_RISK_CIRRUS_SET_WORKFLOW_SERVICE_ACCOUNT_FLG` variable to "Y" and specify the user account in the value of the `SAS_RISK_CIRRUS_WORKFLOW_DEFAULT_SERVICE_ACCOUNT` variable.

For more information about deploying Risk Cirrus Core, you can also read [Deployment Tasks](https://documentation.sas.com/?cdcId=cirruscdc&cdcVersion=default&docsetId=cirrusag&docsetTarget=n0epbo3xtwa3o2n1g13zjxezgmgn.htm) in the _SAS Risk Cirrus: Administrator's Guide_.

## Installation

1. If you have a `$deploy/site-config/sas-risk-cirrus-rm/resources` directory, delete it and its contents. Remove the reference to this directory from the transformers section of your base `kustomization.yaml` file (`$deploy/kustomization.yaml`). This step should only be necessary if you are upgrading from a cadence prior to 2025.02.

2. Copy the files in
    `$deploy/sas-bases/examples/sas-risk-cirrus-rm` to the
    `$deploy/site-config/sas-risk-cirrus-rm` directory. Create a destination directory if one does not exist.
    <br><br> **IMPORTANT:** If the destination directory already exists, confirm it contains the `.env` file, not the `rm_transform.yaml` file that was used for cadences prior to 2025.02. If the directory already exists, and it has the `.env` file, then [verify that the overlay connection settings](#verify-overlay-connection-settings-applied-successfully) have been applied correctly. No further actions are required unless you want to change the connection settings to different values.

3. Modify the `configuration.env` file (located in the `$deploy/site-config/sas-risk-cirrus-rm` directory). Lines with a `#` at the beginning are commented out; their values will not be applied during deployment. To override a default provided by SAS for a given variable, uncomment the line by removing the `#` at the beginning of the line and modify as explained in the following section. Specify, if needed, your settings as follows:

   <br>a. For `SAS_LOG_LEVEL_RISKCIRRUSDEPLOYER`, replace {{ INFO-OR-DEBUG }} with the logging level desired. (Default is INFO).  

   <br>b. For `SAS_RISK_CIRRUS_DEPLOYER_INCLUDE_SAMPLES`,default ='N'. Currently, SAS Risk Modeling does not include sample artifacts. Therefore this parameter defaults to 'N'. Do not modify this parameter in the YAML file. In the future, any items marked as sample artifacts will be listed here.

   <br>c. For `SAS_RISK_CIRRUS_DEPLOYER_SKIP_SPECIFIC_INSTALL_STEPS`, replace {{ COMMA-SEPARATED-STEPS-IDS-TO-SKIP }} with the IDs of the steps you want to skip. Currently, SAS Risk Modeling requires users to complete all the steps. Set this variable to an empty string.

   <br>d. For `SAS_RISK_CIRRUS_DEPLOYER_RUN_SPECIFIC_INSTALL_STEPS`, replace {{ COMMA-SEPARATED-STEPS-IDS-TO-RUN }} with the IDs of the steps you want to run. Typically, this is intended to be used after a deployment has completed successfully, and you need to re-run a specific step without redeploying the entire environment. For example, if you have deleted the prepackaged monitoring plans or KPIs from your environment, then you can set SAS_RISK_CIRRUS_DEPLOYER_RUN_SPECIFIC_INSTALL_STEPS to "load_objects" and then delete the sas-risk-cirrus-rm pod to force a redeployment. Doing so will **only** run the steps listed in SAS_RISK_CIRRUS_DEPLOYER_RUN_SPECIFIC_INSTALL_STEPS. **WARNING:** This list is absolute; the deployment will only run the steps included in this list. If you are deploying this environment for the first time, this variable should be an empty string, or you risk an incomplete or failed deployment.

   The following is an example of a `configuration.env` that you could use for SAS Risk Modeling. The uncommented parameters will be added to the solution configuration map.

   ```env
   SAS_LOG_LEVEL_RISKCIRRUSDEPLOYER=INFO
   SAS_RISK_CIRRUS_DEPLOYER_INCLUDE_SAMPLES=N
   # SAS_RISK_CIRRUS_DEPLOYER_SKIP_SPECIFIC_INSTALL_STEPS={{ COMMA-SEPARATED-STEPS-IDS-TO-SKIP }}
   # SAS_RISK_CIRRUS_DEPLOYER_RUN_SPECIFIC_INSTALL_STEPS={{ COMMA-SEPARATED-STEPS-IDS-TO-RUN }}
   ```

4. In the base kustomization.yaml file in the `$deploy` directory, add
    `site-config/sas-risk-cirrus-rm/configuration.env` to the `configMapGenerator` block. Here is an example: 
   
   ```yaml
    configMapGenerator:
      ...
      - name: sas-risk-cirrus-rm-parameters
        behavior: merge
        envs:
          - site-config/sas-risk-cirrus-rm/configuration.env
      ...
   ```

## Complete the Deployment Process

When you have finished configuring your deployment using the README files that are provided, complete the deployment steps to apply the new settings. The method by which the manifest is applied depends on what deployment method is being used. For more information, see [Deploy the Software](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm) in the _SAS Viya Platform: Deployment Guide_.

**Note:** The `.env` overlay can be applied during or after the initial deployment of the SAS Viya platform.

- If you are applying the overlay _during the initial deployment_ of the SAS Viya platform, complete all the tasks in the README files that you want to use, and then run
  `kustomize build` to create and apply the manifests.
- If the overlay is applied _after the initial deployment_ of the SAS Viya platform, run
  `kustomize build` to create and apply the manifests.

## Verify Overlay Connection Settings Applied Successfully

Before verifying the settings for SAS Risk Modeling solution, you should first verify Risk Cirrus Core's settings. Those instructions can be found in the Risk Cirrus Core README. To verify the settings for SAS Risk Modeling, do the following:
 
1. Run the following command to verify whether the overlay has been applied to the configuration map:

   ```sh
   kubectl describe configmap sas-risk-cirrus-rm-parameters -n <name-of-namespace>
   ```

2. Verify that the output contains the desired connection settings that you configured.

## Additional Resources

- For administration information for this solution, see
  [SAS Risk Modeling: Administrator's Guide](https://go.documentation.sas.com/doc/en/riskmdlcdc/default/riskmdlag/titlepage.htm).
- For more general deployment content, see
  [SAS Viya Platform: Deployment Guide](https://go.documentation.sas.com/doc/en/itopscdc/default/dplyml0phy0dkr/titlepage.htm).
