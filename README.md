# 1. Description
- This repository contains source code for my VTI DevOps course.
# 2. Project
## 2.1 Overview
```mermaid
---
title: CI/CD Workflow
---
flowchart TB
    subgraph github-action[Github Action]
      commit-code[Commit Code] -->
      build-push-docker-image[Build/Push Docker Image] -->
      make-changes-in-k8s[Make changes in k8s] -->
      push-new-k8s-change-to-git[Push new k8s changes to git]
    end

    subgraph git-repo[Git Repository]
    end

    subgraph argocd[Argocd]
      detect-new-changes-in-k8s[Detect new changes in k8s ] -->
      apply-k8s-changes[Apply k8s changes]
    end

    push-new-k8s-change-to-git --> git-repo
    detect-new-changes-in-k8s --> git-repo
```

## 2.2 Task
 - Jenkins Runner configuration
 - (Optional) Host the Jenkins with Docker server on AWS EC2 by using Terraform.
 - WebHook configuration
 - Dockerizing python application
 - k8s Manifest file creation
 - Connect Kubetnetes node to ArgoCD
 - Connect private Github Repo to ArgoCD for CD part
 - Trigger CD Jenkins Job using Curl command and Pass variable from CI pipelines




