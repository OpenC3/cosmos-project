@echo off
setlocal enabledelayedexpansion

REM Check if git is available
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo git not found!!!
    exit /b 1
)

REM Function to display usage
:usage
    echo Usage: openc3.bat upgrade ^<tag^> --preview
    echo e.g. openc3.bat upgrade v6.4.1
    echo The '--preview' flag will show the diff without applying changes.
    exit /b 1

REM Check if arguments are provided
if "%1"=="" goto usage

REM Setup the 'cosmos' remote if it doesn't exist
REM This allows us to pull the latest cosmos-project updates
git remote -v | findstr /b "cosmos " >nul 2>&1
if %errorlevel% neq 0 (
    echo Adding 'cosmos' remote to the current git repository.
    git remote add cosmos https://github.com/OpenC3/cosmos-project.git
)

REM Fetch the latest changes from the 'cosmos' remote
echo Fetching latest changes from 'cosmos' remote.
git fetch cosmos

REM Check the first argument is a valid git tag
git tag | findstr /x "%1" >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: '%1' is not a valid git tag.
    echo Available tags:
    git tag | sort
    goto usage
)

REM If the --preview flag is set, show the diff without applying changes
if "%2"=="--preview" (
    git diff -R %1
    exit /b 0
)

REM Apply the changes
git diff -R %1 | git apply --whitespace=fix --exclude="plugins/*"
echo Applied changes from tag '%1'.
echo We recommend committing these changes to your local repository.
echo e.g. git commit -am "Upgrade to %1"
echo You can now run 'openc3.bat run' to start the upgraded OpenC3 environment.
