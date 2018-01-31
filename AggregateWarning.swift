//
//  AggregateWarning.swift
//
//  Created by nanashiki on 2018/01/31.
//  Copyright © 2018年 nanashiki. All rights reserved.
//
import Foundation

extension String {
    func match(_ pattern : String,options:NSRegularExpression.Options = []) -> String?{
        return Regexp(pattern,options:options).match(self,at: 1)
    }
    
    func matches(_ pattern : String,options:NSRegularExpression.Options = []) -> [[String]]?{
        return Regexp(pattern,options:options).matches(self)
    }
}

public struct Regexp{
    let pattern : String
    var options : NSRegularExpression.Options
    
    init(_ pattern:String,options:NSRegularExpression.Options = []) {
        self.pattern = pattern
        self.options = options
    }
    
    func matches(_ string : String)->[[String]]?{
        do{
            let results = try NSRegularExpression(pattern: pattern, options: options).matches(in: string, options: .reportProgress, range: NSMakeRange(0,string.count))
            var dats : [[String]] = [];
            for result in results {
                var datss :[String] = []
                for j in 1 ..< result.numberOfRanges {
                    datss.append((string as NSString).substring(with: result.range(at: j)))
                }
                dats += [datss]
            }
            return dats
            
        }catch{
            return nil
        }
    }
    
    func match(_ string : String,at : Int)->String?{
        do{
            let dat = try NSRegularExpression(pattern: pattern, options: options).matches(in: string, options: .reportProgress, range: NSMakeRange(0,string.count))
            
            if dat.count == 0 {
                return nil
            }
            
            return (string as NSString).substring(with: dat[0].range(at: at))
        }catch{
            return nil
        }
    }
}

let arguments = CommandLine.arguments
if arguments.count < 2 {
    print("Not enough arguments")
    exit(-1)
}
let path = arguments[1]
var str = ""
do {
    str = try String(contentsOfFile: path)
} catch  {
    print(error.localizedDescription)
    exit(-2)
}
let arr = str.matches("/(.+) warning: (.+)\n") ?? [[]]

var deprecatedDic = [String:Int]()
var othersDic = [String:Int]()

var dCount = 0
var oCount = 0

arr.forEach {
    item in
    if let deprecated = item[1].match("'(.+)' is deprecated") {
        if let count = deprecatedDic[deprecated] {
            deprecatedDic[deprecated] = count + 1
        } else {
            deprecatedDic[deprecated] = 1
        }
        dCount = dCount + 1
        return
    }
    
    if let deprecated = item[1].match("'(.+)' was deprecated") {
        if let count = deprecatedDic[deprecated] {
            deprecatedDic[deprecated] = count + 1
        } else {
            deprecatedDic[deprecated] = 1
        }
        dCount = dCount + 1
        return
    }
    
    if let count = othersDic[item[1]] {
        othersDic[item[1]] = count + 1
    } else {
        othersDic[item[1]] = 1
    }
    oCount = oCount + 1
}

let deprecatedArr = deprecatedDic.sorted{ $0.value > $1.value }
let othersArr = othersDic.sorted{ $0.value > $1.value }

print("| deprecated | count |")
print("| --- | --- |")
deprecatedArr.forEach {
    arg in
    print("| \(arg.key) | \(String(arg.value)) |")
}
print("")

print("| others | count |")
print("| --- | --- |")

othersArr.forEach {
    arg in
    print("| \(arg.key) | \(String(arg.value)) |")
}
print("")


print("| type | count |")
print("| --- | --- |")
print("| deprecated | \(String(dCount)) |")
print("| others | \(String(oCount)) |")
print("| sum | \(String(arr.count)) |")
print("")

exit(0)
