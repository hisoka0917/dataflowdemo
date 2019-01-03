//
//  ApiManager.swift
//  MVVMExample
//
//  Created by Wang Kai on 2017/8/7.
//  Copyright © 2017年 Pirate. All rights reserved.
//

import UIKit

class ApiManager: NSObject {
    class func getMockData() -> Data? {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            return try? Data.init(contentsOf: URL(fileURLWithPath: path))
        }
        return nil
    }
    
    class func getAsyncMockData(complete: @escaping (_ result: Data) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let data = self.getMockData() {
                complete(data)
            }
        }
    }

    class func asyncLoadData(bookmark: String, complete: @escaping (ListModel) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let data = self.getMockData() {
                if let model = try? JSONDecoder().decode(ListModel.self, from: data)  {
                    complete(model)
                }
            }
        }
    }
    
    class func doAsyncHandler(_ handler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            handler()
        }
    }
}
