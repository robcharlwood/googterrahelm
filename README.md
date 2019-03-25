# Googterrahelm

This image is based on the python alpine image (``python:2.7.16-alpine3.9``) and installs the following libraries.
We are unfortunately locked in to Python 2.7 for the time being as Google Cloud SDK does not support Python 3 yet.

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
