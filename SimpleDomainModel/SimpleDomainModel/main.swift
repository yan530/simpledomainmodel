//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(_ to: String) -> Money {
        var money : Double = Double(amount) * 1.0
        switch currency {
        case "USD":
            money *= 1.0
        case "GBP":
            money *= 2.0
        case "EUR":
            money /= 1.5
        case "CAN":
            money /= 1.25
        default:
            return Money(amount : 0, currency : "")
        }
        switch to {
        case "USD":
            return Money(amount : Int(money), currency : to)
        case "GBP":
            return Money(amount : Int(money * 0.5), currency : to)
        case "EUR":
            return Money(amount : Int(money * 1.5), currency : to)
        case "CAN":
            return Money(amount : Int(money * 1.25), currency : to)
        default:
            return Money(amount : 0, currency : "")
        }
    }
    
    public func add(_ to: Money) -> Money {
        return Money(amount : convert(to.currency).amount + to.amount, currency : to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        return Money(amount : convert(from.currency).amount - from.amount, currency : from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        if case .Salary(let value) = type {
            return value
        } else if case .Hourly(let value) = type {
            return Int(value * Double(hours))
        }
        return 0
    }
    
    open func raise(_ amt : Double) {
        if case .Salary(let value) = type {
            type = JobType.Salary(value + Int(amt))
        } else if case .Hourly(let value) = type {
            type = JobType.Hourly(value + amt)
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if (age > 16) {
                _job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse
        }
        set(value) {
            if (age > 21){
                _spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
    
    open func haveChild(_ child: Person) -> Bool {
        if members[0].age > 21 || members[1].age > 21 {
            members.append(child)
            return true
        } else {
            return false
        }
    }
    
    open func householdIncome() -> Int {
        var income = 0
        for i in 1...members.count {
            income += members[i - 1].job?.calculateIncome(2000) ?? 0
        }
        return income
    }
}






