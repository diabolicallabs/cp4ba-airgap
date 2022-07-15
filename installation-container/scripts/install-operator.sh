## Install the CP4BA operator

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

cloudctl case launch \
   --case ${OFFLINEDIR}/${CASE_ARCHIVE} \
   --inventory ${CASE_INVENTORY_SETUP} \
   --action install-operator \
   --namespace ${NAMESPACE} \
   --args "--registry ${LOCAL_REGISTRY} --inputDir ${OFFLINEDIR}" 

sleep 60
oc get pod | grep ibm-cp4a-operator
oc get pod -n ibm-common-services