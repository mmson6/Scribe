//
//  ScriptForPopulation.swift
//  Scribe
//
//  Created by Mikael Son on 11/21/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import Foundation
/*
private func populateContats() {
    let ctd: [[String: Any]] =  [
        [
            "nameKor": "안명숙",
            "nameEng": "Myungsook Ahn",
            "phone": "8476368041",
            "address":
                [
                    "addressLine": "10373 Dearlove Road #3E",
                    "city": "Glenview",
                    "state": "IL",
                    "zipCode": "60025"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "백중현",
            "nameEng": "John Baek",
            "phone": "6309949989",
            "address":
                [
                    "addressLine": "23801 Tallgrass Drive",
                    "city": "Plainfield",
                    "state": "IL",
                    "zipCode": "60658"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "김경민",
            "nameEng": "Ace Bowling",
            "phone": "8478262343",
            "address":
                [
                    "addressLine": "265 Washington Boulevard",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "",
            "nameEng": "Ryan Bowling",
            "phone": "8478264755",
            "address":
                [
                    "addressLine": "265 Washington Boulevard",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "변영희",
            "nameEng": "Younghee Byun",
            "phone": "2246228329",
            "address":
                [
                    "addressLine": "1509 Summerhill Lane",
                    "city": "Cary",
                    "state": "IL",
                    "zipCode": "60013"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "장혜숙",
            "nameEng": "Hazel Chang",
            "phone": "6308809345",
            "address":
                [
                    "addressLine": "2426 North Kennicott Drive #2B",
                    "city": "Arlington Heights",
                    "state": "IL",
                    "zipCode": "60004"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "지시현",
            "nameEng": "Anna Chee",
            "phone": "2244028225",
            "address":
                [
                    "addressLine": "813 West Springfied Avenue APT 101",
                    "city": "Urbana",
                    "state": "IL",
                    "zipCode": "61801"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "조윤아",
            "nameEng": "Abigail Cho",
            "phone": "",
            "address":
                [
                    "addressLine": "2521 Brockton Circle",
                    "city": "Naperville",
                    "state": "IL",
                    "zipCode": "60565"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "조담현",
            "nameEng": "Daniel Cho",
            "phone": "2246121310",
            "address":
                [
                    "addressLine": "22912 North Wood Court",
                    "city": "Kildeer",
                    "state": "IL",
                    "zipCode": "60047"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "조중철",
            "nameEng": "Joongchul Cho",
            "phone": "6167100035",
            "address":
                [
                    "addressLine": "2678 Atwater Hills Drive NE",
                    "city": "Grand Rapids",
                    "state": "MI",
                    "zipCode": "49525"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "조현암",
            "nameEng": "Justin Cho",
            "phone": "7737159388",
            "address":
                [
                    "addressLine": "2521 Brockton Circle",
                    "city": "Naperville",
                    "state": "IL",
                    "zipCode": "60565"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "조현주",
            "nameEng": "Linda Cho",
            "phone": "8475305777",
            "address":
                [
                    "addressLine": "1240 Evergreen Avenue",
                    "city": "Des Plaines",
                    "state": "IL",
                    "zipCode": "60016"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "조윤성",
            "nameEng": "Matthew Cho",
            "phone": "",
            "address":
                [
                    "addressLine": "2521 Brockton Circle",
                    "city": "Naperville",
                    "state": "IL",
                    "zipCode": "60565"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "조미애",
            "nameEng": "Miae Cho",
            "phone": "6166335753",
            "address":
                [
                    "addressLine": "2678 Atwater Hills Drive NE",
                    "city": "Grand Rapids",
                    "state": "MI",
                    "zipCode": "49525"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "조준희",
            "nameEng": "Mike Cho",
            "phone": "6302340640",
            "address":
                [
                    "addressLine": "2426 North Kennicott Drive #2B",
                    "city": "Arlington Heights",
                    "state": "IL",
                    "zipCode": "60004"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "조미리암",
            "nameEng": "Miriam Cho",
            "phone": "7737159399",
            "address":
                [
                    "addressLine": "2521 Brockton Circle",
                    "city": "Naperville",
                    "state": "IL",
                    "zipCode": "60565"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "조윤호",
            "nameEng": "Nathan Cho",
            "phone": "",
            "address":
                [
                    "addressLine": "2521 Brockton Circle",
                    "city": "Naperville",
                    "state": "IL",
                    "zipCode": "60565"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "조선순",
            "nameEng": "Seonsoon Cho",
            "phone": "3122086828",
            "address":
                [
                    "addressLine": "5601 North Kolmar Avenue",
                    "city": "Chicago,",
                    "state": "L ",
                    "zipCode": "0646 "
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "조수지",
            "nameEng": "Suji Cho",
            "phone": "",
            "address":
                [
                    "addressLine": "610 Lakeridge Court",
                    "city": "Naperville",
                    "state": "IL",
                    "zipCode": "60563"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "조영환",
            "nameEng": "Yonghwan Cho",
            "phone": "7736996154",
            "address":
                [
                    "addressLine": "610 Lakeridge Court",
                    "city": "Naperville",
                    "state": "IL",
                    "zipCode": "60563"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "최규민",
            "nameEng": "Andrew Choi",
            "phone": "2246221285",
            "address":
                [
                    "addressLine": "750 River Mill Parkway",
                    "city": "Wheeling",
                    "state": "IL",
                    "zipCode": "60090"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "최계숙",
            "nameEng": "Gyesook Choi",
            "phone": "2246168739",
            "address":
                [
                    "addressLine": "75 Kristin Circle",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60195"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "최현아",
            "nameEng": "Kelsey Choi",
            "phone": "2246596903",
            "address":
                [
                    "addressLine": "813 West Springfied Avenue Apt 101",
                    "city": "Urbana",
                    "state": "IL",
                    "zipCode": "61801"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "최순효",
            "nameEng": "Soonhyo Choi",
            "phone": "8477075863",
            "address":
                [
                    "addressLine": "8518 Avers Avenue",
                    "city": "Skokie",
                    "state": "IL",
                    "zipCode": "60076"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "임주영",
            "nameEng": "Ezra Freeman",
            "phone": "",
            "address":
                [
                    "addressLine": "16 North Allen Street",
                    "city": "Madison",
                    "state": "WI",
                    "zipCode": "53726"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "임주은",
            "nameEng": "Joon Freeman",
            "phone": "6085125135",
            "address":
                [
                    "addressLine": "16 North Allen Street",
                    "city": "Madison",
                    "state": "WI",
                    "zipCode": "53726"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "",
            "nameEng": "Dashka Ganzorig",
            "phone": "3129786997",
            "address":
                [
                    "addressLine": "6758 North Sheridan Road Apt 445",
                    "city": "Chicago",
                    "state": "IL",
                    "zipCode": "60626"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "한승연",
            "nameEng": "Stacy Han",
            "phone": "6184200966",
            "address":
                [
                    "addressLine": "1136 South Delano Court",
                    "city": "Chicago",
                    "state": "IL",
                    "zipCode": "60605"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "홍봉권",
            "nameEng": "Bongkwon Hong",
            "phone": "7738188744",
            "address":
                [
                    "addressLine": "175 Carey Trail",
                    "city": "Wood Dale",
                    "state": "IL",
                    "zipCode": "60191"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "홍승희",
            "nameEng": "Seunghee Hong",
            "phone": "7738185924",
            "address":
                [
                    "addressLine": "175 Carey Trail",
                    "city": "Wood Dale",
                    "state": "IL",
                    "zipCode": "60191"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "정미경",
            "nameEng": "Mi Jeong",
            "phone": "7025105769",
            "address":
                [
                    "addressLine": "1719 Northfield Square Unit F",
                    "city": "Winnetka",
                    "state": "IL",
                    "zipCode": "60093"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "정혜윤",
            "nameEng": "Eunice Jung",
            "phone": "5866650193",
            "address":
                [
                    "addressLine": "352 Arquilla Court",
                    "city": "Bloomingdale",
                    "state": "IL",
                    "zipCode": "60108"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": false,
            "translator": true,
            "district": "31"
        ],
        [
            "nameKor": "강정한",
            "nameEng": "Daniel Kang",
            "phone": "8475054551",
            "address":
                [
                    "addressLine": "7 North Waterford Drive",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60194"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "김지유",
            "nameEng": "Annika Kim",
            "phone": "6309917858",
            "address":
                [
                    "addressLine": "1096 Viewpoint Drive",
                    "city": "Lake in the Hills",
                    "state": "IL",
                    "zipCode": "60156"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "김수빈",
            "nameEng": "Ava Kim",
            "phone": "",
            "address":
                [
                    "addressLine": "1240 Richfield Court",
                    "city": "Woodbridge",
                    "state": "IL",
                    "zipCode": "60517"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "김하람",
            "nameEng": "Caleb Kim",
            "phone": "",
            "address":
                [
                    "addressLine": "1240 Richfield Court",
                    "city": "Woodbridge",
                    "state": "IL",
                    "zipCode": "60517"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "김등자",
            "nameEng": "Deungja Kim",
            "phone": "2244367651",
            "address":
                [
                    "addressLine": "551 West Huntington Commons Road APT 323B",
                    "city": "Mount Prospect",
                    "state": "IL",
                    "zipCode": "60056"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "김건우",
            "nameEng": "Gunwoo Kim",
            "phone": "6302905173",
            "address":
                [
                    "addressLine": "1096 Viewpoint Drive",
                    "city": "Lake in the Hills",
                    "state": "IL",
                    "zipCode": "60156"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "김향자",
            "nameEng": "Hyangja Kim",
            "phone": "8476304681",
            "address":
                [
                    "addressLine": "7 North Waterford Drive",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60194"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "김현아",
            "nameEng": "Hyuna Kim",
            "phone": "6303791817",
            "address":
                [
                    "addressLine": "1240 Richfield Court",
                    "city": "Woodbridge",
                    "state": "IL",
                    "zipCode": "60517"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "김일현",
            "nameEng": "Jacob Kim",
            "phone": "",
            "address":
                [
                    "addressLine": "1240 Richfield Court",
                    "city": "Woodbridge",
                    "state": "IL",
                    "zipCode": "60517"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "김재우",
            "nameEng": "Jae Woo Kim",
            "phone": "8472265919",
            "address":
                [
                    "addressLine": "81 Mark Drive",
                    "city": "Hawthorn Woods",
                    "state": "IL",
                    "zipCode": "60047"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "김경준",
            "nameEng": "Joseph Kim",
            "phone": "8477040092",
            "address":
                [
                    "addressLine": "7 North Waterford Drive",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60194"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "김정은",
            "nameEng": "JeongEun Kim",
            "phone": "3317710999",
            "address":
                [
                    "addressLine": "507 Yosemite Trail",
                    "city": "Roselle",
                    "state": "IL",
                    "zipCode": "60172"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": true,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "김기업",
            "nameEng": "Ki E.  Kim",
            "phone": "8473392708",
            "address":
                [
                    "addressLine": "81 Mark Drive",
                    "city": "Hawthorn Woods",
                    "state": "IL",
                    "zipCode": "60047"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "김미진",
            "nameEng": "Mijin Kim",
            "phone": "6184205964",
            "address":
                [
                    "addressLine": "220 Bradley Lane",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "김민영",
            "nameEng": "Minyoung Kim",
            "phone": "3122737177",
            "address":
                [
                    "addressLine": "366 Juniper Tree Court",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "김남진",
            "nameEng": "Namjin Kim",
            "phone": "2242100354",
            "address":
                [
                    "addressLine": "7 North Waterford Drive",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60194"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "김민식",
            "nameEng": "Paul Kim",
            "phone": "7082681116",
            "address":
                [
                    "addressLine": "13749 Santa Fe Trail",
                    "city": "Orland Park,",
                    "state": "L ",
                    "zipCode": "0467 "
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "김승준",
            "nameEng": "Paul Kim",
            "phone": "8477040972",
            "address":
                [
                    "addressLine": "32 Kristin Circle APT 3",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60195"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": true,
            "district": "21"
        ],
        [
            "nameKor": "김범준",
            "nameEng": "Roy Kim",
            "phone": "8477040687",
            "address":
                [
                    "addressLine": "352 Arquilla Court",
                    "city": "Bloomingdale",
                    "state": "IL",
                    "zipCode": "60108"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": true,
            "translator": true,
            "district": "31"
        ],
        [
            "nameKor": "김우일",
            "nameEng": "Woo Kim",
            "phone": "2245229570",
            "address":
                [
                    "addressLine": "1240 Richfield Court",
                    "city": "Woodbridge",
                    "state": "IL",
                    "zipCode": "60517"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "구지훈",
            "nameEng": "Josh Koo",
            "phone": "8479028704",
            "address":
                [
                    "addressLine": "1919 Prairie Square APT # 310",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60173"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "구경선",
            "nameEng": "Kyungsun Koo",
            "phone": "2174180211",
            "address":
                [
                    "addressLine": "1919 Prairie Square APT # 310",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60173"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "권신영",
            "nameEng": "Daniel Kweon",
            "phone": "8473459141",
            "address":
                [
                    "addressLine": "220 Bradley Lane",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "권대영",
            "nameEng": "David Kweon",
            "phone": "",
            "address":
                [
                    "addressLine": "220 Bradley Lane",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "권종안",
            "nameEng": "Jong An Kweon",
            "phone": "3147199797",
            "address":
                [
                    "addressLine": "220 Bradley Lane",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "권채영",
            "nameEng": "Michelle Kweon",
            "phone": "8473459813",
            "address":
                [
                    "addressLine": "220 Bradley Lane",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "권영옥",
            "nameEng": "Youngok Kwon",
            "phone": "2172208341",
            "address":
                [
                    "addressLine": "7720 Beckwith Road",
                    "city": "Morton Grove",
                    "state": "IL",
                    "zipCode": "60053"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "이안나",
            "nameEng": "Anna Lee",
            "phone": "8479626850",
            "address":
                [
                    "addressLine": "522 East Algonquin Road #201",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60173"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "이민서",
            "nameEng": "Caleb Lee",
            "phone": "",
            "address":
                [
                    "addressLine": "522 East Algonquin Road #201",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60173"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "이형섭",
            "nameEng": "Daniel Lee",
            "phone": "7188773775",
            "address": "",
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "이영민",
            "nameEng": "David Lee",
            "phone": "7087383608",
            "address":
                [
                    "addressLine": "522 East Algonquin Road #201",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60173"
            ],
            "group": "Fathers",
            "teacher": true,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "이혜정",
            "nameEng": "Hyejung Lee",
            "phone": "2245959888",
            "address":
                [
                    "addressLine": "554 East Windgate Court",
                    "city": "Alington Heights",
                    "state": "IL",
                    "zipCode": "62205"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "이준서",
            "nameEng": "Joshua Lee",
            "phone": "",
            "address":
                [
                    "addressLine": "522 East Algonquin Road #201",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60173"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "이옥순",
            "nameEng": "Oksoon Lee",
            "phone": "6303607010",
            "address":
                [
                    "addressLine": "610 Lakeridge Court",
                    "city": "Naperville",
                    "state": "IL",
                    "zipCode": "60563"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "이선영",
            "nameEng": "Sunny Lee",
            "phone": "2245485121",
            "address":
                [
                    "addressLine": "10365 Dearlove Road #2F",
                    "city": "Glenview",
                    "state": "IL",
                    "zipCode": "60025"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "이원주",
            "nameEng": "Wonju Lee",
            "phone": "6308850117",
            "address":
                [
                    "addressLine": "1096 Viewpoint Drive",
                    "city": "Lake in the Hills",
                    "state": "IL",
                    "zipCode": "60156"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "이우인",
            "nameEng": "Wooin Lee",
            "phone": "8474144498",
            "address":
                [
                    "addressLine": "32 Kristin Circle APT 3",
                    "city": "Schaumburg",
                    "state": "IL",
                    "zipCode": "60195"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "이유리",
            "nameEng": "Yuri Lee",
            "phone": "8477218112",
            "address":
                [
                    "addressLine": "500 West Huntington Commons Road",
                    "city": "Mount Prospect",
                    "state": "IL",
                    "zipCode": "60056"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "임해인",
            "nameEng": "Ann Lim",
            "phone": "2242420296",
            "address":
                [
                    "addressLine": "3587 Edgewood Lane",
                    "city": "Carpentersville",
                    "state": "IL",
                    "zipCode": "60110"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "임복규",
            "nameEng": "Bokgyu Lim",
            "phone": "2246224089",
            "address":
                [
                    "addressLine": "3587 Edgewood Lane",
                    "city": "Carpentersville",
                    "state": "IL",
                    "zipCode": "60110"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "임도엽",
            "nameEng": "Doyup Lim",
            "phone": "7654218210",
            "address":
                [
                    "addressLine": "430 Wood Street Room 1304",
                    "city": "West Lafayette,",
                    "state": "N ",
                    "zipCode": "47906"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": true,
            "district": "31"
        ],
        [
            "nameKor": "임강호",
            "nameEng": "Kangho Lim",
            "phone": "2246224091",
            "address":
                [
                    "addressLine": "3587 Edgewood Lane",
                    "city": "Carpentersville",
                    "state": "IL",
                    "zipCode": "60110"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "남아린",
            "nameEng": "Irene Nam",
            "phone": "7028089566",
            "address":
                [
                    "addressLine": "1719 Northfield Square Unit F",
                    "city": "Winnetka",
                    "state": "IL",
                    "zipCode": "60093"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "남채린",
            "nameEng": "Nicole Nam",
            "phone": "7028601298",
            "address":
                [
                    "addressLine": "1719 Northfield Square Unit F",
                    "city": "Winnetka",
                    "state": "IL",
                    "zipCode": "60093"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "남승범",
            "nameEng": "Seung Nam",
            "phone": "7025876131",
            "address":
                [
                    "addressLine": "1719 Northfield Square Unit F",
                    "city": "Winnetka",
                    "state": "IL",
                    "zipCode": "60093"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "박근일",
            "nameEng": "Daniel Park",
            "phone": "8479421141",
            "address":
                [
                    "addressLine": "366 Juniper Tree Court",
                    "city": "Hoffman Estates",
                    "state": "IL",
                    "zipCode": "60169"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": true,
            "district": "21"
        ],
        [
            "nameKor": "박은희",
            "nameEng": "Eunhee Park",
            "phone": "7795371585",
            "address":
                [
                    "addressLine": "12974 White School  Road",
                    "city": " Roscoe",
                    "state": "IL",
                    "zipCode": "61073"
            ],
            "group": "Mothers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "박지윤",
            "nameEng": "Hailey Park",
            "phone": "",
            "address":
                [
                    "addressLine": "554 East Windgate Court",
                    "city": "Alington Heights",
                    "state": "IL",
                    "zipCode": "62205"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "박지혜",
            "nameEng": "Irene Park",
            "phone": "2244259623",
            "address":
                [
                    "addressLine": "554 East Windgate Court",
                    "city": "Alington Heights",
                    "state": "IL",
                    "zipCode": "62205"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "박지수",
            "nameEng": "Iris Park",
            "phone": "2247350508",
            "address":
                [
                    "addressLine": "554 East Windgate Court",
                    "city": "Alington Heights",
                    "state": "IL",
                    "zipCode": "62205"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "박상민",
            "nameEng": "Joel Park",
            "phone": "2245008247",
            "address":
                [
                    "addressLine": "10365 Dearlove Road #2F",
                    "city": "Glenview",
                    "state": "IL",
                    "zipCode": "60025"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "",
            "nameEng": "Joseph Park",
            "phone": "8474148068",
            "address":
                [
                    "addressLine": "1237 Huber Lane",
                    "city": "Glenview",
                    "state": "IL",
                    "zipCode": "60025"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "31"
        ],
        [
            "nameKor": "박정환",
            "nameEng": "Justin Park",
            "phone": "8472085392",
            "address":
                [
                    "addressLine": "554 East Windgate Court",
                    "city": "Alington Heights",
                    "state": "IL",
                    "zipCode": "62205"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "박예찬",
            "nameEng": "Samuel Park",
            "phone": "",
            "address":
                [
                    "addressLine": "10365 Dearlove Road #2F",
                    "city": "Glenview",
                    "state": "IL",
                    "zipCode": "60025"
            ],
            "group": "Church School",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "박근아",
            "nameEng": "Sharon Park",
            "phone": "8475296723",
            "address":
                [
                    "addressLine": "2 East Oak  Street Unit 1707",
                    "city": "Chicago",
                    "state": "IL",
                    "zipCode": "60611"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": true,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "노하얀",
            "nameEng": "Elisha Ro",
            "phone": "2243242115",
            "address":
                [
                    "addressLine": "1208 West Lexington Street APT 1R",
                    "city": "Chicago",
                    "state": "IL",
                    "zipCode": "60607"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "노유리",
            "nameEng": "Elizabeth Ro",
            "phone": "2247308849",
            "address":
                [
                    "addressLine": "1208 West Lexington Street APT 1R",
                    "city": "Chicago",
                    "state": "IL",
                    "zipCode": "60607"
            ],
            "group": "Young Adults",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "류소이",
            "nameEng": "Sophia Ryoo",
            "phone": "3124598020",
            "address":
                [
                    "addressLine": "1096 Viewpoint Drive",
                    "city": "Lake in the Hills",
                    "state": "IL",
                    "zipCode": "60156"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": false,
            "district": "21"
        ],
        [
            "nameKor": "심윤정",
            "nameEng": "Yoon Shim",
            "phone": "8477693486",
            "address":
                [
                    "addressLine": "828 Miller Street #2R",
                    "city": "Chicago",
                    "state": "IL",
                    "zipCode": "60607"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "신병근",
            "nameEng": "Dave Shin",
            "phone": "3126478457",
            "address":
                [
                    "addressLine": "7720 Beckwith Road",
                    "city": "Morton Grove",
                    "state": "IL",
                    "zipCode": "60053"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "신승호",
            "nameEng": "Seungho Shin",
            "phone": "3126478452",
            "address":
                [
                    "addressLine": "7720 Beckwith Road",
                    "city": "Morton Grove",
                    "state": "IL",
                    "zipCode": "60053"
            ],
            "group": "Fathers",
            "teacher": false,
            "choir": false,
            "translator": false,
            "district": "11"
        ],
        [
            "nameKor": "손정우",
            "nameEng": "Mikael Son",
            "phone": "6189772661",
            "address":
                [
                    "addressLine": "507 Yosemite Trail",
                    "city": "Roselle",
                    "state": "IL",
                    "zipCode": "60172"
            ],
            "group": "Young Adults",
            "teacher": true,
            "choir": true,
            "translator": true,
            "district": "21"
        ]
    ]
    
    let ref = Database.database().reference(fromURL: AppConfiguration.baseURL)
    
    for (_, object) in ctd.enumerated() {
        print("hahaha")
        let key = ref.child(contactsChicago).childByAutoId().key
        let storeRef = ref.child(contactsChicago).child("contacts").child(key)
        var storeObj = object
        storeObj["contactId"] = key
        storeRef.updateChildValues(storeObj)
    }
}
*/
