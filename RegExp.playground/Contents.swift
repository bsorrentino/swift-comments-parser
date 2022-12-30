
import Cocoa
import RegexBuilder

// https://uibakery.io/regex-library/url
// /^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/
let rxurl = Regex {
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

let regex = Regex {
    Capture {
        Regex {
            "["
            OneOrMore(.any)
            "]"
            ZeroOrMore(.whitespace)
            "("
            rxurl
            ")"
        }
    }
}

var match = "[hello] (http://www.softphone.eu)".firstMatch(of: regex)
if let match {
    print(match.1)
}
match = "[hello] (https://stackoverflow.com/q/53933165/521197)".firstMatch(of: regex)
if let match {
    print(match.1)
}
