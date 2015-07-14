# WatchHealthMedicalDoctor
A collection of ideas produced/learned during my first summer developing apps 9-5. This solely represents themes I worked on that were relevant to this job/project. 

Hi I'm Nik. I think this is cool stuff, can't wait to do more. Some of these ideas were given to me, I came up with others.
A very fun first project. 

A 3-tabbed application.

1: A page that prompts a 'splash' screen or 'home' screen of sorts with pleasant interface. Subsequently asks user for access to health information,
then uses that information and does some math/for loops to find out where there are gaps in the data. If there are gaps, notifies the user to give
more detail on these gaps.

2: A circular-notification system: meaning that this notification is triggered, likely on the watch if the user's phone is on lock. The notification
prompts the user to fill in information about their sleep, either routinely throughout the day or when they just wake up (since the app wakes up upon
heart-rate data being added to healthkit, so the first heart-rate will assumedly be when they woke up since the user likely charged their watch at
night. And since your watch sends the heart rate, it means you're already wearing it). The user is promted with date-pickers and countdown pickers
that determine when the first notification will be fired, and how often AFTER the watch survey has been taken, should the next notification fire.

3: A kind of History & Settings kind of deal: stores data that the user provides about their quality of sleep and/or tiredness.
Shows data in a table with detail view - conviently has a share button on the data. Pressing the share button auto-fills an e-mail and a message
with the provided contact information (will explain) and the provided data. The contact information is user-input that the user can store for
easy-access auto-fill e-mails.
Lastly, there is a flow-chart section. In this section, the user is presented with a graph that gives the familiar vibe of HealthKit,
but instead shows the data that has been stored by the app. It can show either the Sleep Quality data, or the Survey Tiredness data
with choices on whether this data is presented throughoutt the day, week, month, or year.
