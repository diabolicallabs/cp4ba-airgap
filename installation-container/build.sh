curl -o ./assets/index.yaml -LJO https://github.com/IBM/cloud-pak/raw/master/repo/case/ibm-cp-automation/index.yaml
CASE_VERSION=$(grep -o -E '[ \t]+\d\.\d\.\d:$' ./assets/index.yaml | grep -o '\d\.\d\.\d' | tail -1)
curl -o ./assets/ibm-cp-automation-${CASE_VERSION}.tgz -LJO https://github.com/IBM/cloud-pak/raw/master/repo/case/ibm-cp-automation/${CASE_VERSION}/ibm-cp-automation-${CASE_VERSION}.tgz
ENTITLEMENT_KEY=`cat ./assets/entitlement_key.text`
echo $CASE_VERSION
docker build --build-arg CASE_VERSION_ARG=$CASE_VERSION --build-arg ENTITLEMENT_KEY_ARG=$ENTITLEMENT_KEY  -t ibmce/cp4ba:1.0 .