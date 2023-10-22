#!/bin/bash

asdf plugin-add nomad https://github.com/asdf-community/asdf-hashicorp.git
asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
asdf plugin-add kind https://github.com/reegnz/asdf-kind.git
asdf plugin-add kubebuilder https://github.com/virtualstaticvoid/asdf-kubebuilder.git
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git

asdf install
