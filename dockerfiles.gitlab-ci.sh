DOCKERFILES=""

function search_all_dockerfiles_task() {
    DOCKERFILES=$(find "dockerfiles" -name "*.Dockerfile" -type f)
}

function search_changed_dockerfiles_task() {
    DOCKERFILES=$(git diff --name-only HEAD HEAD~1 -- 'dockerfiles/***.Dockerfile')
}

function build_and_push_dockerfiles_task() {
    docker login "$CI_REGISTRY" \
        --username "$CI_REGISTRY_USER" \
        --password "$CI_REGISTRY_PASSWORD"

    for dockerfile in $DOCKERFILES; do
        path=$(echo "$dockerfile" | sed 's/^dockerfiles\///' | sed 's/\.Dockerfile$//')
        tag="$CI_REGISTRY/$CI_PROJECT_PATH/$path:$CI_COMMIT_REF_SLUG"

        echo "Building $dockerfile..."
        docker build --file "$dockerfile" --tag "$tag" .

        echo "Pushing $tag..."
        docker push "$tag"
    done
}
