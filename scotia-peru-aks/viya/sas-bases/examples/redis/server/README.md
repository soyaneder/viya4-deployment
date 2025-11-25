---
category: redis
tocprty: 1
---

# Configuration Settings for Redis

## Overview

Redis is used as a distributed cache for SAS Viya platform services. This README
file describes the settings available for deploying Redis.

## Installation

The configuration files are located at `$deploy/sas-bases/examples/redis/server`.
The following sections describe the configuration files and how to use them in
your SAS Viya platform deployment.

### Change Memory Resources

The `redis-modify-memory.yaml` transformer file allows you to change the memory
resources for Redis nodes. The default required value is 90Mi, and the default
limit is 500Mi. The Redis 'maxmemory' setting is set to 90% of the container
memory limit.

1. Copy the `$deploy/sas-bases/examples/redis/server/redis-modify-memory.yaml` file to `site-config/redis/server/redis-modify-memory.yaml`.

2. The variables in the copied file are set
off by curly braces and spaces, such as {{ MEMORY-LIMIT }}. Replace
each variable string, including the braces, with the values you want to use.
If you want to use the default for a variable, make no changes to that variable.

3. After you have edited the file, add a reference to it in the transformers block
of the base kustomization.yaml file (`$deploy/kustomization.yaml`). Here is an
example:

   ```yaml
   transformers:
   ...
   - site-config/redis/server/redis-modify-memory.yaml
   ```

### Modify PersistentVolumeClaim or StorageClass

The redis-modify-pvc.yaml transformer file allows you to modify the
PersistentVolumeClaim (PVC) size or the StorageClass for nodes.

**Note:** For existing deployments, you must delete the Redis StatefulSet and PVCs
before applying the PVC size change. This will result in the loss of data cached
by services. Begin at step 4 if you are not updating an existing deployment.

1. Delete the Redis StatefulSet.

   ```bash
   kubectl -n <name-of-namespace> delete statefulset sas-redis-server
   ```

2. Wait for all of the pods to terminate before deleting the PVCs. You can check the
status of the Redis pods with the following command:

   ```bash
   kubectl -n <name-of-namespace> get pods -l app.kubernetes.io/name=sas-redis-server
   ```

3. When no pods are listed as output for the command in step 2, delete the PVCs:

   ```bash
   kubectl -n <name-of-namespace> delete pvc -l app.kubernetes.io/name=sas-redis-server
   ```

4. Copy the `$deploy/sas-bases/examples/redis/server/redis-modify-pvc.yaml` file to `site-config/redis/server/redis-modify-pvc.yaml`.

5. The variables in the copied file are set
off by curly braces and spaces, such as {{ PVC_SIZE }} and {{ STORAGE_CLASS }}.
Replace each variable string, including the braces, with the values you want to use.
If you want to use the default for a variable, make no changes to that variable.

6. After you have edited the file, add a reference to it in the transformers block
of the base kustomization.yaml file (`$deploy/kustomization.yaml`). Here is an
example:

   ```yaml
   transformers:
   ...
   - site-config/redis/server/redis-modify-pvc.yaml
   ```