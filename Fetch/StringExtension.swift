//
//  File.swift
//  Fetch
//
//  Created by Kanishka Goel on 2014-12-20.
//  Copyright (c) 2014 Kanishka Goel. All rights reserved.
//

import Foundation

extension String {
    
    subscript(r: Range<Int>) -> String?{
        
        if !self.isEmpty {
            
            var start = advance(startIndex, r.startIndex)
            var end   = advance(startIndex, r.endIndex)
            
            return substringWithRange(Range(start: start, end: end))
            
        }
        
        return nil
    }
    
    func findIndexOf(letter: String) -> Int? {
        
        var tempString          = self;
        var selfArray: [String] = []
        var index               = 0
        
        for character in tempString {
            
            selfArray.append(String(character))
            
        }
        
        for character in 0..<selfArray.count {
            
            if letter == selfArray[index] {
                return index
            }
            
            ++index
        }
        
        return nil
    }
    
}