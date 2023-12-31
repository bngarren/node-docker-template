#!/bin/sh

LIGHT_BLUE='\033[1;34m'
PURPLE_WHITE='\033[35;47m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

PREFIX="${PURPLE_WHITE}run-docker-development: ${NC} "

printf "\n\n"

printf "${PREFIX}${PURPLE}- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ${NC}\n\n"


if [ ! -f ./.env.common ]; then
    printf "${PREFIX}${NC}Initialized an empty .env.common file${NC}\n\n"
    touch .env.common
fi

if [ ! -f ./.env.development ]; then
    printf "${PREFIX}${NC}Initialized an empty .env.development file${NC}\n\n"
    touch .env.development
fi

printf "${PREFIX}${LIGHT_BLUE}Do you wish to rebuild the Docker images? [y/n]${NC} "

read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    printf "${PREFIX}${LIGHT_BLUE}Rebuilding Docker images...${NC}\n"
    docker-compose down
    docker-compose build app_development
fi

printf "\n${PREFIX}${LIGHT_BLUE}Starting app_development container...${NC}\n\n"

docker-compose up -d app_development --wait

printf "\n${PREFIX}${LIGHT_BLUE}Container is READY.${NC}\n\n"

while true; do
    printf "\n${PREFIX}${LIGHT_BLUE}Select an option:${NC}\n"
    printf "${PURPLE}1. Bash${NC}\n"
    printf "${PURPLE}2. Run test suite${NC}\n"
    printf "${PURPLE}3. Run test suite with debugger attached${NC}\n"
    printf "${PURPLE}4. Logs${NC}\n"
    printf "${PURPLE}*Press enter to exit with docker-compose down${NC}\n\n"

    read -p "Choose option: " option
    printf "\n"

    case $option in
        1)
            printf "${PREFIX}${LIGHT_BLUE}Starting bash...${NC}\n"
            docker-compose exec app_development /bin/bash
            ;;
        2)
            printf "${PREFIX}${LIGHT_BLUE}Running test suite...${NC}\n"
            docker-compose exec app_development npm run test
            ;;
        3)
            printf "${PREFIX}${LIGHT_BLUE}Running test suite with debugger attached...${NC}\n"
            docker-compose exec app_development \
            node --inspect-brk=0.0.0.0:9229 --nolazy -r ./node_modules/ts-node/register ./node_modules/jest/bin/jest.js --runInBand
            ;;
        4)
            docker-compose logs -t
            ;;
        *)
            printf "${PREFIX}${LIGHT_BLUE}See ya! Docker-compose down...${NC}\n\n"
            docker-compose down --remove-orphans
            if [ -f ./logs/app_development.log ]; then
                printf "${PREFIX}${LIGHT_BLUE}Clearing app_development.log...${NC}\n\n"
                rm -i ./logs/app_development.log
            fi
            break
            ;;
    esac
done
