# ArchitectWithDocker
Sample project directory to startup application with docker
# Services
    1. PHP 8.1
    2. PHP mail send via postfix relay
    3. To start both services while boot docker container Supervisord used
# How to start
    1. add /etc/hosts entry for domain 127.0.0.1 keeplearning.test
    2. chmod -r 777 logs folder
    3. cd docker
    4. docker-compose up -d --build
# Test
    1. hit https://keeplearning.test
# Debug Docker continer
    1. `docker container logs <container_name>`
        - This will give error logs if container unable to start with.
    2. `docker container ls -a`
        - Check all running containers, along with port details and status
    3. `docker container exec -it <container_name> <shell_scripting_mode>`
        - This will help to connect to container.
        - Can execute any command inside the container
    4. `docker network ls`
        - List all networks the engine daemon knows about, including those spanning multiple hosts
    5. `docker network inspect`
        - Return information about one or more networks
> Note: you can pull your codebase inside the `src` folder, then update document_root path inside the nginx according to your codebase.