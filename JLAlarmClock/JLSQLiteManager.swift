//
//  JLSQLiteManager.swift
//  JLAlarmClock
//
//  Created by JasonLiu on 2018/2/6.
//  Copyright © 2018年 JasonLiu. All rights reserved.
//

import UIKit
import SQLite3

struct JLSQLiteError {
    var code: Int32
    var errmsg: String
}

enum JLSQLiteOrder: String {
    case Asc = "asc"    // 升序
    case Desc = "desc"  // 降序
}

enum JLSQLiteDataType: String {
    case Integer = "integer" // int
    case Real = "real" // float double
    case Text = "text" // char
    case Blob = "blob" // 二进制
}

enum JLSQLiteConstraint: String {
    case Default = "default"
    case NotNull = "not null"       // 非空
    case Unique = "unique"          // 唯一
    case PrimaryKey = "primary key" // 主键
    case AutoPrimaryKey = "primary key autoincrement"   // 自增主键
    case ForeignKey = "foreign key" // 外键
    case Check = "check"            // 检查，确保列中的所有值均满足条件
}

class JLSQLiteManager: NSObject {

    var dbName: String {
        set {
            let realValue = newValue.replacingOccurrences(of: " ", with: "")
            if realValue != "" {
                if realValue.hasSuffix(".sqlite") {
                    _dbName = realValue
                }else {
                    _dbName = "\(realValue).sqlite"
                }
            }
        }
        get {
            return _dbName
        }
    }
    private var _dbName: String = "db.sqlite"
    private var dbBase: OpaquePointer? = nil
    private var dbPath: String {
        get {
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
            let filemgr = FileManager.default
            if !filemgr.fileExists(atPath: path!) {
                do {
                    try filemgr.createDirectory(atPath: path!, withIntermediateDirectories: true, attributes: nil)
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
            return path!.appending(dbName)
        }
    }
    
    static let shared: JLSQLiteManager = {
        let sharedInstance = JLSQLiteManager.init()
        return sharedInstance
    }()
    private override init() {
        super.init()
    }
    
    func open() -> Bool {
        return open(path: dbPath)
    }
    
    func open(name: String) -> Bool {
        dbName = name
        return open(path: dbPath)
    }
    
    func open(path: String) -> Bool {
        if sqlite3_open(path.cString(using: String.Encoding.utf8), &dbBase) != SQLITE_OK {
            return false
        }
        return true
    }
    
    func close() {
        if dbBase != nil {
            sqlite3_close(dbBase)
            dbBase = nil
        }
    }
    
    func createTable(tbName: String, tbColumn: [String: JLSQLiteDataType], tbConstraint: [String: [JLSQLiteConstraint]], block: ((JLSQLiteError?) ->())) {
        var columnString = ""
        // 遍历列名称及其数据类型
        for (column, type) in tbColumn {
            columnString.append("\(column) \(type)")
            // 遍历列约束
            for constraint in tbConstraint[column]! {
                columnString.append(" \(constraint)")
            }
            columnString.append(",")
        }
        columnString.remove(at: columnString.index(before: columnString.endIndex))
        // 复合主键、联合主键
        for (column, constraints) in tbConstraint {
            if column.components(separatedBy: ",").count > 1 {
                for constraint in constraints {
                    if constraint == .PrimaryKey {
                        columnString.append(", \(constraint)(\(column))")
                    }
                }
            }
        }
        let sql = "create table \(tbName)(\(columnString)"
        execSQL(sql: sql) { (error) in
            block(error)
        }
    }
    
    /// 插入数据
    ///
    /// - Parameters:
    ///   - tbName: 表名
    ///   - data: 待插入的数据字典
    ///   - block: 执行结果回调
    func insert(tbName: String, data: [String: Any], block: ((JLSQLiteError?) ->())) {
        var mutKey = ""
        var mutValue = ""
        for (key, value) in data {
            mutKey.append("\(key),")
            mutValue.append("\"\(value)\",")
        }
        mutKey.remove(at: mutKey.index(before: mutKey.endIndex))
        mutValue.remove(at: mutValue.index(before: mutValue.endIndex))
        
        let sql = "insert into \(tbName)(\(mutKey) values(\(mutValue))"
        execSQL(sql: sql) { (error) in
            block(error)
        }
    }
    
    /// 删除数据
    ///
    /// - Parameters:
    ///   - tbName: 表名
    ///   - rowWhere: where子句，规定选择的标准
    ///   - block: 执行结果回调
    func delete(tbName: String, rowWhere: String! = nil, block: ((JLSQLiteError?) ->())) {
        var sql = "delete from \(tbName)"
        if rowWhere != nil {
            sql.append(" where \(rowWhere)")
        }
        execSQL(sql: sql) { (error) in
            block(error)
        }
    }
    
    /// 更新数据
    ///
    /// - Parameters:
    ///   - tbName: 表名
    ///   - data: 待更新的数据字典
    ///   - rowWhere: where子句，规定选择的标准
    ///   - block: 执行结果回调
    func update(tbName: String, data: [String: Any], rowWhere: String! = nil, block: ((JLSQLiteError?) ->())) {
        var sql = "update \(tbName) set "
        for (key, value) in data {
            sql.append("\(key)=\"\(value)\",")
        }
        if data.count > 0 {
            sql.remove(at: sql.index(before: sql.endIndex))
        }
        if rowWhere != nil {
            sql.append(" where \(rowWhere)")
        }
        execSQL(sql: sql) { (error) in
            block(error)
        }
    }
    
    /// 查询数据
    ///
    /// - Parameters:
    ///   - tbName: 表名
    ///   - tbColumns: 指定待查询的列，
    ///   - rowWhere: where子句，规定选择的标准
    ///   - orderBy: 排序列，可以多个: column1,column2
    ///   - oreder: 排序方式，升降序
    ///   - block: 执行结果回调
    func select(tbName: String, tbColumns: [String]! = nil, rowWhere: String! = nil, orderBy: String! = nil, oreder: JLSQLiteOrder = .Asc, block: (([[String: Any]]?, JLSQLiteError?) ->())) {
        var sql = "select * from \(tbName)"
        if tbColumns != nil {
            var columnString = ""
            for column in tbColumns {
                columnString.append("\(column),")
            }
            columnString.remove(at: columnString.index(before: columnString.endIndex))
            sql = "select \(columnString) from \(tbName)"
        }
        if rowWhere != nil {
            sql.append(" where \(rowWhere)")
        }
        if orderBy != nil {
            sql.append(" order by \(orderBy) \(oreder)")
        }
        selectSQL(sql: sql) { (dicts, error) in
            block(dicts, error)
        }
    }
    
    /// 执行非查询sql
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - block: 执行结果回调
    func execSQL(sql: String, block: ((JLSQLiteError?) ->())) {
        let errmsg: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        let code = sqlite3_exec(dbBase, sql.cString(using: String.Encoding.utf8), nil, nil, errmsg)
        if code != SQLITE_OK {
            block(JLSQLiteError(code: code, errmsg: String(describing: errmsg)))
        }else {
            block(nil)
        }
    }
    
    /// 执行查询sql
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - block: 执行结果回调
    func selectSQL(sql: String, block: (([[String: Any]]?, JLSQLiteError?) ->())) {
        
        var dicts = [[String: Any]]()
        var stmt: OpaquePointer? = nil
        let code = sqlite3_prepare_v2(dbBase, sql.cString(using: String.Encoding.utf8), -1, &stmt, nil)
        if code != SQLITE_OK {
            block(dicts, JLSQLiteError(code: code, errmsg: "查询失败，请检查SQL语句"))
        }else {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let count = sqlite3_column_count(stmt)
                var dict = [String : Any]()
                for index in 0..<count {
                    let cName = sqlite3_column_name(stmt, index)
                    let name = String(cString: cName!, encoding: String.Encoding.utf8)!
        
                    let type = sqlite3_column_type(stmt, index)
                    switch type {
                    case SQLITE_INTEGER: // 整形
                        let num = sqlite3_column_int64(stmt, index)
                        dict[name] = Int(num)
                        break
                    case SQLITE_FLOAT: // 浮点型
                        let double = sqlite3_column_double(stmt, index)
                        dict[name] = Double(double)
                        break
                    case SQLITE_BLOB: // 二进制数据
                        let length: Int = Int(sqlite3_column_bytes(stmt, index))
                        let blob = sqlite3_column_blob(stmt, index)
                        dict[name] = Data.init(bytes: blob!, count: length)
                        break
                    case SQLITE_TEXT,SQLITE3_TEXT: // 文本类型
                        let cText = String.init(cString: sqlite3_column_text(stmt, index))
                        let text = String(cString: cText, encoding: String.Encoding.utf8)!
                        dict[name] = text
                        break
                    case SQLITE_NULL: // nil
                        dict[name] = NSNull()
                        break
                    default:
                        break
                    }
                }
                dicts.append(dict)
            }
            sqlite3_finalize(stmt)
            block(dicts, nil)
        }
    }
}
