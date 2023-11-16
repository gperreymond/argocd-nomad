#!/bin/bash

asdf plugin add nomad https://github.com/asdf-community/asdf-hashicorp.git
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
asdf plugin add kind https://github.com/reegnz/asdf-kind.git

asdf install
