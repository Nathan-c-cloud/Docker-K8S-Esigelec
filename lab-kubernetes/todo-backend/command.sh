$ podman run --detach --name mariadb -p 3306:3306 --env MARIADB_ROOT_PASSWORD=user --env MARIADB_DATABASE=todo --network todo mariadb:latest 


podman build -t todofrontend .
podman build -t todobackend .
podman run --name todofrontend -d -p 8080:8080  --network todo todofrontend
podman run --name todobackend -d -p 3000:3000 --network todo todobackend
