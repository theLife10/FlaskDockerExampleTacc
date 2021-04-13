# Allow over-ride
if [ -z "${CONTAINER_IMAGE}" ]
then
    version=$(cat ./_util/VERSION)
    CONTAINER_IMAGE="index.docker.io/sirimullalab/biasnet:latest"
fi
. lib/container_exec.sh

# Write an excution command below that will run a script or binary inside the 
# requested container, assuming that the current working directory is 
# mounted in the container as its WORKDIR. In place of 'docker run' 
# use 'container_exec' which will handle setup of the container on 
# a variety of host environments. 
#
# Here is a template:
#
# container_exec ${CONTAINER_IMAGE} COMMAND OPTS INPUTS
#
# Here is an example of counting words in local file 'poems.txt',
# outputting to a file 'wc_out.txt'
#
# container_exec ${CONTAINER_IMAGE} wc poems.txt > wc_out.txt
#

# set -x

# set +x
singularity instance start docker://sirimullalab/biasnet:latest biasnet
singularity exec instance://biasnet cp -r /app .
cd app/
singularity run instance://biasnet &
sleep 10
curl -X POST -F smiles="${smiles}" localhost:5000/predict > result.json
singularity instance stop biasnet
mv result.json ../
rm -rf app/