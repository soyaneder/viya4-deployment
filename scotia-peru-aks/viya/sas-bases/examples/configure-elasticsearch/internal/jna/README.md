---
category: OpenSearch
tocprty: 100
---

# Configure a Temporary Directory for JNA in OpenSearch

By default, OpenSearch creates its temporary directory within /tmp using an emptyDir volume mount. However, some hardened installations mount /tmp on emptyDir volumes with the `noexec` option, preventing JNA and libffi from functioning correctly. This can cause startup failures with exceptions like `java.lang.UnsatisfiedLinkerError` or messages indicating issues with mapping segments or allocating closures.

In order to allow JNA loading without relaxing filesystem restrictions, OpenSearch can be configured to use a memory-backed temporary directory.

## Configure Temporary Directory for JNA

To configure OpenSearch to use a memory-backed temporary directory:

1. Copy the JNA Temporary Directory transformer from `$deploy/sas-bases/examples/configure-elasticsearch/internal/jna/jna-tmp-dir-transformer.yaml` into the `$deploy/site-config` directory.

2. Add the jna-tmp-dir-transformer.yaml file to the transformers block of the base kustomization.yaml file (`$deploy/kustomization.yaml`). Here is an example:
   
   ```yaml
   transformers:
   ...
   - site-config/jna-tmp-dir-transformer.yaml
   ```

## Additional Resources

For more information, see
[SAS Viya Platform: Deployment Guide](http://documentation.sas.com/?cdcId=itopscdc&cdcVersion=default&docsetId=dplyml0phy0dkr&docsetTarget=titlepage.htm&locale=en).