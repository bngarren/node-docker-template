

# Getting Started 🍪

1. Clone the project: `git clone --depth=1 https://github.com/bngarren/node-docker-template.git <new-project-name>`
   - depth=1 just clones the latest commit and not the full history
2. `cd <new-project-name>`
3. If a clean git history if desired, then remove the existing .git directory with `rm -rf .git` and then reinitialize with `git init` then `git add .` then `git commit -m "Initial commit!:`
4. Boot up a Docker container using: `sh run-docker-development.sh` and ensure you can bash in, and also run test suite!
   - The above startup script will handle this, but if not, remember to create some empty .env files: `touch .env.common .env.development` as these are expected by Docker compose


# What's in the template? ☕️
- **Typescript ready** with my `tsconfig.json` as well as a `tsconfig.test.json` to customize rules for tests
- **Streamlined Docker setup**
  - **Includes a Dockerfile** using a `node:19` base and one target ("development") that keeps devDependencies.
  - Includes a `compose.yaml` file for adding future services
  - **Custom entrypoint sh script**: `entrypoint.development.docker.sh`
  - **Shared volumes** `./src`, `/.tests`, and `.logs` to edit source code and modify tests on the fly. Logs can be viewed/edited from host machine.
  - **Custom startup script**, e.g. `run-docker-development.sh`, provides a simple CLI to boot up this container, enter bash, run tests, view logs, etc.
- **ESLint and Prettier** ready to go. Includes `.eslintrc` and `.prettierrc`
- Includes `./vscode` dir with workspace `settings.json` and `launch.json` for debugging
- **Testing package** using Jest and ts-jest.
  - Can run tests and debugger within Docker container!

# Dockerization 📦
- This Dockerfile builds a 'base' target from **node:19** and installs production dependencies.
- It also builds a **'development' target** that includes devDependencies (e.g. Typescript, Jest, ts-jest, etc.)
- If desired, a 'staging' or 'production' target could also be built, and should be added to the `compose.yaml` file accordingly.

## Ports
- In the `compose.yaml`, within the app_development container, we have the following:
  - "2024:2024" - this binds all traffic on the host machine's port 2024 (left side) to the container's port 2024 (right side). Thus, if running a server, must ensure that you match that port to the one that the docker container is exposing.
  - "9230:9229" - this binds the container's 9229 port (traditional Node.js debugging port) to the host machine's 9230. E.g. When running a debugger, VSCode can access this through port 9230 (defined in the `./vscode/launch.json`). 
    - If you need to use another host port (other than 9230), make the change in the `compose.yaml` and `launch.json` files!

# Environmental variables ✍️
- This template uses **multiple .env files**:
  - `.env.common` should be parsed in a 'config.js' file, e.g. using dotenv. It should also be included in each container in `compose.yaml`
  - `.env.development` is a .env file specific to this context. Again, in a 'config.js' file, can use dotenv to read the correct file based on the NODE_ENV that should match this file's suffix. In `compose.yaml`, we add this specific .env.development to the app_development container.