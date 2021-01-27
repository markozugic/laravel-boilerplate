# Laravel Boilerplate - Laravel 8 API

## Requirements

- docker and docker-compose

  > Detailed instructions for setup of docker can be found [here](https://www.docker.com/community-edition).

- user added to `docker` group

# Initial setup of project

## Option 1: Use script to do everything for you

You will find init.sh bash script that will do all things that you would normally have to do manually.

In order to run script all you have to do is run `chmod +x init && ./init`

> Script might ask you for your password at some point.

## Option 2: Do initial setup manually

### Start docker containers and install dependencies

- Run docker containers in detached mode
  `docker-compose up -d`

  > Whole stack can be stopped with `docker-compose stop`

- Check all service status:
  `docker-compose ps`

- Install project dependencies with composer in container
  `docker exec -it laravel composer install`

- Generate application key
  `docker exec -it laravel php artisan key:generate`

### Create local environments

- Copy content from .env.example in .env (`cp .env.example .env`)

<!-- - Generate JWT secret key
  `docker exec -it laravel php artisan jwt:secret` -->

### Set directory permissions

`sudo chmod -R 777 src/storage src/bootstrap/cache`

# Use custom domain for development

- Edit /etc/hosts add local domain my-project.loc
  `127.0.0.1 my-project.loc`
  > Feel free to replace `my-project.loc` with whatever works for you. In that case you should also change `APP_URL` in .env
