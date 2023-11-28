#!/bin/bash

asdf plugin add nomad https://github.com/asdf-community/asdf-hashicorp.git
asdf plugin add consul https://github.com/asdf-community/asdf-hashicorp.git
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
asdf plugin add k3d https://github.com/spencergilbert/asdf-k3d.git
asdf plugin add python
asdf plugin add jq

asdf install
