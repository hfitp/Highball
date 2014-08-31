//
//  Post.swift
//  Highball
//
//  Created by Ian Ynda-Hummel on 8/29/14.
//  Copyright (c) 2014 ianynda. All rights reserved.
//

import Foundation

class Post {
    var json: JSONValue!
    var id: Int!
    var type: String!
    var blogName: String!

    required init(json: JSONValue!) {
        self.json = json
        self.id = json["id"].integer!
        self.type = json["type"].string!
        self.blogName = json["blog_name"].string!
    }

    func photos() -> (Array<PostPhoto>) {
        if let photos = self.json["photos"].array {
            return photos.map { (photoJSON: JSONValue!) -> (PostPhoto) in
                return PostPhoto(json: photoJSON)
            }
        }
        return []
    }

    func layoutRows() -> (Array<Int>) {
        var photosetLayoutRows = Array<Int>()
        if let layoutString = self.json["photoset_layout"].string {
            for character in self.json["photoset_layout"].string! {
                photosetLayoutRows.insert("\(character)".toInt()!, atIndex: 0)
            }
        }
        return photosetLayoutRows
    }

    func body() -> (String?) {
        var bodyString: String?
        switch self.type {
        case "photo":
            bodyString = self.json["caption"].string
        case "text":
            bodyString = self.json["body"].string
        case "answer":
            bodyString = self.json["answer"].string
        case "quote":
            bodyString = self.json["text"].string
        default:
            bodyString = nil
        }

        if let string = bodyString {
            if countElements(string) > 0 {
                return string
            }
        }

        return nil
    }

    func htmlBodyWithWidth(width: CGFloat) -> (String?) {
        return self.body()?.htmlStringWithTumblrStyle(width)
    }

    func secondaryBody() -> (String?) {
        var bodyString: String?
        switch self.type {
        case "quote":
            bodyString = self.json["source"].string
        default:
            bodyString = nil
        }

        if let string = bodyString {
            if countElements(string) > 0 {
                return string
            }
        }

        return nil
    }

    func htmlSecondaryBodyWithWidth(width: CGFloat) -> (String?) {
        var stringToStyle: String?
        if let secondaryBody = self.secondaryBody() {
            switch self.type {
            case "quote":
                stringToStyle = "<table><tr><td>-&nbsp;</td><td>\(secondaryBody)</td></tr></table>"
            default:
                stringToStyle = secondaryBody
            }
        }

        return stringToStyle?.htmlStringWithTumblrStyle(width)
    }

    func asker() -> (String?) {
        return self.json["asking_name"].string
    }

    func question() -> (String?) {
        return self.json["question"].string
    }

}
