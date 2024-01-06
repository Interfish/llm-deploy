SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

cd ${SCRIPT_DIR}

RUN_INTERACTIVELY="-it"
if [ -n "${RUN_DAEMON}" ]; then
    RUN_INTERACTIVELY="-d"
fi
if [ -z "${DOCKER_CMD}" ]; then
    DOCKER_CMD="bash"
fi

IMAGE="llm_deploy:latest"
PROJECT_ROOt=${SCRIPT_DIR}/..
GPUS=0
USER=$(id -u -n)
UID=$(id -u)

CONTAINER_WORKDIR=/llm_deploy

echo "FROM ${IMAGE}" | cat - uid.Dockerfile >tmp.Dockerfile

docker build \
    -f tmp.Dockerfile \
    --build-arg DOCKER_USER=${USER} \
    --build-arg USER_UID=${UID} \
    --tag ${IMAGE}_uid \
    ${SCRIPT_DIR}

rm tmp.Dockerfile

docker run \
    ${RUN_INTERACTIVELY} \
    --rm \
    --name llm_deploy \
    --cap-add=SYS_ADMIN \
    --cap-add=SYS_PTRACE \
    --shm-size=2g \
    --security-opt seccomp=unconfined \
    --gpus ${GPUS} \
    -v ${PROJECT_ROOt}:${CONTAINER_WORKDIR} \
    --user ${USER} \
    --workdir ${CONTAINER_WORKDIR} \
    ${IMAGE}_uid \
    bash -c "${DOCKER_CMD}"
