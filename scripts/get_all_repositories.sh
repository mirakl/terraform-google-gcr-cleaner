#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract "gcr_host_name" and "google_project_id" arguments from the input into
# GCR_HOST_NAME and GOOGLE_PROJECT_ID shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "GCR_HOST_NAME=\(.gcr_host_name) GOOGLE_PROJECT_ID=\(.google_project_id)"')"

# construct a string that holds the content of a json list object, without opening and closing brackets `[]`
# "{\"name\":\"gcr.io/my-project/nested/repository\"},{\"name\":\"gcr.io/my-project/another/nested/repository\"},"
function get_gcr_repositories {
    local main_repository=$1
    local repositories=""
    while read nested_repository; do
        if [ $(gcloud container images list --repository $nested_repository --format json | jq length) -eq 0 ]; then
            repositories+="{\"name\":\"${nested_repository}\"},"
        else
            get_gcr_repositories $nested_repository
        fi
    done < <(gcloud container images list --repository "${main_repository}" --format json | jq -r '.[].name')
    echo "${repositories}"
}

# Placeholder for whatever data-fetching logic your script implements
repo_names="$(get_gcr_repositories "${GCR_HOST_NAME}"/"${GOOGLE_PROJECT_ID}")"
# remove trailing comma, insert into a list and remove `name` keys:
# [
# "gcr.io/my-project/nested/repository",
# "gcr.io/my-project/another/nested/repository"
# ]
REPOSITORIES=$(echo "["${repo_names%%,}"]" | jq '.|map(.name)')

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg repositories "${REPOSITORIES}" '{"repositories":$repositories}'
# this will produce the following
# {
#   "repositories": [
#     "gcr.io/my-project/nested/repository",
#     "gcr.io/my-project/another/nested/repository"
#   ]
# }
