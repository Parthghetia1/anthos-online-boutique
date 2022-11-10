apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
bases:
- ../../base
patches:
# ServiceAccount - make name unique per environ 
- target:
    kind: Deployment
    name: frontend
  patch: |-
    - op: replace
      path: /spec/template/spec/containers/0/image
      value: gcr.io/GOOGLE_CLOUD_PROJECT/frontend@COMMIT_SHA
commonLabels:
  environment: dev
# [END anthosconfig_multi_environments_kustomize_config_source_overlays_dev_kustomization] 
