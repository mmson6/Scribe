//
//  Constants.swift
//  Scribe
//
//  Created by Mikael Son on 5/3/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

public typealias JSONArray = [JSONObject]
public typealias JSONObject = [String: Any]

fileprivate let pBaseURL = "https://scribe-c1563.firebaseio.com/production/"
public let contactsChicago = "contacts/us/chicago/"

struct AppConfiguration {
    static let baseURL = pBaseURL
}



// MARK: - Enumerations

public enum Authorization {
    case none
    case admin
}






// MARK: Contacts Group Names

internal struct GroupName {
    static let YA_Group = "Young Adults"
    static let Fathers_Group = "Fathers"
    static let Mothers_Group = "Mothers"
    static let Teachers_Group = "Teachers"
    static let Choir_Group = "Choir"
    static let Church_School = "Church School"
    static let Translators_Group = "Translators"
}
//public typealias YA_Group = "Young Adults"
//public typealias Fathers_Group = "Fathers Group"
//public typealias Mothers_Group = "Mothers Group"
//public typealias Teachers_Group = "Teachers"
//public typealias Choir_Group = "Choir"







// MARK: Notifications

let mainLanguageChanged = Notification.Name("MainLanguageChanged")
let userRequestsCountChanged = Notification.Name("UserRequestsCountChanged")
let openFromSignUpRequest = Notification.Name("OpenFromSignUpRequest")




// MARK: Sign Up Alert Constants

// SignUpVC
public let OK = "Okay"

public let InvalidInputTitle = "Invalid Input"
public let InvalidNameTitle = "Invalid Name"
public let InvalidEmailTitle = "Invalid Email"
public let InvalidPasswordTitle = "Invalid Password"
public let InvalidCredentialsTitle = "Invalid Credentials"

public let InvalidInputMessage = "Invalid input. Please try again"
public let EmptyFirstNameMessage = "First name cannot be empty."
public let InvalidFirstNameMessage = "Your first name cannot contain special characters."
public let EmptyLastNameMessage = "Last name cannot be empty."
public let InvalidLastNameMessage = "Your last name cannot contain special characters."
public let EmptyEmailMessage = "Email cannot be empty."
public let InvalidEmailMessage = "Please enter email in the right format."
public let DuplicateEmailMessage = "This email is already in use. Please try your other email."
public let InvalidPasswordMessage = "Password needs to be at least 6 characters long."
public let InvalidCredentialsMessage = "Invalid email or password. Please try again"

// MoreInfoVC
public let RequestSentTitle = "Request Sent"
public let RequestSentMessage = "Your request has been sent. After the admin approves your request, you will be able to login to your account. Thank you."

// SignUpRequestsVC

public let SnatchedEmailMessage = "This email is already being used for other account. Please contact the Admin."






