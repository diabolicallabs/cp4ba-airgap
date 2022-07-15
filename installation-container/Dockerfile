FROM quay.io/podman/stable

ARG CASE_VERSION_ARG
ENV CASE_VERSION=$CASE_VERSION_ARG

ARG ENTITLEMENT_KEY_ARG
ENV ENTITLEMENT_KEY=$ENTITLEMENT_KEY_ARG

RUN dnf makecache --refresh
RUN dnf -y install httpd-tools
RUN dnf -y install skopeo
RUN dnf install hostname -y
RUN dnf install findutils -y
# RUN dnf install ansible -y
RUN dnf install which -y

## Install IBM cloudctl utility
ADD https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz /tmp/
RUN tar xzf /tmp/cloudctl-linux-amd64.tar.gz --directory /usr/local/bin
RUN mv /usr/local/bin/cloudctl-linux-amd64 /usr/local/bin/cloudctl
RUN chmod 755 /usr/local/bin/cloudctl
RUN rm /tmp/cloudctl-linux-amd64.tar.gz
RUN mkdir /.cloudctl

## Install OpenShift and Kubernetes command line utilities
ADD https://github.com/openshift/okd/releases/download/4.8.0-0.okd-2021-11-14-052418/openshift-client-linux-4.8.0-0.okd-2021-11-14-052418.tar.gz /tmp/
RUN tar xzf /tmp/openshift-client-linux-4.8.0-0.okd-2021-11-14-052418.tar.gz --directory /usr/local/bin
RUN rm /usr/local/bin/README.md
RUN rm /tmp/openshift-client-linux-4.8.0-0.okd-2021-11-14-052418.tar.gz

## OPM
ADD https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest-4.8/opm-linux.tar.gz /tmp/
RUN tar xzf /tmp/opm-linux.tar.gz --directory /usr/local/bin
RUN rm /tmp/opm-linux.tar.gz

WORKDIR /cp4ba
ENV OFFLINEDIR /cp4ba/offline
ENV NAMESPACE=openshift-operators
ENV CASE_ARCHIVE ibm-cp-automation-${CASE_VERSION}.tgz
ENV CASE_NAME=ibm-cp-automation
ENV CASE_INVENTORY_SETUP=cp4aOperatorSetup
ENV CASE_ARCHIVE=${CASE_NAME}-${CASE_VERSION}.tgz
ENV CASE_LOCAL_PATH=${OFFLINEDIR}/${CASE_ARCHIVE}
ENV USE_SKOPEO=true
ENV SOURCE_REGISTRY=cp.icr.io
ENV SOURCE_REGISTRY_USER=cp

COPY assets/ibm-cp-automation-${CASE_VERSION}.tgz /cp4ba/
RUN cloudctl case save --case /cp4ba/${CASE_ARCHIVE} --version ${CASE_VERSION} --outputdir ${OFFLINEDIR}

RUN for f in ${OFFLINEDIR}/*images.csv; do gawk -i inplace '!/,s390x,/' "$f" && gawk -i inplace '!/,ppc64le,/' "$f"; done

COPY scripts/registry-setup.sh /cp4ba/
COPY scripts/mirror-images.sh /cp4ba/
COPY scripts/catalog-setup.sh /cp4ba/
COPY scripts/install-operator.sh /cp4ba/

RUN chmod a+x *.sh