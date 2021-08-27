# README

## Overview

Yearify is an application that takes in all of your Spotify Playlists, pulls your songs, and then creates new playlists for each year of your music. If you've ever wanted to listen to all your songs from 1971, this app will handle that for you.

## Status

This app will currently work on your local machine, but requires significant refactoring for smaller call sizes to allow it to be processed in production on a heroku dyno without timing out.

Next steps include:

* Incorporate batch insertion of songs into SQL database through the ORM
<!-- * Develop asynchronous solution so we don't have to wait for network requests to complete to move onto the next network request to substantially decrease runtime -->
* Update User and Source Playlist to save their counts from Spotify.
  * Use this to create an asynchronity solve that waits for playlists and songs to be populated before moving onto next step, rather than forcing delay through worst case scenario async to resolve racing condition
    * Think on this a lil more
    * This doesn't work because we're finding or creating songs.
* Abstract spotify calls
* Refactor a buncha this and rethink placement of some methods this can be p hard to navigate esp with the chaining.

## To set up on your local machine

This app requires you to have an API Key and Secret from Spotify, and to set up a `.env` file in the root of your directory with the following information:
```
SPOTIFY_KEY=<YOUR KEY>
SPOTIFY_SECRET=<YOUR SECRET>
ROOT=http://localhost:3000/
```

## Sidekiq

This app requires redis to be installed and running on your computer to run in development mode.

With Homebrew:
`brew install redis`
`brew services start redis`

## Starting the App in Development Mode

Start sidekiq by running:
`bundle exec sidekiq`

Start rails with:
`rails s`
