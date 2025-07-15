#!/bin/bash
set -e

# Verify GITHUB_TOKEN is set
: "${GITHUB_TOKEN:?GITHUB_TOKEN is not set. Aborting.}"

echo "===== DEBUG: Current Directory ====="
pwd
echo "===== DEBUG: File Listing ====="
ls -la

echo "===== DEBUG: CD Directory Files ====="
ls -la CD/

echo "===== DEBUG: deployment.yml BEFORE ====="
cat CD/deployment.yml || echo "deployment.yml not found!"

echo "===== INFO: Configuring Git identity ====="
git config user.email "${GIT_EMAIL}"
git config user.name "${GIT_NAME}"

echo "===== INFO: Replacing image tag in deployment.yml ====="
sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" "${DEPLOYMENT_FILE}"

echo "===== DEBUG: deployment.yml AFTER ====="
cat "${DEPLOYMENT_FILE}" || echo "deployment.yml not found!"

echo "===== INFO: Adding and committing changes ====="
git add "${DEPLOYMENT_FILE}"
git commit -m "Updated Deployment image to version ${BUILD_NUMBER}" || echo "No changes to commit"

echo "===== INFO: Pushing changes to GitHub ====="
git push "https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME}.git" HEAD:${GIT_BRANCH}

echo "✅ Deployment file updated and pushed successfully."
echo "===== DEBUG: Git Status ====="
git status