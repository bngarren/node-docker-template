#!/bin/sh

### Entrypoint for our 'development' target. 

echo
echo "Running! (\`development\` target of Dockerfile)"
tail -f /dev/null #Hack to keep the container running so we can bash in or keep runnings tests...