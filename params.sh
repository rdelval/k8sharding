#!/bin/bash

# Default parameter values for shscript.sh

# Directory setup for kubernetes secrets
RSADIR="/tmp/.secrets"

# Key file paths
PRIVKEY="${RSADIR}/key.pem"
PUBKEY="${RSADIR}/key.pub"

# Namespace and secret configuration
NAMESPACE="shns"
SECRET_NAME="db-user-pass-rsa"

# Password files
PWDFILE="${RSADIR}/pwdfile.txt"
PWDFILE_ENC="${RSADIR}/pwdfile.enc"

# Sample credentials for docker registry secret (replace with real values)
MYPWD="SamplePassword123!"
DOCK_USER="sample.user@example.com"
DOCK_PWD="SampleDockPassword123!"
DOCK_EMAIL="sample.user@example.com"

export RSADIR PRIVKEY PUBKEY NAMESPACE SECRET_NAME PWDFILE PWDFILE_ENC MYPWD DOCK_USER DOCK_PWD DOCK_EMAIL
