SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

UID=$(id -u)
USER=$(id -u -n)

cd ${SCRIPT_DIR}

docker build \
    -f llm_deploy.Dockerfile \
    --tag llm_deploy:latest \
    ${SCRIPT_DIR}
