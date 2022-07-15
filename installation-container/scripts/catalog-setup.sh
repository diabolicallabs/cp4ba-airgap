## Install the CP4BA catalog

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

export LOCAL_REGISTRY="${LOCAL_REGISTRY_HOST}:${LOCAL_REGISTRY_PORT}"

cloudctl case launch \
   --case ${OFFLINEDIR}/${CASE_ARCHIVE} \
   --inventory ${CASE_INVENTORY_SETUP} \
   --action install-catalog \
   --namespace ${NAMESPACE} \
   --args "--registry ${LOCAL_REGISTRY} --inputDir ${OFFLINEDIR} --recursive" 

sleep 30
oc get catalogsource -n openshift-marketplace
oc get pods -n openshift-marketplace
