[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/sHz1bMKn)
Please go under edit and edit this file as needed for your project.  There is no seperate documentation needed.

# Project Name - Chat App
# Student Id - IT201300
# Student Name - Kalansooriya S. H 

#### 01. Brief Description of Project - 
In this chat App users can Sign into the sysystem and amoung  users can have chat. Users can send messages and thy cand share their curent location with each other

#### 02. Users of the System - 
     Everyday people can use chat apps to communicate with friends, family, and colleagues. 

#### 03. What is unique about your solution -
through this application users not only can cat with each other. they can share their location using this app

#### 04. Differences of Assignment 02 compared to Assignment 01
Assignment 01 I have created a app with simple crud opperations.It implemeted to the traveler to maintain a list of item that they packing when they are traveling


#### 05. Briefly document the functionality of the screens you have (Include screen shots of images)

Screen 1 SplashScreen /Screen01.png
Splash screens have use to to showcase a app logo's logo, name, theam and show visual identity the user. 

Screen 2 Registration Page /Screen02.png
users can Signup to the App using this page

Screen 3 Login Page /Screen03.png
users can login to the App using this page


Screen 4 Recent chat list /Screen04.png
users chat list that they hve chated will be dispaly



Screen 5 All firends Page /Screen05.png
users can view the all users that have register to the system and user can select a one and start the chat

Screen 6 Convercation Page /Screen06.png
user can send messages and view the message history



Screen 7 share location popup page /Screen07.png

when click the clip icon share location option will be display


Screen 8  Current location selection page/Screen08.png
user can get the curent location and viwe it throgh the map. 



Screen 9 Signout Screen /Screen09.png
sur can sign out using this


#### 06. Give examples of best practices used when writing code

 consistant naming conventions for variables, uses structures and constants where ever possible. 
```
import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "en_US")
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

```

#### 07. UI Components used
segmented style picker
textfields
Buttons
Location button
Text




#### 08. Testing carried out




#### 09. Documentation 

(a) Design Choices



(b) Implementation Decisions



(c) Challenges - 

with other Assignments and resersh work unable to manage the time 




#### 10. Additional iOS Library used

phonenumberkit - Verifify phone numbers
Firebase -  connection with firebase database
SDWebImageSwiftUI - load images for fast and efficient display.

#### 11. Reflection of using SwiftUI compared to UIKit

Using SwiftUI feels more streamlined and intuitive compared to UIKit, thanks to its declarative syntax and built-in features for creating modern and responsive user interfaces.



#### 12. Reflection General

Challenges that you faced in doing the assingment 

Due to my other assignments and research work, I struggled to effectively manage my time. Despite my best efforts, I was unable to incorporate some desired features that I had initially planned to implement.
  

