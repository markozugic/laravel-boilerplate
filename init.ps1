Function log {
    param(
        [Parameter(Mandatory=$true)][String]$msg
    )

    Write-Output "[$(Get-Date)] - $($msg)"
}

Function err {
    param(
        [Parameter(Mandatory=$true)][String]$msg
    )

    Write-Error "[$(Get-Date)] - $($msg)"
    exit
}

log "Copying .env.example -> .env"
Copy-Item ./src/.env.example ./src/.env
if (!$?)
{
   err "Failed to copy .env.example"
}

log "Removing previous volumes"
docker-compose down -v
log "Starting docker-compose stack..."
docker-compose up -d
if (!$?)
{
    err "Error while starting docker-compose stack."
}

log "Installing dependencies"
docker-compose run --rm composer install
if (!$?)
{
    err "Error while installing dependencies."
}

log "Generating app key"
docker-compose run --rm artisan key:generate
docker-compose run --rm artisan cache:clear
if (!$?)
{
    err "Error while generating app key."
}

log "Running database migrations"
docker-compose run --rm artisan migrate
if (!$?)
{
    err "Error while running database migrations."
}

# log "Installing npm packages"
# docker-compose run --rm npm install
# if (!$?)
# {
#     err "Error while installing npm packages."
# }

# log "Compiling assets."
# docker-compose run --rm npm run dev
# if (!$?)
# {
#     err "Error while compiling assets."
# }

log "Copying the pre commit hook"
Copy-Item pre-commit .git/hooks/pre-commit

log "Finished."
