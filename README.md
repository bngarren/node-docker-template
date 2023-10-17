

# Getting started

1. 
2. Remember to create some empty .env files: `touch .env.common .env.development`


# What's in the template?
- **Typescript ready** with my `tsconfig.json` as well as a `tsconfig.test.json` to customized rules for tests
- Streamlined Docker setup
  - **Includes a Dockerfile** using a `node:19` base and one target ("development") that keeps devDependencies.
  - Includes a `compose.yaml` file for adding future services
  - **Custom entrypoint sh script**: `entrypoint.development.docker.sh`
  - **Shared volumes** `./src`, `/.tests`, and `.logs` to edit source code and modify tests on the fly. Logs can be viewed/edited from host machine.
  - **Custom startup script**, e.g. `run-docker-development.sh`, provides a simple CLI to boot up this container, enter bash, run tests, view logs, etc.
- **ESLint and Prettier** ready to go. Includes `.eslintrc` and `.prettierrc`
- Includes `./vscode` dir with workspace `settings.json` and `launch.json` for debugging
- **Testing package** using Jest and ts-jest.
  - Can run tests and debugger within Docker container!