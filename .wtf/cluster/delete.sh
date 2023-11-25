#!/bin/bash

k3d cluster delete dev-local
docker network rm k3d-dev-local