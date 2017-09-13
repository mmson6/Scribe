//
//  BibleFactory.swift
//  Scribe
//
//  Created by Mikael Son on 9/8/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation

struct BibleVOM {
    public let engName: String
    public let korName: String
    public let chapters: Int
}

class BibleFactory: NSObject {
    
    static func getAllList() -> [BibleVOM] {
        var chapterList = [BibleVOM]()
        chapterList.append(BibleVOM(engName: "Genesis", korName: "창세기", chapters: 50))
        chapterList.append(BibleVOM(engName: "Exodus", korName: "출애굽기", chapters: 40))
        chapterList.append(BibleVOM(engName: "Leviticus", korName: "레위기", chapters: 27))
        chapterList.append(BibleVOM(engName: "Numbers", korName: "민수기", chapters: 36))
        chapterList.append(BibleVOM(engName: "Deuteronomy", korName: "신명기", chapters: 34))
        chapterList.append(BibleVOM(engName: "Joshua", korName: "여호수아", chapters: 24))
        chapterList.append(BibleVOM(engName: "Judges", korName: "사사기", chapters: 21))
        chapterList.append(BibleVOM(engName: "Ruth", korName: "룻기", chapters: 4))
        chapterList.append(BibleVOM(engName: "1 Samuel", korName: "사무엘상", chapters: 31))
        chapterList.append(BibleVOM(engName: "2 Samuel", korName: "사무엘하", chapters: 24))
        chapterList.append(BibleVOM(engName: "1 Kings", korName: "열왕기상", chapters: 22))
        chapterList.append(BibleVOM(engName: "2 Kings", korName: "열왕기하", chapters: 25))
        chapterList.append(BibleVOM(engName: "1 Chronicles", korName: "역대상", chapters: 29))
        chapterList.append(BibleVOM(engName: "2 Chronicles", korName: "역대하", chapters: 36))
        chapterList.append(BibleVOM(engName: "Ezra", korName: "에스라", chapters: 10))
        chapterList.append(BibleVOM(engName: "Nehemiah", korName: "느헤미야", chapters: 13))
        chapterList.append(BibleVOM(engName: "Esther", korName: "에스더", chapters: 10))
        chapterList.append(BibleVOM(engName: "Job", korName: "욥기", chapters: 42))
        chapterList.append(BibleVOM(engName: "Psalms", korName: "시편", chapters: 150))
        chapterList.append(BibleVOM(engName: "Proverbs", korName: "잠언", chapters: 31))
        chapterList.append(BibleVOM(engName: "Ecclesiastes", korName: "전도서", chapters: 12))
        chapterList.append(BibleVOM(engName: "Song of Songs", korName: "아가", chapters: 8))
        chapterList.append(BibleVOM(engName: "Isaiah", korName: "이사야", chapters: 66))
        chapterList.append(BibleVOM(engName: "Jeremiah", korName: "예레미야", chapters: 52))
        chapterList.append(BibleVOM(engName: "Lamentations", korName: "예레미야애가", chapters: 5))
        chapterList.append(BibleVOM(engName: "Ezekiel", korName: "에스겔", chapters: 48))
        chapterList.append(BibleVOM(engName: "Daniel", korName: "다니엘", chapters: 12))
        chapterList.append(BibleVOM(engName: "Hosea", korName: "호세아", chapters: 14))
        chapterList.append(BibleVOM(engName: "Joel", korName: "요엘", chapters: 3))
        chapterList.append(BibleVOM(engName: "Amos", korName: "아모스", chapters: 9))
        chapterList.append(BibleVOM(engName: "Obadiah", korName: "오바댜", chapters: 1))
        chapterList.append(BibleVOM(engName: "Jonah", korName: "요나", chapters: 4))
        chapterList.append(BibleVOM(engName: "Micah", korName: "미가", chapters: 7))
        chapterList.append(BibleVOM(engName: "Nahum", korName: "나훔", chapters: 3))
        chapterList.append(BibleVOM(engName: "Habakkuk", korName: "하박국", chapters: 3))
        chapterList.append(BibleVOM(engName: "Zephaniah", korName: "스바냐", chapters: 3))
        chapterList.append(BibleVOM(engName: "Haggai", korName: "학개", chapters: 2))
        chapterList.append(BibleVOM(engName: "Zechariah", korName: "스가랴", chapters: 14))
        chapterList.append(BibleVOM(engName: "Malachi", korName: "말라기", chapters: 4))
        chapterList.append(BibleVOM(engName: "Matthew", korName: "마태복음", chapters: 28))
        chapterList.append(BibleVOM(engName: "Mark", korName: "마가복음", chapters: 16))
        chapterList.append(BibleVOM(engName: "Luke", korName: "누가복음", chapters: 24))
        chapterList.append(BibleVOM(engName: "John", korName: "요한복음", chapters: 21))
        chapterList.append(BibleVOM(engName: "Acts", korName: "사도행전", chapters: 28))
        chapterList.append(BibleVOM(engName: "Romans", korName: "로마서", chapters: 16))
        chapterList.append(BibleVOM(engName: "1 Corinthians", korName: "고린도전서", chapters: 16))
        chapterList.append(BibleVOM(engName: "2 Corinthians", korName: "고린도후서", chapters: 13))
        chapterList.append(BibleVOM(engName: "Galatians", korName: "갈라디아서", chapters: 6))
        chapterList.append(BibleVOM(engName: "Ephesians", korName: "에베소서", chapters: 6))
        chapterList.append(BibleVOM(engName: "Philippians", korName: "빌립보서", chapters: 4))
        chapterList.append(BibleVOM(engName: "Colossians", korName: "골로새서", chapters: 4))
        chapterList.append(BibleVOM(engName: "1 Thessalonians", korName: "데살로니가전서", chapters: 5))
        chapterList.append(BibleVOM(engName: "2 Thessalonians", korName: "데살로니가후서", chapters: 3))
        chapterList.append(BibleVOM(engName: "1 Timothy", korName: "디모데전서", chapters: 6))
        chapterList.append(BibleVOM(engName: "2 Timothy", korName: "디모데후서", chapters: 4))
        chapterList.append(BibleVOM(engName: "Titus", korName: "디도서", chapters: 3))
        chapterList.append(BibleVOM(engName: "Philemon", korName: "빌레몬서", chapters: 1))
        chapterList.append(BibleVOM(engName: "Hebrews", korName: "히브리서", chapters: 13))
        chapterList.append(BibleVOM(engName: "James", korName: "야고보서", chapters: 5))
        chapterList.append(BibleVOM(engName: "1 Peter", korName: "베드로전서", chapters: 5))
        chapterList.append(BibleVOM(engName: "2 Peter", korName: "베드로후서", chapters: 3))
        chapterList.append(BibleVOM(engName: "1 John", korName: "요한1서", chapters: 5))
        chapterList.append(BibleVOM(engName: "2 John", korName: "요한2서", chapters: 1))
        chapterList.append(BibleVOM(engName: "3 John", korName: "요한3서", chapters: 1))
        chapterList.append(BibleVOM(engName: "Jude", korName: "유다서", chapters: 1))
        chapterList.append(BibleVOM(engName: "Revelation", korName: "요한계시록", chapters: 22))
        return chapterList
    }
}
