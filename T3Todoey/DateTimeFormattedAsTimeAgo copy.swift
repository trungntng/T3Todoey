//
//  DateTimeFormattedAsTimeAgo.swift
//  Swift Time Ago
//
//  Created by Julien Colin on 4/17/15.
//  Copyright (c) 2015 Toldino. All rights reserved.
//

import Foundation

public func dateTimeFormattedAsTimeAgo(date: NSDate, referenceDate now: NSDate = NSDate()) -> String {

  let secondsFromDate = now.secondsFrom(date)
  if secondsFromDate < 60 {
    return secondsFormatter()
  }
  
  let minutesFromDate = now.minutesFrom(date)
  if minutesFromDate < 60 {
    return minutesFormatter(minutesFromDate)
  }
  
  let hoursFromDate = now.hoursFrom(date)
  if hoursFromDate < 24 {
    return hoursFormatter(hoursFromDate)
  }
  
  let daysFromDate = now.daysFrom(date)
  switch daysFromDate {
  case 1:
    return yesterdayFormatter()
  case 2...6:
    return daysFormatter(daysFromDate)
  default:
    break
  }
  
  let weeksFromDate = now.weeksFrom(date)
  let monthsFromDate = now.monthsFrom(date)
  switch monthsFromDate {
  case 0:
    return weeksFormatter(weeksFromDate)
  case 1...11:
    return monthsFormatter(monthsFromDate)
  default:
    break
  }
  
  let yearsFromDate = now.yearsFrom(date)
  return yearsFormatter(yearsFromDate)
}

// MARK: Formatter functions

func classicFormatterAgo(_ quantity: Int, _ unit: String) -> String {
  var formattedString = "\(quantity) \(unit)"
  if quantity > 1 {
    formattedString += "s"
  }
  formattedString += " ago"
  return formattedString
}

func secondsFormatter() -> String {
  return "Just now"
}

func minutesFormatter(_ minutes: Int) -> String {
  return classicFormatterAgo(minutes, "minute")
}

func hoursFormatter(_ hours: Int) -> String {
  return classicFormatterAgo(hours, "hour")
}

func yesterdayFormatter() -> String {
  return "Yesterday"
}

func daysFormatter(_ days: Int) -> String {
  return classicFormatterAgo(days, "day")
}

func weeksFormatter(_ weeks: Int) -> String {
  return classicFormatterAgo(weeks, "week")
}

func monthsFormatter(_ months: Int) -> String {
  return classicFormatterAgo(months, "month")
}

func yearsFormatter(_ years: Int) -> String {
  return classicFormatterAgo(years, "year")
}

// MARK: Extension of NSDate

private extension NSDate {
  func yearsFrom(_ date:NSDate) -> Int{
    let unitFlags = Set<Calendar.Component>([.year])
    let dateComponents = NSCalendar.current.dateComponents(unitFlags, from: date as Date, to: self as Date)
    return dateComponents.year!
  }
  func monthsFrom(_ date:NSDate) -> Int{
    let unitFlags = Set<Calendar.Component>([.month])
    let dateComponents = NSCalendar.current.dateComponents(unitFlags, from: date as Date, to: self as Date)
    return dateComponents.month!
  }
  func weeksFrom(_ date:NSDate) -> Int{
    let unitFlags = Set<Calendar.Component>([.weekOfYear])
    let dateComponents = NSCalendar.current.dateComponents(unitFlags, from: date as Date, to: self as Date)
    return dateComponents.weekOfYear!
  }
  func daysFrom(_ date:NSDate) -> Int{
    let unitFlags = Set<Calendar.Component>([.day])
    let dateComponents = NSCalendar.current.dateComponents(unitFlags, from: date as Date, to: self as Date)
    return dateComponents.day!
  }
  func hoursFrom(_ date:NSDate) -> Int{
    let unitFlags = Set<Calendar.Component>([.hour])
    let dateComponents = NSCalendar.current.dateComponents(unitFlags, from: date as Date, to: self as Date)
    return dateComponents.hour!
  }
  func minutesFrom(_ date:NSDate) -> Int{
    let unitFlags = Set<Calendar.Component>([.minute])
    let dateComponents = NSCalendar.current.dateComponents(unitFlags, from: date as Date, to: self as Date)
    return dateComponents.minute!
  }
  func secondsFrom(_ date:NSDate) -> Int{
    let unitFlags = Set<Calendar.Component>([.second])
    let dateComponents = NSCalendar.current.dateComponents(unitFlags, from: date as Date, to: self as Date)
    return dateComponents.second!
  }
}
