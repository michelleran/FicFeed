//
//  Extrekt.swift
//  FicFeed
//
//  Created by Michelle Ran on 7/21/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation

class Extrekt {
    static func extractInfo(s: String) -> [String: String] {
        /*  summary:
                </a></p><p>[summary]</p><p>Words: [some # idc]
         *  rating:
                <li>Rating: <a href=[link idc] class="tag">[rating]</a></li>Warnings:
         *  warnings:
                <li>Warnings: <a href=[link idc] class="tag">[warning 1]</a>[...same thing if more...]</a></li>[Categories: || Characters: || Relationships: || Additional Tags:]
         *  ships:
                <li>Relationships: <a href=[link] class="tag">[relationship]</a>[...same thing if more...]<li>Additional Tags:
         */

        var info: [String: String] = [:]
        let summary = htmlHelper(extractHelper(s, startRef: "</a></p><p>", endRef: "</p><p>Words:"))
        info["summary"] = charHelper(summary)

        var temp = extractHelper(s, startRef: "<li>Rating: <a href=", endRef: "<li>Warnings:")
        info["rating"] = ratingHelper(extractHelper(temp, startRef: "class=\"tag\">", endRef: "</a></li>"))
        
        // in order they appear in
        if s.containsString("<li>Categories:") {
            temp = extractHelper(s, startRef: "<li>Warnings: <a href=", endRef: "<li>Categories:")
        } else if s.containsString("<li>Characters:") {
            temp = extractHelper(s, startRef: "<li>Warnings: <a href=", endRef: "<li>Characters:")
        } else if s.containsString("<li>Relationships:") {
            temp = extractHelper(s, startRef: "<li>Warnings: <a href=", endRef: "<li>Relationships:")
        } else if s.containsString("<li>Additional Tags:") {
            temp = extractHelper(s, startRef: "<li>Warnings: <a href=", endRef: "<li>Additional Tags:")
        } else {
            temp = extractHelper(s, startRef: "<li>Warnings: <a href=")
        }
        info["warnings"] = repeatExtract(temp, startRef: "class=\"tag\">", endRef: "</a>")
        
        if s.containsString("<li>Relationships: <a href=") {
            if s.containsString("<li>Additional Tags:") {
                temp = extractHelper(s, startRef: "<li>Relationships: <a href=", endRef: "<li>Additional Tags:")
            } else {
               temp = extractHelper(s, startRef: "<li>Relationships: <a href=", endRef: "</ul>")
            }
            let ships = repeatExtract(temp, startRef: "class=\"tag\">", endRef: "</a>")
            info["ships"] = charHelper(ships)
        } else {
            info["ships"] = "None"
        }

        return info
    }
    
    private static func extractHelper(string: String, startRef: String, endRef: String) -> String {
        let startRange = string.rangeOfString(startRef)
        let endRange = string.rangeOfString(endRef)
        
        if startRange == nil || endRange == nil { return "N/A" }
        if startRange?.endIndex > endRange?.startIndex { return "N/A" }
        
        return string.substringWithRange(startRange!.endIndex..<endRange!.startIndex)
    }
    
    private static func extractHelper(string: String, startRef: String) -> String {
        let startRange = string.rangeOfString(startRef)
        return string.substringWithRange(startRange!.endIndex..<string.endIndex)
    }
    
    private static func extractHelper(string: String, endRef: String) -> String {
        let endRange = string.rangeOfString(endRef)
        return string.substringWithRange(string.startIndex..<endRange!.startIndex)
    }
    
    private static func repeatExtract(string: String, startRef: String, endRef: String) -> String {
        // following part could be made more...elegant
        var temp = extractHelper(string, startRef: startRef)
        var extracted = extractHelper(temp, endRef: endRef)
        temp = extractHelper(temp, startRef: endRef)
        if temp.containsString(startRef) {
            // there are multiple
            while temp.containsString(startRef) {
                extracted += ", " + extractHelper(temp, startRef: startRef, endRef: endRef)
                temp = extractHelper(temp, startRef: endRef)
            }
            return extracted
        } else {
            // only one
            return extracted
        }
    }
    
    private static func ratingHelper(rating: String) -> String {
        if rating == "General Audiences" {
            return "G"
        } else if rating == "Teen And Up Audiences" {
            return "T"
        } else if rating == "Mature" {
            return "M"
        } else if rating == "Explicit" {
            return "E"
        } else if rating == "Not Rated" {
            return "NR"
        } else {
            return "N/A"
        }
    }
    
    private static func htmlHelper(summary: String) -> String {
        var result: String = summary.stringByReplacingOccurrencesOfString("<p>", withString: "\n")
        result = result.stringByReplacingOccurrencesOfString("<br />", withString: "\n")
        while result.containsString("<") && result.containsString(">") {
            let toReplace = result[result.characters.indexOf("<")!...result.characters.indexOf(">")!]
            result = result.stringByReplacingOccurrencesOfString(toReplace, withString: "")
        }
        return result
    }
    
    static func charHelper(string: String) -> String {
        var result = string.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        result = result.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
        return result
    }
}