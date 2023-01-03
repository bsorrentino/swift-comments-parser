
import Cocoa
import RegexBuilder

// [URL regex that starts with HTTP or HTTPS](https://uibakery.io/regex-library/url)
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
            Capture {
                rxurl
            }
            ")"
        }
    }
}

var match = "[hello] (http://www.softphone.eu)".firstMatch(of: regex)
if let match {
    print(match.1, match.2)
    
}
match = "[hello] (https://stackoverflow.com/q/53933165/521197)".firstMatch(of: regex)
if let match {
    print(match.1, match.2)
}
match = "[12345] bla bla bla  [hello] (https://stackoverflow.com/q/53933165/521197)".firstMatch(of: regex)
if let match {
    print(match.1, match.2)
}


// let test01 = /(\[[^\[]+\]\s*\(.+\))/

let anyExceptOpenSquareBracket = CharacterClass.anyOf("[").inverted

let test01 = Regex {
    Capture {
        Regex {
            "["
            OneOrMore(anyExceptOpenSquareBracket)
            "]"
            ZeroOrMore(.whitespace)
            "("
            Capture {
                rxurl
            }
            ")"
        }
    }
}

let match01 = "[12345] bla bla bla  [hello] (https://stackoverflow.com/q/53933165/521197)".firstMatch(of: test01)
if let match01 {
    print(match01.1)
}
