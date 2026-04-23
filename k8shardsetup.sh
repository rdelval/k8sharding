# Load parameter defaults
PARAMS_FILE="./params.sh"

if [[ -f "${PARAMS_FILE}" ]]; then
  source "${PARAMS_FILE}"
else
  echo "Parameter file not found: ${PARAMS_FILE}" >&2
  exit 1
fi

# apply cert manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.2/cert-manager.yaml

# Apply role bindings
kubectl apply -f rbac/cluster-role-binding.yaml
kubectl apply -f rbac/node-rbac.yaml

# Apply Oracle DB Operator and validate
kubectl apply -f oracle-database-operator.yaml
kubectl get pods -n oracle-database-operator-system

#### Create the namespace
kubectl create ns "$NAMESPACE"
kubectl get ns

## Create the Secrets

# Create a directory for files for the secret:
rm -rf "${RSADIR}/"
mkdir -p "${RSADIR}/"

# Generate the RSA Key
openssl genrsa -out "${RSADIR}"/key.pem
openssl rsa -in "${RSADIR}"/key.pem -out "${RSADIR}"/key.pub -pubout

# Create a text file with the password
rm -f $PWDFILE_ENC
echo $MYPWD > ${RSADIR}/pwdfile.txt

# Create encrypted file from the text file using the RSA key
openssl pkeyutl -in $PWDFILE -out $PWDFILE_ENC -pubin -inkey $PUBKEY -encrypt

# Remove the initial text file:
rm -f $PWDFILE

# Deleting the existing secret if existing
kubectl delete secret $SECRET_NAME -n  $NAMESPACE

# Create the Kubernetes secret in namespace "NAMESPACE"
kubectl create secret generic $SECRET_NAME --from-file=$PWDFILE_ENC --from-file=${PRIVKEY} -n $NAMESPACE

# get login for container download
kubectl create secret docker-registry ocr-reg-cred \
  --docker-server=container-registry.oracle.com \
  --docker-username="$DOCK_USER" \
  --docker-password="$DOCK_PWD" \
  --docker-email="$DOCK_EMAIL" \
  -n "$NAMESPACE"
