# Mood Tracker

An application that is a mood diary for users to keep track with their current mood.

-   Swift
-   Texture
-   MongoDB
-   Express.js
-   Node.js

## Practices used in building this project

-   Used Texture to design the frontend
-   Applied reactive programming through RxSwift
-   Worked with unidirectional flow and state management with ReSwift
-   Designed the API with OpenApi
-   Implemented API specs through Express.js and Node.js
-   Mongoose and MongoDB were utilized for the database

## Creating Pods in Swift

`pod init`

### In the pod file place

`pod 'Texture'`
`pod 'RxSwift'`
`pod 'ReSwift'`

## Running Backend Folder

`npm start`

## Running FrontEnd

-   Click on `MoodTracker.xcworkspace` file

# Mood Tracker Features

### Homepage

-   Users have the option to Sign In with their existing account or Sign Up with a new account
-   Placed authentication of users upon signing up and signing in together with sessions using JWE
-   Applied the concept of password hashing

![Home Page - Sign In](/Images/signIn.png 'Sign In')
![Home Page - Sign Up](/Images/signUp.png 'Sign Up')

### Application Access

-   Once Signed In/Signed Up, the user will be able to see the list of entries he/she has placed. No entries were placed yet as the user just signed up.

![No Entries](/Images/noEntries.png 'No Entries')

### Adding an Entry

-   The user can add an entry by clicking on the button on the center with a plus sign.
-   For the first page, the user is able to pick a date, time, and mood level.

![Choose Date](/Images/chooseDate.png 'Choose Date')
![Choose Time](/Images/chooseTime.png 'Choose Time')
![Choose Mood](/Images/moodLevel.png 'Choose Mood')

### Adding a Tag

-   Tags can also be placed with the entry to describe the emotion the user is feeling with regards to the entry.
-   The user can also choose from using the previous tags they've used

![Choose Tag](/Images/addTag.png 'Choose Tag')
![Existing Tags](/Images/useExistingTags.png 'Use Existing Tags')

### Add a Note

-   A note can also be added with the entry, and click Done.

![Add Note](/Images/addNote.png 'Add Note')

### Viewing of Entries

-   User can view **all** entries

![All Entries](/Images/allEntries.png 'All Entries')

#### Filtering By Day

-   User can view entries per **day**

![Filtering by Day](/Images/filteringByDay.png 'Filtering by Day')
![Day 1](/Images/byDay1.png 'Day 1')
![Day 2](/Images/byDay2.png 'Day 2')

#### Filtering By Week

-   User can view entries per **week**

![Filtering by Week](/Images/filteringByWeek.png 'Filtering by Day')
![Week 1](/Images/byWeek1.png 'Week 1')
![Week 2](/Images/byWeek2.png 'Week 2')

#### Filtering By Month

-   User can view entries per **month**

![Filtering by Week](/Images/filteringByMonth.png 'Filtering by Month')
![Month 1](/Images/byMonth1.png 'Month 1')
![Month 2](/Images/byMonth2.png 'Month 2')

### Viewing Insights

-   Users can also view the number of times they used a tag based on the mood level. Results of these can be filtered by **last month**, **last week**, and the **current week**.

![Overall Insights](/Images/overallInsights.png 'Overall Insights')
![Last Month](/Images/lastMonthInsight.png 'Last Month')
![Last Week](/Images/lastWeekInsight.png 'Last Week')
![This Week](/Images/thisWeekInsight.png 'This Week')

### Logging Out

-   Once done with using the application, users have the option to log out of their account or delete their account
