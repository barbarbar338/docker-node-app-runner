#!/bin/bash

# Check environment variables
username=$runner__GIT_USERNAME
personal_access_token=$runner__GIT_PERSONAL_ACCESS_TOKEN
git_fqdn=$runner__GIT_FQDN
git_repo_name=$runner__GIT_REPO_NAME
git_repo_owner=$runner__GIT_REPO_OWNER
git_server_secure=$runner__GIT_SERVER_SECURE

# Check all environment variables are set
if [ -z "$username" ] || [ -z "$personal_access_token" ] || [ -z "$git_fqdn" ] || [ -z "$git_repo_name" ] || [ -z "$git_repo_owner" ] || [ -z "$git_server_secure" ]; then
		echo "ERROR: One or more environment variables are missing"
		exit 1
fi

# Start the runner
echo "Starting runner..."

# Check if extra dependencies are required
extra_dependencies=$runner__EXTRA_ALPINE_DEPENDENCIES
if [ ! -z "$extra_dependencies" ]; then
		echo "Installing extra dependencies..."
		apk add --no-cache $extra_dependencies
		echo "Extra dependencies installed"
fi

# Check if the runner is already configured
# If there is no folder called /app/repo_temp, then the runner is not configured
if [ ! -d "/app/repo_temp" ]; then
		echo "Creating repo folder..."

		# Create a temporary folder to clone the repository
		mkdir -p /app/repo_temp

		# Clone the repository
		echo "Cloning repository..."
		git clone https://$username:$personal_access_token@$git_fqdn/$git_repo_owner/$git_repo_name /app/repo_temp
		echo "Repository cloned"

		# Install dependencies
		echo "Installing dependencies..."
		cd /app/repo_temp
		npm install
		echo "Dependencies installed"

		# If package.json file has build script then run it
		if [ -f "package.json" ]; then
				if grep -q "build" "package.json"; then
						echo "Running build script..."
						npm run build
						echo "Build script finished"
				fi
		fi
fi

# Run the repo
echo "Running repository..."
cd /app/repo_temp
npm start

echo "Repository finished"

