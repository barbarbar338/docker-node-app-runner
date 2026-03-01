#!/usr/bin/env sh

username=$runner__GIT_USERNAME
personal_access_token=$runner__GIT_PERSONAL_ACCESS_TOKEN
git_fqdn=$runner__GIT_FQDN
git_repo_name=$runner__GIT_REPO_NAME
git_repo_owner=$runner__GIT_REPO_OWNER
git_server_secure=$runner__GIT_SERVER_SECURE

if [ -z "$username" ] || [ -z "$personal_access_token" ] || [ -z "$git_fqdn" ] || [ -z "$git_repo_name" ] || [ -z "$git_repo_owner" ] || [ -z "$git_server_secure" ]; then
		echo "ERROR: One or more environment variables are missing"
		exit 1
fi

echo "Starting runner..."

extra_dependencies=$runner__EXTRA_ALPINE_DEPENDENCIES
if [ ! -z "$extra_dependencies" ]; then
		echo "Installing extra dependencies..."
		apk add --no-cache $extra_dependencies
		echo "Extra dependencies installed"
fi

if [ ! -d "/app/repo_temp" ]; then
		echo "Creating repo folder..."
		mkdir -p /app/repo_temp
fi


if [ ! -d "/app/repo_temp/$git_repo_name" ]; then
		echo "Cloning repository..."
		cd /app/repo_temp
		git clone https://$username:$personal_access_token@$git_fqdn/$git_repo_owner/$git_repo_name
fi

echo "Installing dependencies..."
cd /app/repo_temp/$git_repo_name
npm install
echo "Dependencies installed"

if [ -f "package.json" ]; then
		if grep -q "build" "package.json"; then
				echo "Running build script..."
				npm run build
				echo "Build script finished"
		fi
fi

echo "Running repository..."
cd /app/repo_temp/$git_repo_name
npm start

echo "Repository finished"

