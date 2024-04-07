---
title: "Degoogled android phone"
date: 2023-12-20T00:00:00-00:00
categories:
- review
tags:
- android
- privacy
---

## Why android and why degoogle?
- With an iPhone you don't have a choice - you're stuck with Apple. And Apple does not respect privacy ([1][GovPushNotif], [2][helloSystem]).
- Android phones typically come with Google Play Services pre-installed, and Google does not respect privacy ([1][GovPushNotif]).
- Fortunately, there are open source alternatives in the android world, and if you care about privacy you have some options.

<!--more-->

## Pleasant surprises (6 month reflection)
- Lifestyle changed from chasing shininess to focusing on privacy and value.
- There are many incredible open source apps (list below). There are only a few apps that are painfully missing (traffic-aware navigation, banking). Often, there is an adequate web ui available.


## The mindset that would make the transition easier
- You don't really need most non-opensource apps. Most apps you need likely have a web ui. The ones that do not - you can probably give up on them. Some apps with no good alternatives at the moment include: audible / library app, google maps / waze navigation.
- You won't be able to use the apps you already bought on Google Play, and that's ok.
	- Some vendors, such as Threema, sell their app on their own instance of F-Droid. That's awesome!


## Challenges and hopes
- F-Droid doesn't install updates automatically: need to manually apply updates one by one. The idea is that users should review changes before applying updates. Not practical for most people and may become irritating.
- For apps that are not on F-Droid, you need to remember to periodically manually download apks (e.g. Mega).
	- More and more open source apps become available on F-Droid. Hopefully this continues and your apps will all become available on F-Droid.
	- Some apps install their own updates. Signal, for example, notifies when an update is available and you can approve the update in a tap.
	- Some authors have their own F-Droid repository, for example: [threema](https://releases.threema.ch/fdroid/repo/). This way they are also able to collect payment without Play Services.

## "The stack"

### Fundamentals
- Pixel phone. The only phone with open source drivers.
- GrapheneOS. A very active ROM that also takes privacy very seriously.
- F-Droid. Doesn't install updates automatically (need to manually apply updates one by one; need to remember to periodically manually download apks from github for apps such as Mega -- but signal figured it out)
- AnySoftKeyboard. The only serious open source, privacy friendly keyboard. Reduced usability compared to commercial keyboards such as Gboard.
- Browse with Vanadium (built-in into GrapheneOS) and DuckDuckGo (great built-in ad blocking); use URLCheck as the default browser.
- Cloud storage: Mega, ente Photos.
- Navigation: Organic Maps.


### Identity
- Aegis
- Catima
- KeePassDX
- PassAndroid


### Productivity
- Librera FD
- Overload.
- Proton (email, calendar).
- Tailscale.
- Translate You.
- Tuta.


### Messaging
- Element
- Jami - supports SIP so you can have a virtual phone number.
- Mattermost
- Signal
- Telegram FOSS


### Activism
- StreetComplete
- Tower Collector


### Multimedia
- AntennaPod. Will take the familiar look of PocketCasts when you change the default page to "subscriptions".
- Clipious
- Jellyfin (+ tailscale)
- NewPipe - youtube, bandcamp.


### Shitter
- Feeder
- lichess
- Tusky
- Wikipedia


[GovPushNotif]: https://www.404media.co/us-government-warrant-monitoring-push-notifications-apple-google-yahoo/
[helloSystem]: https://github.com/helloSystem/hello

