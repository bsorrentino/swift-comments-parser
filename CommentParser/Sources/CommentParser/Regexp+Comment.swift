//
//  regexp.swift
//  SwiftCommentParser
//
//  Created by Bartolomeo Sorrentino on 02/01/23.
//

import Foundation
import RegexBuilder

// [URL regex that starts with HTTP or HTTPS](https://uibakery.io/regex-library/url)
// /^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/
let regexUrl = Regex {
    //Anchor.startOfLine
    "http"
    Optionally {
        "s"
    }
    "://"
    Optionally {
        "www."
    }
    Repeat(1...256) {
        CharacterClass(
            .anyOf("-@:%._+~#="),
            ("a"..."z"),
            ("A"..."Z"),
            ("0"..."9")
        )
    }
    "."
    Repeat(1...6) {
        CharacterClass(
            .anyOf("()"),
            ("a"..."z"),
            ("A"..."Z"),
            ("0"..."9")
        )
    }
    Anchor.wordBoundary
    ZeroOrMore {
        CharacterClass(
            .anyOf("-()@:%_+.~#?&/="),
            ("a"..."z"),
            ("A"..."Z"),
            ("0"..."9")
        )
    }
    //Anchor.endOfLine
}


let anyExceptOpenSquareBracket = CharacterClass.anyOf("[").inverted
let regexComment = Regex {
    Capture {
        Regex {
            "["
            OneOrMore(anyExceptOpenSquareBracket)
            "]"
            ZeroOrMore(.whitespace)
            "("
            Capture {
                regexUrl
            }
            ")"
        }
    }
}

