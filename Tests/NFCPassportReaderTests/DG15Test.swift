//
//  DG15Test.swift
//  NFCPassportReader
//
//  Created by Josh Everett on 17/03/2025.
//

import XCTest
import NFCPassportReader
import Foundation


extension Data {
    init?(hex: String) {
        let len = hex.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hex.index(hex.startIndex, offsetBy: i * 2)
            let k = hex.index(j, offsetBy: 2)
            let bytes = hex[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data


    }
}


final class DG15Test: XCTestCase {
    var reader: PassportReader!

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.reader = PassportReader() // Initialize reader here
    }


    func testShouldUseExtendedMode() {
           let testCases: [(hexString: String, expectedResult: Bool)] = [
               // EC Keys - should be false
               ("305A301406072A8648CE3D020106092B2403030212", false),
               ("308201133081D406072A8648CE3D02013081C80218", false),
               ("308201753082011D06072A8648CE3D020130820120", false),


               // RSA Keys - short, should be false
               ("30819D300B06092A864886F70D01010103818D0014", false),
               ("30819F300D06092A864886F70D0101010500038114", false),


               // Australian DG15:
               ("6f82012630820122300d06092a864886f70d01010105000382010f003082010a0282010100bede12e84332c82e9aa9c5e200011190dd3278985633b04ddedd8615f5757b8543e2b7267e6287e910d51a1f0f6ba7d78599cbb87a2543e7e1db7bc8815fd23bfb6084d0243ea66cd4b38050707ebf4848b9419092506d3d833335271b34c2a0c8b0cf955001317a2aa857dd13aa539298eef98c030d182d6678ca2ffe59208ae41e29396bc70ffe3c06c8b2790cbbbbb934cb097fc6660ac8c3cd3c71502d72e9df2c14e466714f982d736ea5c21fd3b28f168e13cb35cd7837cbb22876f60860a8be1e5da28265ab6cccb6a01f63adb70bd4e3d837540772fec47188ca65d86784700223e7ecf954309601556dc646566198b0d9a9a70aea5552c3feed89cb0203010001", true),


               // Czech DG15
               ("6F82012630820122300D06092A864886F70D01010105000382010F003082010A0282010100EEF85FA42DE38D42E43BA69001F2D4FF98150E3C967F8CEBD3D5128724C5151E91FB6A407E2E39ADDB05BDAB730FFF92F5910DB825C1BA858FCC1FBBFF223F42F3D3E84AEE0365A2728E15937D7250E46F0D38634CD7E5B694F61CC812178B7857BE876800795E1DB12D7E1EEDB0E685D177D3390B4778F608CB14CEB79DC8893FD12E2C4FE26649418D25B01F377AECF05E136E07E90417B2FC20A62F5C711BC75569454DDE3F40A458C189E6333621849DC0A970125043D276B8AF44E4ACD5FDBB2676A9E9C1FC3339BC1B8A3E50595947552BFF10446B6664580C976B1E8BCB416F2C4C5D24940BBBDC6CCD05F85B5A72B29B0217851463B6E9D4ADCF79570203010001", true),


               // Another that we know we shouldn't have extended mode on for
               ("6f82023c30820238308201af06072a8648ce3d0201308201a2020101304c06072a8648ce3d0101024100aadd9db8dbe9c48b3fd4e6ae33c9fc07cb308db3b3c9d20ed6639cca703308717d4d9b009bc66842aecda12ae6a380e62881ff2f2d82c68528aa6056583a48f330818404407830a3318b603b89e2327145ac234cc594cbdd8d3df91610a83441caea9863bc2ded5d5aa8253aa10a2ef1c98b9ac8b57f1117a72bf2c7b9e7c1ac4d77fc94ca04403df91610a83441caea9863bc2ded5d5aa8253aa10a2ef1c98b9ac8b57f1117a72bf2c7b9e7c1ac4d77fc94cadc083e67984050b75ebae5dd2809bd638016f7230481810481aee4bdd82ed9645a21322e9c4c6a9385ed9f70b5d916c1b43b62eef4d0098eff3b1f78e2d0d48d50d1687b93b97d5f7c6d5047406a5e688b352209bcb9f8227dde385d566332ecc0eabfa9cf7822fdf209f70024a57b1aa000c55b881f8111b2dcde494a5f485e5bca4bd88a2763aed1ca2b2fa8f0540678cd1e0f3ad80892024100aadd9db8dbe9c48b3fd4e6ae33c9fc07cb308db3b3c9d20ed6639cca70330870553e5c414ca92619418661197fac10471db1d381085ddaddb58796829ca9006902010103818200046717b9969d2db558c01623093dcaa4840833031b0f895b18b9dc78fcc5893466b5d141b687ddede68b086269b1c568a835397a4086a33a346ee811ddf58767495ab1d65f9156636f1ab003b4813029b6c73bd2a9b82d7ec73c2e1ec4fb3568fc02009ef94ae4b2c3a413f699a6c38cf532269fc25dfab11b48014256b1a43fd6", false),


               // Invalid - should be false
               ("1234567890", false), // Too short
               ("30819D300B0609ABCDEF01010103818D0014", false), // Invalid identifier
               ("2A864886F70D010101", false), // Only identifier, too short
           ]

           for testCase in testCases {
               let result = reader.shouldUseExtendedMode(for: Data(hex:testCase.hexString)!)
               XCTAssertEqual(result, testCase.expectedResult, "Failed for \(testCase.hexString). Expected \(testCase.expectedResult), got \(result)")
           }

          print("All tests passed.")
       }
}
