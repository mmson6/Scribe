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
    public let versesPerChapter: [Int]
}

class BibleFactory: NSObject {
    
    static func getAllList() -> [BibleVOM] {
        var chapterList = [BibleVOM]()
        chapterList.append(BibleVOM(engName: "Genesis", korName: "창세기", chapters: 50, versesPerChapter: [31,25,24,26,32,22,24,22,29,32,32,20,18,24,21,16,27,33,38,18,34,24,20,67,34,35,46,22,35,43,54,33,20,31,29,43,36,30,23,23,57,38,34,34,28,34,31,22,33,26]))
        chapterList.append(BibleVOM(engName: "Exodus", korName: "출애굽기", chapters: 40, versesPerChapter: [22,25,22,31,23,30,29,28,35,29,10,51,22,31,27,36,16,27,25,26,37,30,33,18,40,37,21,43,46,38,18,35,23,35,35,38,29,31,43,38]))
        chapterList.append(BibleVOM(engName: "Leviticus", korName: "레위기", chapters: 27, versesPerChapter: [17,16,17,35,26,23,38,36,24,20,47,8,59,57,33,34,16,30,37,27,24,33,44,23,55,46,34]))
        chapterList.append(BibleVOM(engName: "Numbers", korName: "민수기", chapters: 36, versesPerChapter: [54,34,51,49,31,27,89,26,23,36,35,16,33,45,41,35,28,32,22,29,35,41,30,25,18,65,23,31,39,17,54,42,56,29,34,13]))
        chapterList.append(BibleVOM(engName: "Deuteronomy", korName: "신명기", chapters: 34, versesPerChapter: [46,37,29,49,33,25,26,20,29,22,32,31,19,29,23,22,20,22,21,20,23,29,26,22,19,19,26,69,28,20,30,52,29,12]))
        chapterList.append(BibleVOM(engName: "Joshua", korName: "여호수아", chapters: 24, versesPerChapter: [18,24,17,24,15,27,26,35,27,43,23,24,33,15,63,10,18,28,51,9,45,34,16,33]))
        chapterList.append(BibleVOM(engName: "Judges", korName: "사사기", chapters: 21, versesPerChapter: [36,23,31,24,31,40,25,35,57,18,40,15,25,20,20,31,13,31,30,48,25]))
        chapterList.append(BibleVOM(engName: "Ruth", korName: "룻기", chapters: 4, versesPerChapter: [22,23,18,22]))
        chapterList.append(BibleVOM(engName: "1 Samuel", korName: "사무엘상", chapters: 31, versesPerChapter: [28,36,21,22,12,21,17,22,27,27,15,25,23,52,35,23,58,30,24,42,16,23,28,23,43,25,12,25,11,31,13]))
        chapterList.append(BibleVOM(engName: "2 Samuel", korName: "사무엘하", chapters: 24, versesPerChapter: [27,32,39,12,25,23,29,18,13,19,27,31,39,33,37,23,29,32,44,26,22,51,39,25]))
        chapterList.append(BibleVOM(engName: "1 Kings", korName: "열왕기상", chapters: 22, versesPerChapter: [53,46,28,34,18,38,51,66,28,29,43,33,34,31,34,34,24,46,21,43,29,53]))
        chapterList.append(BibleVOM(engName: "2 Kings", korName: "열왕기하", chapters: 25, versesPerChapter: [18,25,27,44,27,33,20,29,37,36,20,22,25,29,38,20,41,37,37,21,26,20,37,20,30]))
        chapterList.append(BibleVOM(engName: "1 Chronicles", korName: "역대상", chapters: 29, versesPerChapter: [54,55,24,43,26,81,40,40,44,14,47,40,14,17,29,43,27,17,19,8,30,19,32,31,31,32,34,21,30]))
        chapterList.append(BibleVOM(engName: "2 Chronicles", korName: "역대하", chapters: 36, versesPerChapter: [17,18,17,22,14,42,22,18,31,19,23,16,22,15,19,14,19,34,11,37,20,12,21,27,28,23,9,27,36,27,21,33,25,33,27,23]))
        chapterList.append(BibleVOM(engName: "Ezra", korName: "에스라", chapters: 10, versesPerChapter: [11,70,13,24,17,22,28,36,15,44]))
        chapterList.append(BibleVOM(engName: "Nehemiah", korName: "느헤미야", chapters: 13, versesPerChapter: [11,20,32,23,19,19,73,18,38,39,36,47,31]))
        chapterList.append(BibleVOM(engName: "Esther", korName: "에스더", chapters: 10, versesPerChapter: [22,23,15,17,14,14,10,17,32,3]))
        chapterList.append(BibleVOM(engName: "Job", korName: "욥기", chapters: 42, versesPerChapter: [22,13,26,21,27,30,21,22,35,22,20,25,28,22,35,22,16,21,29,29,34,30,17,25,6,14,23,28,25,31,40,22,33,37,16,33,24,41,30,24,34,17]))
        chapterList.append(BibleVOM(engName: "Psalms", korName: "시편", chapters: 150, versesPerChapter: [6,12,8,8,12,10,17,9,20,18,7,8,6,7,5,11,15,50,14,9,13,31,6,10,22,12,14,9,11,12,24,11,22,22,28,12,40,22,13,17,13,11,5,26,17,11,9,14,20,23,19,9,6,7,23,13,11,11,17,12,8,12,11,10,13,20,7,35,36,5,24,20,28,23,10,12,20,72,13,19,16,8,18,12,13,17,7,18,52,17,16,15,5,23,11,13,12,9,9,5,8,28,22,35,45,48,43,13,31,7,10,10,9,8,18,19,2,29,176,7,8,9,4,8,5,6,5,6,8,8,3,18,3,3,21,26,9,8,24,13,10,7,12,15,21,10,20,14,9,6]))
        chapterList.append(BibleVOM(engName: "Proverbs", korName: "잠언", chapters: 31, versesPerChapter: [33,22,35,27,23,35,27,36,18,32,31,28,25,35,33,33,28,24,29,30,31,29,35,34,28,28,27,28,27,33,31]))
        chapterList.append(BibleVOM(engName: "Ecclesiastes", korName: "전도서", chapters: 12, versesPerChapter: [18,26,22,17,19,12,29,17,18,20,10,14]))
        chapterList.append(BibleVOM(engName: "Song of Songs", korName: "아가", chapters: 8, versesPerChapter: [17,17,11,16,16,12,14,14]))
        chapterList.append(BibleVOM(engName: "Isaiah", korName: "이사야", chapters: 66, versesPerChapter: [31,22,26,6,30,13,25,22,21,34,16,6,22,32,9,14,14,7,25,6,17,25,18,23,12,21,13,29,24,33,9,20,24,17,10,22,38,22,8,31,29,25,28,28,25,13,15,22,26,11,23,15,12,17,13,12,21,14,21,22,11,12,19,12,25,24]))
        chapterList.append(BibleVOM(engName: "Jeremiah", korName: "예레미야", chapters: 52, versesPerChapter: [19,37,25,31,31,30,34,23,25,25,23,17,27,22,21,21,27,23,15,18,14,30,40,10,38,24,22,17,32,24,40,44,26,22,19,32,21,28,18,16,18,22,13,30,5,28,7,47,39,46,64,34]))
        chapterList.append(BibleVOM(engName: "Lamentations", korName: "예레미야애가", chapters: 5, versesPerChapter: [22,22,66,22,22]))
        chapterList.append(BibleVOM(engName: "Ezekiel", korName: "에스겔", chapters: 48, versesPerChapter: [28,10,27,17,17,14,27,18,11,22,25,28,23,23,8,63,24,32,14,44,37,31,49,27,17,21,36,26,21,26,18,32,33,31,15,38,28,23,29,49,26,20,27,31,25,24,23,35]))
        chapterList.append(BibleVOM(engName: "Daniel", korName: "다니엘", chapters: 12, versesPerChapter: [21,49,30,37,31,28,28,27,27,21,45,13]))
        chapterList.append(BibleVOM(engName: "Hosea", korName: "호세아", chapters: 14, versesPerChapter: [9,25,5,19,15,11,16,14,17,15,11,15,15,10]))
        chapterList.append(BibleVOM(engName: "Joel", korName: "요엘", chapters: 3, versesPerChapter: [20,32,21]))
        chapterList.append(BibleVOM(engName: "Amos", korName: "아모스", chapters: 9, versesPerChapter: [15,16,15,13,27,14,17,14,15]))
        chapterList.append(BibleVOM(engName: "Obadiah", korName: "오바댜", chapters: 1, versesPerChapter: [21]))
        chapterList.append(BibleVOM(engName: "Jonah", korName: "요나", chapters: 4, versesPerChapter: [16,11,10,11]))
        chapterList.append(BibleVOM(engName: "Micah", korName: "미가", chapters: 7, versesPerChapter: [16,13,12,14,14,16,20]))
        chapterList.append(BibleVOM(engName: "Nahum", korName: "나훔", chapters: 3, versesPerChapter: [14,14,19]))
        chapterList.append(BibleVOM(engName: "Habakkuk", korName: "하박국", chapters: 3, versesPerChapter: [17,20,19]))
        chapterList.append(BibleVOM(engName: "Zephaniah", korName: "스바냐", chapters: 3, versesPerChapter: [18,15,20]))
        chapterList.append(BibleVOM(engName: "Haggai", korName: "학개", chapters: 2, versesPerChapter: [15,23]))
        chapterList.append(BibleVOM(engName: "Zechariah", korName: "스가랴", chapters: 14, versesPerChapter: [17,17,10,14,11,15,14,23,17,12,17,14,9,21]))
        chapterList.append(BibleVOM(engName: "Malachi", korName: "말라기", chapters: 4, versesPerChapter: [14,17,18,6]))
        
        chapterList.append(BibleVOM(engName: "Matthew", korName: "마태복음", chapters: 28, versesPerChapter: [25,23,17,25,48,34,29,34,38,42,30,50,58,36,39,28,27,35,30,34,46,46,39,51,46,75,66,20]))
        chapterList.append(BibleVOM(engName: "Mark", korName: "마가복음", chapters: 16, versesPerChapter: [45,28,35,41,43,56,37,38,50,52,33,44,37,72,47,20]))
        chapterList.append(BibleVOM(engName: "Luke", korName: "누가복음", chapters: 24, versesPerChapter: [80,52,38,44,39,49,50,56,62,42,54,59,35,35,32,31,37,43,48,47,38,71,56,53]))
        chapterList.append(BibleVOM(engName: "John", korName: "요한복음", chapters: 21, versesPerChapter: [51,25,36,54,47,71,53,59,41,42,57,50,38,31,27,33,26,40,42,31,25]))
        chapterList.append(BibleVOM(engName: "Acts", korName: "사도행전", chapters: 28, versesPerChapter: [26,47,26,37,42,15,60,40,43,48,30,25,52,28,41,40,34,28,41,38,40,30,35,27,27,32,44,31]))
        chapterList.append(BibleVOM(engName: "Romans", korName: "로마서", chapters: 16, versesPerChapter: [32,29,31,25,21,23,25,39,33,21,36,21,14,23,33,27]))
        chapterList.append(BibleVOM(engName: "1 Corinthians", korName: "고린도전서", chapters: 16, versesPerChapter: [31,16,23,21,13,20,40,13,27,33,34,31,13,40,58,24]))
        chapterList.append(BibleVOM(engName: "2 Corinthians", korName: "고린도후서", chapters: 13, versesPerChapter: [24,17,18,18,21,18,16,24,15,18,33,21,13]))
        chapterList.append(BibleVOM(engName: "Galatians", korName: "갈라디아서", chapters: 6, versesPerChapter: [24,21,29,31,26,18]))
        chapterList.append(BibleVOM(engName: "Ephesians", korName: "에베소서", chapters: 6, versesPerChapter: [23,22,21,32,33,24]))
        chapterList.append(BibleVOM(engName: "Philippians", korName: "빌립보서", chapters: 4, versesPerChapter: [30,30,21,23]))
        chapterList.append(BibleVOM(engName: "Colossians", korName: "골로새서", chapters: 4, versesPerChapter: [29,23,25,18]))
        chapterList.append(BibleVOM(engName: "1 Thessalonians", korName: "데살로니가전서", chapters: 5, versesPerChapter: [10,20,13,18,28]))
        chapterList.append(BibleVOM(engName: "2 Thessalonians", korName: "데살로니가후서", chapters: 3, versesPerChapter: [12,17,18]))
        chapterList.append(BibleVOM(engName: "1 Timothy", korName: "디모데전서", chapters: 6, versesPerChapter: [20,15,16,16,25,21]))
        chapterList.append(BibleVOM(engName: "2 Timothy", korName: "디모데후서", chapters: 4, versesPerChapter: [18,26,17,22]))
        chapterList.append(BibleVOM(engName: "Titus", korName: "디도서", chapters: 3, versesPerChapter: [16,15,15]))
        chapterList.append(BibleVOM(engName: "Philemon", korName: "빌레몬서", chapters: 1, versesPerChapter: [25]))
        chapterList.append(BibleVOM(engName: "Hebrews", korName: "히브리서", chapters: 13, versesPerChapter: [14,18,19,16,14,20,28,13,28,39,40,29,25]))
        chapterList.append(BibleVOM(engName: "James", korName: "야고보서", chapters: 5, versesPerChapter: [27,26,18,17,20]))
        chapterList.append(BibleVOM(engName: "1 Peter", korName: "베드로전서", chapters: 5, versesPerChapter: [25,25,22,19,14]))
        chapterList.append(BibleVOM(engName: "2 Peter", korName: "베드로후서", chapters: 3, versesPerChapter: [21,22,18]))
        chapterList.append(BibleVOM(engName: "1 John", korName: "요한1서", chapters: 5, versesPerChapter: [10,29,24,21,21]))
        chapterList.append(BibleVOM(engName: "2 John", korName: "요한2서", chapters: 1, versesPerChapter: [13]))
        chapterList.append(BibleVOM(engName: "3 John", korName: "요한3서", chapters: 1, versesPerChapter: [15]))
        chapterList.append(BibleVOM(engName: "Jude", korName: "유다서", chapters: 1, versesPerChapter: [25]))
        chapterList.append(BibleVOM(engName: "Revelation", korName: "요한계시록", chapters: 22, versesPerChapter: [20,29,22,11,14,17,17,13,21,11,19,17,18,20,8,21,18,24,21,15,27,21]))
        return chapterList
    }
}
