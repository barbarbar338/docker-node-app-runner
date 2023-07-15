gitRepoName=$runner__GIT_REPO_NAME
gitRepoOwnerName=$runner__GIT_REPO_OWNER_NAME
gitUsername=$runner__GIT_USERNAME
gitMail=$runner__GIT_MAIL
gitPersonalAccessToken=$runner__GIT_PERSONAL_ACCESS_TOKEN
gitProviderFQDN=$runner__GIT_PROVIDER_FQDN

if [ -n "$gitRepoOwnerName" ] || [ -n "$gitRepoName" ] || [ -n "$gitRepoOwnerName" ] || [ -n "$gitUsername" ] || [ -n "$gitMail" ] || [ -n "$gitPersonalAccessToken" ]|| [ -n "$gitProviderFQDN" ]; then
    echo "Variables found!"
else
    echo "Missing environment variable(s)!"
    exit 1
fi

cloneUrl="https://$gitUsername:$gitPersonalAccessToken@$gitProviderFQDN/$gitRepoOwnerName/$gitRepoName"

echo "Setting git config variables"
git config --global user.name "$gitUsername"
git config --global user.email "$gitMail"

echo "Creating temporary runner directory"
mkdir runner
cd runner

echo "Cloning repo"
git clone $cloneUrl .

echo "Installing dependencies"
npm install

echo "Starting the app"
runScript="${runner__RUN_SCRIPT:-start}"
npm run $runScript

exit 0
