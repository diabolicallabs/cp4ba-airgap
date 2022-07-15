docker run --privileged \
 -v ~/.kube/config:/cp4ba/kube/config \
 -e KUBECONFIG=/cp4ba/kube/config \
 -e NAMESPACE=openshift-operators \
 -e LOCAL_REGISTRY_HOST=registry.host \
 -e LOCAL_REGISTRY_PORT=443 \
 -e LOCAL_REGISTRY_USER=local_user \
 -e LOCAL_REGISTRY_PASS=local_password \
 ibmce/cp4ba:1.0 /bin/bash catalog-setup.sh