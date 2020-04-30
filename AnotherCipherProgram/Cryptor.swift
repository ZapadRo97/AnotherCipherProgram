//
//  Cryptor.swift
//  AnotherCipherProgram
//
//  Created by Florin Daniel on 28/04/2020.
//  Copyright © 2020 Florin Daniel. All rights reserved.
//

import Cocoa

class Cryptor: NSObject {

    let key : String
    var affineAParam = 0
    var affineBParam = 0
    var bifidKey = ""
    var polybiusMap = [String:[Int]]()
    var alphabet = [String]()
    
    init?(key: String) {
        self.key = key
        
        let keyParams = key.components(separatedBy: " ")
        affineAParam = Int(keyParams[0]) ?? -1
        affineBParam = Int(keyParams[1]) ?? -1
        
        let coprimeWith26 = [1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25]
        
        bifidKey = keyParams[2]
        bifidKey = bifidKey.replacingOccurrences(of: "J", with: "I")
        
        if bifidKey.isEmpty == true {
            return nil
        }
        if !coprimeWith26.contains(affineAParam) {
            return nil
        }
        if affineAParam == -1 {
            return nil
        }
        if affineBParam == -1 {
            return nil
        }
        
        //construct alphabet array without j
        for value in UnicodeScalar("A").value...UnicodeScalar("Z").value {
            alphabet.append(String(UnicodeScalar(value)!))
        }
        alphabet = alphabet.filter {$0 != "J"}
        
        //remove duplicates for key construction
        var uniqueCharactersKey = ""
        bifidKey = bifidKey.uppercased()
        for character in bifidKey {
            if !uniqueCharactersKey.contains(character) {
                uniqueCharactersKey.append(character)
            }
        }
        uniqueCharactersKey = uniqueCharactersKey.filter {$0 != "J"}
        alphabet = alphabet.filter { !uniqueCharactersKey.contains($0) }
        alphabet = uniqueCharactersKey.map{ String($0) } + alphabet
        
        //construct polybius map
        //better than a matrix for performance
        var row = 1
        var col = 1
        for character in alphabet {
            polybiusMap[character] = [row, col]
            row = row + 1
            if row == 6 {
                row = 1
                col = col + 1
            }
        }
        
        print(polybiusMap)
    }
    
    func crypt(text: String) -> String{
        var text = text.uppercased()
        text = text.replacingOccurrences(of: "J", with: "I")
        text = text.filter{ alphabet.contains(String($0)) }
        var cryptedText = [Character]()
        for scalar in text.unicodeScalars {
            
            let letterId = scalar.value - ("A".unicodeScalars).first!.value
            let cipherLetterId = (affineAParam * Int(letterId) + affineBParam) % 26 + Int(("A".unicodeScalars).first!.value)
            cryptedText.append(Character(UnicodeScalar(cipherLetterId)!))
        }
        print("Afin: \(cryptedText)")
        
        var firstLine = [Int]()
        var secondLine = [Int]()
        
        for character in cryptedText {
            
            var characterString = String(character)
            if(characterString == "J") {
                characterString = "I"
            }
            let coords = polybiusMap[characterString]
            //put indexes on two lines
            firstLine.append(coords![0])
            secondLine.append(coords![1])
        }
        var cryptedText2 = ""
        //and them write them by rows
        let allLines = firstLine + secondLine
        for index in stride(from: 0, to: allLines.count, by: 2) {
            let row = allLines[index]
            let column = allLines[index+1]
            let alphabetIndex = (row-1) + (column-1) * 5
            cryptedText2 = cryptedText2 + alphabet[alphabetIndex]
        }
        
        
        return String(cryptedText2)
    }
    
    // helper function to calculate a ^-1 for decrypt
    func extendedGcd(a : Int, b: Int) -> Int{
        
        var r1 = a, r2 = b, u1 = 1, v1 = 0, u2 = 0, v2 = 1
        while (r2 != 0) {
            let q = r1 / r2
            let r3 = r1, u3 = u1, v3 = v1
            r1 = r2; u1 = u2; v1 = v2
            r2 = r3 - q * r2; u2 = u3 - q * u2; v2 = v3 - q * v2
        }
        return u1
    }
    
    func decrypr(text: String) -> String{
        
        var text = text.uppercased()
        //this should not be possible
        //maybe treat it as a typo
        text = text.replacingOccurrences(of: "J", with: "I")
        text = text.filter{ alphabet.contains(String($0)) }
        var decryptedText2 = ""
        var allLines = [Int]()
        for character in text {
            var characterString = String(character)
            if(characterString == "J") {
                characterString = "I"
            }
            let coords = polybiusMap[characterString]
            allLines.append(coords![0])
            allLines.append(coords![1])
        }
        let firstLine = allLines[0..<allLines.count/2]
        let secondLine = allLines[allLines.count/2..<allLines.count]
        
        for (row, col) in zip(firstLine, secondLine) {
            let alphabetIndex = (row-1) + (col-1) * 5
            decryptedText2 = decryptedText2 + alphabet[alphabetIndex]
        }
        //if there was a j in affine cipher text it is converted to i
        //for example, if we encrypt A to J (in affine) and to K (in bifid)
        //on decrypt, K from bifid will become a I (because of the way the square is constructed)
        //and that I will be decrypted as C from affine
        //being a monoalphabetic substitution, the only letter affected by this issue will be A
        //and the text can still be undestood with a swapped letter
        var decryptedText = [Character]()
        for scalar in decryptedText2.unicodeScalars {
            let letterId = scalar.value - ("A".unicodeScalars).first!.value
            let decipherLetterId = (26 + ((26 + extendedGcd(a: affineAParam, b: 26)) * (Int(letterId) - affineBParam)) % 26) % 26 + Int(("A".unicodeScalars).first!.value)
            decryptedText.append(Character(UnicodeScalar(decipherLetterId)!))
        }
        return String(decryptedText)
    }
}
