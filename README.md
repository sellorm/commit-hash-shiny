# Git Commit hash shiny app example

A small example app that can display it's own git commit hash when deployed to 
RStudio Connect.

This app requires RStudio Connect version 1.9.0 or above for all the required environment variables to be set automatically.

![App screenshot](git-commit-hash-screenshot.png)

When deployed to Connect the app uses `httr` to query the Connect API and retrieve the git commit hash associated with the deployed application.
