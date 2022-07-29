## Mirror images to private registry

if [[ -z "${LOCAL_REGISTRY_HOST}" ]]; then
  echo "LOCAL_REGISTRY_HOST must be defined"
  exit 0
fi
if [[ -z "${LOCAL_REGISTRY_PORT}" ]]; then
  echo "LOCAL_REGISTRY_PORT must be defined"
  exit 0
fi
if [[ -z "${LOCAL_REGISTRY_USER}" ]]; then
  echo "LOCAL_REGISTRY_USER must be defined"
  exit 0
fi
if [[ -z "${LOCAL_REGISTRY_PASS}" ]]; then
  echo "LOCAL_REGISTRY_PASS must be defined"
  exit 0
fi
if [[ -z "${ENTITLEMENT_KEY}" ]]; then
  echo "ENTITLEMENT_KEY must be defined"
  exit 0
else
    export SOURCE_REGISTRY_PASS=${ENTITLEMENT_KEY}
fi

export LOCAL_REGISTRY="${LOCAL_REGISTRY_HOST}:${LOCAL_REGISTRY_PORT}"

cloudctl case launch \
   --case ${CASE_ARCHIVE} \
   --inventory ${CASE_INVENTORY_SETUP} \
   --action configure-creds-airgap \
   --namespace ${NAMESPACE} \
   --args "--registry ${SOURCE_REGISTRY} --user ${SOURCE_REGISTRY_USER} --pass ${SOURCE_REGISTRY_PASS}"

cloudctl case launch \
   --case ${CASE_LOCAL_PATH} \
   --inventory ${CASE_INVENTORY_SETUP} \
   --action configure-creds-airgap \
   --namespace ${NAMESPACE} \
   --args "--registry ${LOCAL_REGISTRY} --user ${LOCAL_REGISTRY_USER} --pass ${LOCAL_REGISTRY_PASS}"

cloudctl case launch \
   --case ${CASE_LOCAL_PATH} \
   --inventory ${CASE_INVENTORY_SETUP} \
   --action mirror-images \
   --namespace ${NAMESPACE} \
   --args "--registry ${LOCAL_REGISTRY} --user ${LOCAL_REGISTRY_USER} --pass ${LOCAL_REGISTRY_PASS} --filter ibmcp4baProd,ibmcp4baBAWImages,ibmcp4baFNCMImages,ibmcp4baBANImages,ibmcp4baBASImages,ibmEdbStandard --inputDir  ${OFFLINEDIR}"