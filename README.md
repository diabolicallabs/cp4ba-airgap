# Cloud Pak for Business Automation

## Installation of Production Profile
A Docker container is used to facilitate the installation of the Cloud Pak. This will ensure that the proper software and utilites will be available for the installation.

### Build Docker Image
There is a shell script in the scripts directory called build.sh. This script will build the Docker image that will be used for the installation. Make sure the IBM entitlement key is located in assets/entitlement_key.text then run build.sh This should result in a image called ibmce/cp4ba:1.0.

### Run Installation Scripts

Edit the following scripts and set the parameters for the local registry. Also, set <some_dir> to the location of the OpenShift config file. Update the following environment variables with appropriate values for the local registry that will hold the mirrored images.

- LOCAL_REGISTRY_HOST=\<ip or host name\>
- LOCAL_REGISTRY_PORT=\<port number\>
- LOCAL_REGISTRY_USER=\<user name\>
- LOCAL_REGISTRY_PASS=\<password\>

Now run them in the following order.

**01-run-registry-setup.sh** will setup the local registry for mirroring the images. 

**02-run-mirror-image.sh** will mirror the Cloud Pak images to the local registry. This will run for some time, probably hours. If it fails, just run it again. It will not copy images that have already been mirrored.

**03-run-catalog-setup.sh** will setup the catalog sources for Cloud Pak images. Once the script is finished, run `oc get pods -n openshift-marketplace` The result should be a list of the following pods with five random charachters after the name.

- bts-operator
- iaf-core-operators
- iaf-operators
- ibm-cp4a-operator
- opencloud-operators

Also run `oc get catalogsource -n openshift-marketplace` The result should be the following list of catalog sources.

- bts-operator
- iaf-core-operators
- iaf-operators
- ibm-cp4a-operator-catalog
- opencloud-operators

**04-run-create-operator.sh** will create the Cloud Pak operator. Once the script is finished, run the following commands to check the progress. 

`oc get pod -A | grep ibm-cp4a-operator`

`oc get pod -n ibm-common-services`

## Installation of Starter Profile
Note that the installation of the Starter profile is not supported in an air gapped environment. If the CP4BA Operator is already installed through a Production profile installation, the following is not needed.

Edit the `starter_operator_install.sh` replacing the values for the following environment variables.

- CP4BA_AUTO_CLUSTER_USER="<some_cluster_admin_user>"
- CP4BA_AUTO_STORAGE_CLASS_OCP="<file_storage_class>"
- CP4BA_AUTO_ENTITLEMENT_KEY="<entitlement_key>"

Log into the cluster with `oc login`

Now run the script `starter_operator_install.sh`. This will download the latest CASE file, apply the ServiceAccount and install the operator. It may take 15-30 minutes to become stable and ready to use.
