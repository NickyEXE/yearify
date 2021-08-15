# README

## Overview

Yearify is an application that takes in all of your Spotify Playlists, pulls your songs, and then creates new playlists for each year of your music. If you've ever wanted to listen to all your songs from 1971, this app will handle that for you.

## Status

This app will currently work on your local machine, but requires significant refactoring for smaller call sizes to allow it to be processed in production on a heroku dyno without timing out.

Next steps include:

* Incorporate batch insertion of songs into SQL database through the ORM
* Develop asynchronous solution so we don't have to wait for network requests to complete to move onto the next network request to substantially decrease runtime

## To set up on your local machine

This app requires you to have an API Key and Secret from Spotify, and to set up a `.env` file in the root of your directory with the following information:
```
SPOTIFY_KEY=<YOUR KEY>
SPOTIFY_SECRET=<YOUR SECRET>
ROOT=http://localhost:3000/
```
