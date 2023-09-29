# 1. Description
- This repository contains source code for my VTI DevOps course.
# 2. Project
## 2.1 Overview
---
title: CI/CD Workflow
---
flowchart TB
    subgraph github-action[Github Action]
      commit-code[Commit Code] -->
      build-push-docker-image[Build/Push Docker Image] -->
      make-changes-in-k8s-folder[Make changes in k8s folder] -->
      push-new-k8s-change-to-git[Push new k8s changes to git]
    end

    subgraph git-repo[Git Repository]
    end

    subgraph argocd[Argocd]
      detect-new-changes-in-k8s-folder[Detect new changes in k8s folder] -->
      apply-k8s-changes[Apply k8s changes]
    end

    push-new-k8s-change-to-git --> git-repo
    detect-new-changes-in-k8s-folder --> git-repo

## 2.2 Task
-Setup a CI/CD pipeline by using Jenkins.
-(Optional) Host the Jenkins with Docker server on AWS EC2.
-Provision a K8s cluster on AWS EKS Service
