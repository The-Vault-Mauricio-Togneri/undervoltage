## TODO
* Try Firebase Dynamic Links
* Enabled login with Google
* Implement leaderboard
    - Frontend sends user ID to WS server when creating/joining a match
    - WS server calls an end point on the FB server to get the player info
    - Once the match is finished, the WS server calls the FB server sending:
        + match info (MatchStats)
        + id of winner
        + id of loser
        + special token to validate the request (anti-cheating)

When creating a new user in FB authentication, create the entry in Firestore

End points:
* GET /users/{userId}
* PATCH /users/{userId}
* GET /leaderboard
* POST /matches

* Change name
    - Wall
    - Push Force

## IDEAS
* Show random button that gives money but freezes player's actions if they press it
* Move units from one lane to another
* Pay to revive a lane
* Apply a temporary shield that prevents the enemy from sending units