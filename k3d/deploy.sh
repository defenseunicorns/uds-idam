#!/bin/bash
k3d cluster delete -c k3d.yaml
k3d cluster create -c k3d.yaml

zarf package create --architecture amd64 --confirm
zarf init --components=git-server --confirm
zarf package deploy --confirm zarf-package-uds-idam-k3d-amd64-0.1.tar.zst