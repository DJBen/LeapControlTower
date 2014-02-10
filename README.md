LeapControlTower
================

Control a flight shooting game on iOS with Leap Motion through [Firebase](https://www.firebase.com/) data sync service.

[![Youtude screenshot](http://img.youtube.com/vi/6kGG6vjnP2k/0.jpg)](http://www.youtube.com/watch?v=Y6kGG6vjnP2k)

## Requirements

This project uses ARC and Xcode 5 to build. It also uses cocoapods to manage dependencies.

Of course you need a [Leap Motion](https://www.leapmotion.com) sensor.

## Structure

LeapControlTower project is the Mac OS X client that manages Leap Motion signal and upload flight attitude data (basically your hand movement).

Its subdirectory SpriteExperiment is a shabby iOS flight shooting game. It receives control signal from [Firebase](https://www.firebase.com/) to which the "control tower" uploads data and ... you get the idea!

## Installation

If you haven't got an account on [Firebase](https://www.firebase.com/), apply for one. It's free and it manages syncronization of data smartly. You'll love it. After you get an account, create a firebase and remember it's URL. Usually it's like `xxx.firebaseIO.com`

Clone this project, go into directory and `pod install` to install dependencies. Then go to SpriteExperiment directory and `pod install` again.

Open both `LeapControlTower.xcworkspace` and `SpriteExperiment.xcworkspace` in `/SpriteExperiment` directory, in their `LCTConnectionConfig.h` files, you'll see a line like this:

    #define SYNC_URL @"https://yourFireBaseName.firebaseIO.com/LeapControlTower"

Just replace `yourFireBaseName` part to your corresponding firebase name you've got.

Now run LeapControlTower first and SpriteExperiment second. Voila!
