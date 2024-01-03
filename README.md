# 🐋 Docker NodeJS App Runner
- Clone NodeJS app from git and run it in a Docker container.
- Works with any git provider.

# 🤓 Setup
- Download `docker-compose.yml` file:
```bash
$ wget https://raw.githubusercontent.com/barbarbar338/docker-node-app-runner/main/docker-compose.yml
```
- Edit `docker-compose.yml` file as you wish. Don't forget to add these environment variables.
    - `runner__GIT_USERNAME`: Your git username
    - `runner__PERSONAL_ACCESS_TOKEN`: Git server personal access token.
    - `runner__GIT_FQDN`: Git server fqdn. Example: https://github.com -> github.com, https://gitea.338.rocks -> gitea.338.rocks
    - `runner__GIT_REPO_NAME`: Repo to be cloned.
    - `runner__GIT_REPO_OWNER`: Owner of the repo to be cloned.
    - `runner__GIT_SERVER_SECURE`: true or false
    - `runner__EXTRA_ALPINE_DEPENDENCIES`: This environment variable is not mandatory. If your app depends on extra dependencies then add them here.
- Run `docker-compose up -d` and wait
- Your app is now running in a docker container!

# 🧦 Contributing
Feel free to use GitHub's features.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/my-feature`)
3. Commit your Changes (`git commit -m 'my awesome feature my-feature'`)
4. Push to the Branch (`git push origin feature/my-feature`)
5. Open a Pull Request

# 🔥 Show your support

Give a ⭐️ if this project helped you!

# 📞 Contact

- Mail: hi@338.rocks
- Discord: https://discord.gg/BjEJFwh
