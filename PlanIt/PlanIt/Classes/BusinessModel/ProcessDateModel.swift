
//
//  ProcessDateModel.swift
//  PlanIt
//
//  Created by Ken on 16/5/29.
//  Copyright © 2016年 Ken. All rights reserved.
//

import Foundation
//ProcessDateModel
class ProcessDate: NSObject {
    ///进度序号
    var id: Int = -1
    
    ///项目序号
    var projectID: Int = -1
    
    ///记录时间
    var recordTime = ""
    
    ///显示记录时间
    var recordTimeShow = ""
    
    ///完成工作量
    var done: Double = -1
    
    ///记录时间
    var recordTimeDate = Date()
    
    //2016年11月
    var month = ""
    
    //2016年11月第1周
    var week = ""
    
    //5日11点12分
    var day = ""
    
    override init() {
        super.init()
    }
    
    init(dict : [String : AnyObject]) {
        super.init()
        //setValuesForKeysWithDictionary(dict)
        id = dict["id"]!.intValue
        recordTime = String(describing: dict["recordTime"]!)
        projectID = dict["projectID"]!.intValue
        done = dict["done"]!.doubleValue
        //TODO: bug found
        recordTimeDate = recordTime.FormatToNSDateYYYYMMMMDDCN()! as Date
        month = recordTimeDate.FormatToStringYYYYMM()
        week = recordTimeDate.FormatToStringYYYY() + "第\(recordTimeDate.getWeekOfYear())周"
        day = recordTimeDate.FormatToStringMMMMDD()
    }
    
    // MARK:- 和数据库之间的操作
    /// 加载关于某项目所有的数据
    func loadData(_ projectID: Int) -> [ProcessDate]{
        var processDates : [ProcessDate] = [ProcessDate]()
        
        // 1.获取查询语句
        let querySQL = "SELECT * FROM t_processdate WHERE projectID = \(projectID);"
        
        // 2.执行查询语句
        guard let array = SQLiteManager.shareIntance.querySQL(querySQL) else {
            print("查询所有processdate数据失败")
            return processDates
        }
        
        // 3.遍历数组
        for dict in array {
            let p = ProcessDate(dict: dict)
            processDates.append(p)
        }
        return processDates
    }
    
    ///检查记录是否存在
    func checkIsExist(_ projectID: Int, timeString: String) -> ProcessDate?{
        // 1.获取查询语句
        let querySQL = "SELECT * FROM t_processdate WHERE projectID = '\(projectID)' AND recordTime = '\(timeString)';"
        
        // 2.执行查询语句
        guard let array = SQLiteManager.shareIntance.querySQL(querySQL) else {
            print("查询ID为\(projectID)的所有processdate数据失败")
            return nil
        }
        
        // 3.遍历数组
        for dict in array {
            let p = ProcessDate(dict: dict)
             return p
        }
        
        return nil
    }

    ///新插入数据
    func insertProcessDate() -> Bool{
        // 1.获取插入的SQL语句
        let insertSQL = "INSERT INTO t_processdate (projectID, recordTime, done) VALUES ('\(projectID)', '\(recordTime)', '\(done)');"
        
        // 2.执行SQL语句
        if SQLiteManager.shareIntance.execSQL(insertSQL) {
            print("插入新进程数据成功")
            return true
        }else{
            print("插入新进程数据失败")
            return false
        }
    }
    
    ///更新数据
    func updateProcessDate() -> Bool{
        
        // 1.获取修改的SQL语句
        let updateSQL = "UPDATE t_processdate SET projectID = '\(projectID)', recordTime = '\(recordTime)', done = '\(done)'WHERE id = '\(id)';"
        
        // 2.执行SQL语句
        if SQLiteManager.shareIntance.execSQL(updateSQL) {
            print("修改进度日期成功")
            return true
        }else{
            print("修改进度日期失败")
            return false
        }
    }
    
    ///改变数据
    func chengeData(_ projectID: Int, timeDate: Date, changeValue: Double){
        let timeString = timeDate.FormatToStringYYYYMMDDCN()
        if let processDate = checkIsExist(projectID, timeString: timeString){
            processDate.done += changeValue
            processDate.updateProcessDate()
        }else{
            let processDate = ProcessDate()
            processDate.projectID = projectID
            processDate.done = changeValue
            processDate.recordTime = timeString
            processDate.insertProcessDate()
        }
    }
}
