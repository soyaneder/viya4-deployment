---
category: SAS Data Quality
tocprty: 3
---

# Quality Knowledge Base for the SAS Viya Platform

## Overview

The `$deploy/sas-bases/examples/data-quality/storagesize` directory contains
resources for modifying the size of the persistent volume claim (PVC) used to
store the Quality Knowledge Base (QKB) in the SAS Viya platform.

## Installation

1. Copy the file `sas-bases/examples/data-quality/storagesize/configuration.env`
   to your `site-config/data-quality/storagesize` directory.

2. Update the configuration.env to replace {{ QKB-STORAGE-SIZE }} with the
   desired size for the QKB volume. The recommended size is 8Gi. Note that
   allocating less than this may your ability to add new QKBs to the SAS Viya
   platform. The minimum required is 1Gi.

3. Update the base kustomization.yaml file (`$deploy/kustomization.yaml`) to
   add the following entry to the `configMapGenerator` section:

   ```yaml

   configMapGenerator:
   ...
   - behavior: merge
   envs:
   - site-config/data-quality/storagesize/configuration.env
   name: sas-qkb-management-pvc-config
   ...

   ```

4. Also update the base kustomization.yaml file (`$deploy/kustomization.yaml`)
   to add the following entry to the `transformers` section:

   ```yaml

   transformers:
   ...
   - sas-bases/overlays/data-quality/storagesize/storage-size-transformer.yaml
   ...

   ```

## Additional Resources

For more information about using example files, see the
[SAS Viya Platform Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm)
