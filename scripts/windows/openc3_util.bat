@echo off

if "%1" == "" (
  GOTO usage
)
if "%1" == "encode" (
  GOTO encode
)
if "%1" == "hash" (
  GOTO hash
)
if "%1" == "save" (
  GOTO save
)
if "%1" == "load" (
  GOTO load
)
if "%1" == "zip" (
  GOTO zip
)
if "%1" == "clean" (
  GOTO clean
)
if "%1" == "hostsetup" (
  GOTO hostsetup
)

GOTO usage

:encode
  powershell -c "[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("""%2"""))"
GOTO :EOF

:hash
  powershell -c "new-object System.Security.Cryptography.SHA256Managed | ForEach-Object {$_.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("""%2"""))} | ForEach-Object {$_.ToString("""x2""")} | Write-Host -NoNewline"
GOTO :EOF

:save
  if not exist tmp md tmp
  if "%2" == "" (
    REM If tag is not given don't pull and use locally built latest
    set tag=latest
  ) else (
    set tag=%~2
    echo on
    docker pull openc3/openc3-enterprise-gem:!tag! || exit /b
    docker pull openc3/openc3-enterprise-operator:!tag! || exit /b
    docker pull openc3/openc3-enterprise-cmd-tlm-api:!tag! || exit /b
    docker pull openc3/openc3-enterprise-script-runner-api:!tag! || exit /b
    docker pull openc3/openc3-enterprise-traefik:!tag! || exit /b
    docker pull openc3/openc3-enterprise-redis:!tag! || exit /b
    docker pull openc3/openc3-enterprise-minio:!tag! || exit /b
    docker pull openc3/openc3-enterprise-init:!tag! || exit /b
    docker pull openc3/openc3-enterprise-keycloak:!tag! || exit /b
    docker pull openc3/openc3-enterprise-postgresql:!tag! || exit /b
  )
  echo on
  docker save openc3/openc3-enterprise-gem:!tag! -o tmp/openc3-enterprise-gem-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-operator:!tag! -o tmp/openc3-enterprise-operator-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-cmd-tlm-api:!tag! -o tmp/openc3-enterprise-cmd-tlm-api-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-script-runner-api:!tag! -o tmp/openc3-enterprise-script-runner-api-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-traefik:!tag! -o tmp/openc3-enterprise-traefik-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-redis:!tag! -o tmp/openc3-enterprise-redis-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-minio:!tag! -o tmp/openc3-enterprise-minio-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-init:!tag! -o tmp/openc3-enterprise-init-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-keycloak:!tag! -o tmp/openc3-enterprise-keycloak-!tag!.tar || exit /b
  docker save openc3/openc3-enterprise-postgresql:!tag! -o tmp/openc3-enterprise-postgresql-!tag!.tar || exit /b
  echo off
GOTO :EOF

:load
  if "%2" == "" (
    set tag=latest
  ) else (
    set tag=%~2
  )
  echo on
  docker load -i tmp/openc3-enterprise-gem-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-operator-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-cmd-tlm-api-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-script-runner-api-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-traefik-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-redis-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-minio-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-init-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-keycloak-!tag!.tar || exit /b
  docker load -i tmp/openc3-enterprise-postgresql-!tag!.tar || exit /b
  echo off
GOTO :EOF

:zip
  zip -r openc3.zip *.* -x "*.git*" -x "*coverage*" -x "*tmp/cache*" -x "*node_modules*" -x "*yarn.lock"
GOTO :EOF

:clean
  for /d /r %%i in (*node_modules*) do (
    echo Removing "%%i"
    @rmdir /s /q "%%i"
  )
  for /d /r %%i in (*coverage*) do (
    echo Removing "%%i"
    @rmdir /s /q "%%i"
  )
  REM Prompt for removing yarn.lock files
  forfiles /S /M yarn.lock /C "cmd /c del /P @path"
  REM Prompt for removing Gemfile.lock files
  forfiles /S /M Gemfile.lock /C "cmd /c del /P @path"
GOTO :EOF

:hostsetup
  docker run --rm --privileged --pid=host justincormack/nsenter1 /bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled" || exit /b
  docker run --rm --privileged --pid=host justincormack/nsenter1 /bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag" || exit /b
  docker run --rm --privileged --pid=host justincormack/nsenter1 /bin/sh -c "sysctl -w vm.max_map_count=262144" || exit /b
GOTO :EOF

:usage
  @echo Usage: %1 [encode, hash, save, load, clean, redishost] 1>&2
  @echo *  encode: encode a string to base64 1>&2
  @echo *  hash: hash a string using SHA-256 1>&2
  @echo *  save: save openc3 to tar files 1>&2
  @echo *  load: load openc3 tar files 1>&2
  @echo *  zip: create openc3 zipfile 1>&2
  @echo *  clean: remove node_modules, coverage, etc 1>&2
  @echo *  hostsetup: configure host for redis 1>&2

@echo on
