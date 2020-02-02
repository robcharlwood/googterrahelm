# Googterrahelm

This image is based on the python alpine image (``python:3.8.1-alpine3.11``) and installs the following libraries.

* Google Cloud SDK (``gcloud``)
* Kubernetes Control (``kubectl`` - installed as part of ``gcloud``)
* Google Storage Utils (``gsutil`` - installed as part of ``gcloud``)
* Terraform (``terraform``)
* Helm (``helm``)
* Ansible (``ansible``)

## Container Security
Image runs as non root user

## Image ARGs
* ``GOOGLE_SDK_VERSION`` - Defines the version of Google Cloud SDK to install.
* ``ANSIBLE_VERSION`` - Defines the version of ansible to install.
* ``TERRAFORM_VERSION`` - Defines the version of terraform to install.
* ``HELM_VERSION`` - Defines the version of helm to install.
* ``APP_USER`` - Defines the non root user to run the image as.
* ``WORKING_DIRECTORY`` - Defines the directory that the image works from (defaults to ``/home/${APP_USER}``).

## Author
* Rob Charlwood - Bitniftee Limited
