import { Logger } from "@hammerhq/logger";
import { bool, cleanEnv, str } from "envalid";
import { exec } from "node:child_process";
import { mkdirSync } from "node:fs";
import { resolve } from "node:path";
import { promisify } from "node:util";

const execAsync = promisify(exec);

const env = cleanEnv(process.env, {
	runner__GIT_USERNAME: str({
		desc: "Username to access git repo",
	}),
	runner__PERSONAL_ACCESS_TOKEN: str({
		desc: "Personal access token to access git repo",
	}),
	runner__GIT_FQDN: str({
		desc: "Fully qualified domain name of git server",
		default: "github.com",
	}),
	runner__GIT_REPO_NAME: str({
		desc: "Name of git repo",
	}),
	runner__GIT_REPO_OWNER_NAME: str({
		desc: "Name of git repo owner",
	}),
	runner__GIT_SERVER_SECURE: bool({
		choices: [true, false],
		default: true,
		desc: "Whether or not to use HTTPS to connect to git server",
	}),
});

const logger = new Logger("[RUNNER]:");

async function main() {
	logger.info("Starting runner...");

	logger.event("Creating a temporary directory for repo...");
	const tempDir = resolve(__dirname, "repo_temp");
	mkdirSync(tempDir);
	logger.success(`Created temporary directory ${tempDir}`);

	logger.event(
		`Cloning ${env.runner__GIT_REPO_OWNER_NAME}/${env.runner__GIT_REPO_NAME} from ${env.runner__GIT_FQDN}...`,
	);
	const cloneURL = `http${env.runner__GIT_SERVER_SECURE ? "s" : ""}://${
		env.runner__GIT_USERNAME
	}:${env.runner__PERSONAL_ACCESS_TOKEN}@${env.runner__GIT_FQDN}/${
		env.runner__GIT_REPO_OWNER_NAME
	}/${env.runner__GIT_REPO_NAME}.git`;
	await execAsync(`git clone ${cloneURL} ${tempDir}`).catch((err) => {
		logger.error("Failed to clone repo");
		logger.error(err);

		process.exit(1);
	});
	logger.success("Repo cloned successfully!");

	const repoPackageJSON = require(resolve(tempDir, "package.json"));
	logger.info(`Found package.json with name ${repoPackageJSON.name}`);

	if (!repoPackageJSON.scripts) {
		logger.error("No scripts found in package.json");

		process.exit(1);
	}

	if (!repoPackageJSON.scripts.start) {
		logger.error("No start script found in package.json");

		process.exit(1);
	}

	logger.event("Installing dependencies...");
	await execAsync("npm install", {
		cwd: tempDir,
	}).catch((err) => {
		logger.error("Failed to install dependencies");
		logger.error(err);

		process.exit(1);
	});
	logger.success("Dependencies installed successfully!");

	if (repoPackageJSON.scripts?.build) {
		logger.event("Building repo...");
		await execAsync("npm run build", {
			cwd: tempDir,
		}).catch((err) => {
			logger.error("Failed to build repo");
			logger.error(err);

			process.exit(1);
		});
		logger.success("Repo built successfully!");
	}

	logger.event("Starting repo...");
	await execAsync("npm run start", {
		cwd: tempDir,
	}).catch((err) => {
		logger.error("Failed to start repo");
		logger.error(err);

		process.exit(1);
	});

	logger.info("Runner finished!");

	process.exit(0);
}

main();
