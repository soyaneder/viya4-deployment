---
category: SAS Model Repository Service
tocprty: 10
---

# Configure SAS Viya Platform for Large Analytic Store Models

## Overview

The SAS Model Repository service provides support for registering, organizing,
and managing models within a common model repository. When working with large
analytic store models, additional resource configurations are necessary to
ensure that users can successfully import and process the models.

This README describes how to configure your SAS Viya platform environment to handle
large analytic store models by increasing CPU and memory resources for key services.

## Prerequisites

Before using the resource transformer YAML file, you must perform the following tasks:

1. Verify that you have access to your SAS Viya platform deployment's Kubernetes
   configuration.

2. Ensure you have permissions to modify the deployment's Kustomize
   configuration.

3. Verify that your Kubernetes cluster has sufficient resources to accommodate
   the increased resource allocations for these services.

## Resource Configurations

The transformer applies the following resource configurations:

- **sas-files**:
  - CPU: 2 cores
  - Memory: 4Gi

- **sas-launcher**:
  - CPU: 4 cores
  - Memory: 8Gi

- **sas-model-repository**:
  - CPU: 2 cores
  - Memory: 4Gi

- **sas-catalog-services**:
  - CPU: 2 cores
  - Memory: 4Gi

## Installation

1. Add `sas-bases/overlays/sas-model-repository/astores/astore-large-model-resource-transformer.yaml`
   to the transformers block in the base kustomization.yaml file in the
   `$deploy` directory.

   ```yaml
   transformers:
     - sas-bases/overlays/sas-model-repository/astores/astore-large-model-resource-transformer.yaml
   ```

2. Complete the deployment steps to apply the new settings. See
   [Deploy the Software](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=p127f6y30iimr6n17x2xe9vlt54q.htm)
   in _SAS Viya Platform: Deployment Guide_.

   **Note:** This overlay can be applied during the initial deployment of the
   SAS Viya platform or after the deployment of the SAS Viya platform.

   - If you are applying the overlay during the initial deployment of the SAS
     Viya platform, complete all the tasks in the README files that you want to
     use, then run `kustomize build` to create and apply the manifests.
   - If the overlay is applied after the initial deployment of the SAS Viya
     platform, run `kustomize build` to create and apply the manifests.

## Verification

After applying the changes, you can verify that the new resource settings have
been applied by comparing them to the expected values described at [Resource Configurations](#resource-configurations).

```bash
kubectl get deployment sas-files -o jsonpath='{.spec.template.spec.containers[0].resources}'
kubectl get deployment sas-launcher -o jsonpath='{.spec.template.spec.containers[0].resources}'
kubectl get deployment sas-model-repository -o jsonpath='{.spec.template.spec.containers[0].resources}'
kubectl get deployment sas-catalog-services -o jsonpath='{.spec.template.spec.containers[0].resources}'
```

If the values match, the overlay has been successfully applied.
If not, review the installation steps and try again.

## Additional Resources

- [SAS Viya Platform Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm)
- [SAS Viya Platform: Models Administration](https://documentation.sas.com/?cdcId=sasadmincdc&cdcVersion=default&docsetId=calmodels&docsetTarget=titlepage.htm)
- [SAS Model Manager: Administrator's Guide](http://documentation.sas.com/?cdcId=mdlmgrcdc&cdcVersion=default&docsetId=mdlmgrag)
- [Kubernetes Kustomize documentation](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)
