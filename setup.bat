@echo off

echo.
echo Let's create something awesome!
set /p projectname=Project name (camel case, _ as whitespace):
echo.

powershell -Command "(gc docker-compose.yml) -replace 'PROJECTNAME', '%projectname%' | Out-File -encoding ASCII docker-compose.yml"
powershell -Command "(gc .env) -replace 'db:3306', '%projectname%_db:3306' | Out-File -encoding ASCII .env"
powershell -Command "(gc .gitlab-ci.yml) -replace 'docker exec php', 'docker exec %projectname%_php' | Out-File -encoding ASCII .gitlab-ci.yml"
powershell -Command "(gc .docker\nginx\nginx.conf) -replace 'PROJECTNAME', '%projectname%' | Out-File -encoding ASCII .docker\nginx\nginx.conf"

docker-compose build
docker-compose up -d
docker-compose exec -it %projectname%_php composer create-project symfony/skeleton tmp
robocopy tmp . /e
rd /s /q tmp

docker-compose exec -it %projectname%_php composer require --dev phpunit/phpunit symfony/test-pack
docker-compose exec -it %projectname%_php composer require --dev symfony/debug-bundle
docker-compose exec -it %projectname%_php composer require --dev phpstan/phpstan
docker-compose exec -it %projectname%_php composer require --dev phpstan/extension-installer
docker-compose exec -it %projectname%_php composer require --dev phpstan/phpstan-symfony
docker-compose exec -it %projectname%_php composer require --dev symfony/maker-bundle

del %0