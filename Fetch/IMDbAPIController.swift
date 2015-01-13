//
//  IMDbAPIController.swift
//  Fetch
//
//  Created by Kanishka Goel on 2014-12-17.
//  Copyright (c) 2014 Kanishka Goel. All rights reserved.
//

var movieNameArray: [String] = []
var movieReleaseArray: [String] = []
var movieTypeArray: [String] = []
var movieIDArray: [String] = []

import UIKit

protocol IMDbAPIControllerDelegate {
    
    func didFinishIMDbSearch (result : Dictionary<String, String>)
}

class IMDbAPIController {
    
    var delegate: IMDbAPIControllerDelegate?
    
    init(delegate: IMDbAPIControllerDelegate?) {
        self.delegate = delegate
    }
   
    
    func searchIMDb(forContent : String) {
        
        //clean the string of spaces and get it ready to pass onto the API
        //will replace spaces in the string with %20 which is the ascii encoded value of a space in a URL string
        
        var spacelessString = forContent.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        if let foundString = spacelessString? {
            
            //create NSURL object - to pass onto
            //returns a JSON of all titles matching the name
            var totalResultsPath = NSURL(string: "http://www.omdbapi.com/?s=\(foundString)&tomatoes=true")
            
            var session2 = NSURLSession.sharedSession()
            
            var task2 = session2.dataTaskWithURL(totalResultsPath!) {
                
                data2, response2, error2 -> Void in
                
                //print the error if any exist
                if (error2 != nil) {
                    println(error2.localizedDescription)
                }
                
                //create an NSError optional object to pass in as parameter
                var jsonError : NSError?
                
                //take the 'data' that was passed in from the dataTaskWithURL request and put it in to a variable
                var jsonResult : AnyObject? = NSJSONSerialization.JSONObjectWithData(data2, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)
                //println("Just here: \(jsonResult)")
                
                if let dict = jsonResult as? [String: AnyObject] {
                    //println("************")
                    //println(dict)
                    if let movieDictionary = dict["Search"] as? [AnyObject] {
                        println("************")
                        println("************")
                        println("\nMovie dictionary:\n\n\(movieDictionary)")
                        if let movieString = movieDictionary[0]["Title"]! as? String {
                            self.searchIMDb2(movieString)
                            //println("***********")
                            //println("***********")
                            //println("***********")
                            movieNameArray.removeAll(keepCapacity: true)
                            movieReleaseArray.removeAll(keepCapacity: true)
                            movieTypeArray.removeAll(keepCapacity: true)
                            movieIDArray.removeAll(keepCapacity: true)
                            for i in movieDictionary {
                                var j = i["Title"] as? String
                                var k = i["Year"] as? String
                                var l = i["Type"] as? String
                                var m = i["imdbID"] as? String
                                movieNameArray.append(j!)
                                movieReleaseArray.append(k!)
                                movieTypeArray.append(l!)
                                movieIDArray.append(m!)
                            }
                            //println("Here goes: \(movieArray)")
                        }
                    }
                }
                
            }
            task2.resume()
        }
        
    }
    
    func searchIMDb2(forContent : String) {
        
        //clean the string of spaces and get it ready to pass onto the API
        //will replace spaces in the string with %20 which is the ascii encoded value of a space in a URL string
        
        var spacelessString = forContent.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        if let foundString = spacelessString? {
            
            //create NSURL object - to pass onto
            //returns a JSON of the only title matching the name
            var urlPath = NSURL(string: "http://www.omdbapi.com/?t=\(foundString)&tomatoes=true")
            
            //to reach out to the internet, we need sharedsession - a singleton object that can be returned from the NSURLSession (provides an API for downloading content via HTTP
            var session = NSURLSession.sharedSession()
            
            //making our API request by calling data task by passing URL on that session
            var task = session.dataTaskWithURL(urlPath!) {
                
                data, response, error -> Void in
                
                //print the error if any exist
                if (error != nil) {
                    println(error.localizedDescription)
                }
                
                //create an NSError optional object to pass in as parameter
                var jsonError : NSError?
                
                //take the 'data' that was passed in from the dataTaskWithURL request and put it in to a variable
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as Dictionary<String,String>
                
                if(jsonError != nil) {
                    println(jsonError!.localizedDescription)
                }
                
                if let apiDelegate = self.delegate? {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        apiDelegate.didFinishIMDbSearch(jsonResult)
                        
                    }
                }
                
            }
            task.resume()
            
        }
        
    }


    
}
