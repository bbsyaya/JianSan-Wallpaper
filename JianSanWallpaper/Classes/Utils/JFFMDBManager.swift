//
//  JFFMDBManager.swift
//  JianSanWallpaper
//
//  Created by zhoujianfeng on 16/4/29.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFFMDBManager: NSObject {
    
    /// 单例对象
    static let sharedManager = JFFMDBManager()
    
    /// sqlite名称
    private let dbName = "star.db"
    
    /// 收藏表
    private let tbName = "jf_star"
    
    let dbQueue: FMDatabaseQueue
    
    typealias QueryStarFinished = (result: [[String : AnyObject]]?) -> ()
    
    override init() {
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let dbPath = "\(documentPath)/\(dbName)"
        dbQueue = FMDatabaseQueue(path: dbPath)
        super.init()
        
        // 创建收藏表
        createStarTable()
    }
    
    /**
     创建收藏表
     */
    private func createStarTable() {
        let sql = "CREATE TABLE IF NOT EXISTS \(tbName) (" +
        "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT," +
        "path VARCHAR(80) NOT NULL" +
        ");"
        
        dbQueue.inDatabase { (db) in
            do {
               try db.executeUpdate(sql)
            } catch {
                print("建表失败")
            }
            
        }
    }
    
    /**
     插入收藏壁纸
     
     - parameter path:     收藏的壁纸路径
     */
    func insertStar(path: String) -> Void {
        let sql = "INSERT INTO \(tbName) (path) VALUES (\"\(path)\");"
        
        dbQueue.inDatabase { (db) in
            do {
                try db.executeUpdate(sql)
            } catch {
                print("插入数据失败")
            }
        }
        
    }
    
    /**
     获取收藏的壁纸
     
     - parameter currentPage:  当前页
     - parameter onePageCount: 每页数量
     - parameter finished:     完成回调
     */
    func getStarWallpaper(currentPage: Int, onePageCount: Int, finished: QueryStarFinished) -> Void {
        
        let pre_count = (currentPage - 1) * onePageCount
        let oneCount = onePageCount
        let sql = "SELECT * FROM \(tbName) LIMIT \(pre_count), \(oneCount);"
        
        dbQueue.inDatabase { (db) in
            do {
                let result = try db.executeQuery(sql)
                
                if result.columnCount() == 0 { // 没有数据了
                    finished(result: nil)
                } else {
                    var datas = [[String : AnyObject]]()
                    while result.next() {
                        let id = result.intForColumn("id")
                        let path = result.stringForColumn("path")
                        
                        datas.append(["id" : Int(id)])
                        datas.append(["path" : path])
                    }
                    finished(result: datas)
                }
                
            } catch {
                finished(result: nil)
            }
        }
        
    }
    
    /**
     移除指定壁纸
     
     - parameter id: 本地数据库壁纸id
     */
    func removeOneStarWallpaper(id: Int) -> Void {
        let sql = "DELETE FROM \(tbName) WHERE id = \(id)"
        
        dbQueue.inDatabase { (db) in
            do {
                try db.executeUpdate(sql)
            } catch {
                print("移除失败")
            }
        }
    }
    
    /**
     移除所有壁纸
     */
    func removeAllStarWallpapaer() -> Void {
        let sql = "truncate \(tbName);"
        
        dbQueue.inDatabase { (db) in
            do {
                try db.executeUpdate(sql)
            } catch {
                print("清空失败")
            }
        }
    }
    
    
}