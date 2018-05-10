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
    var errmsg: String {
        get {
            switch code {
            case SQLITE_ERROR:
                return "SQL数据库错误或者丢失"
            case SQLITE_INTERNAL:
                return "SQL内部逻辑错误 "
            case SQLITE_PERM:
                return "没有访问权限 "
            case SQLITE_ABORT:
                return "回调请求终止 "
            case SQLITE_BUSY:
                return "数据库文件被锁定 "
            case SQLITE_LOCKED:
                return "数据库中有表被锁定 "
            case SQLITE_NOMEM:
                return "分配空间失败 "
            case SQLITE_READONLY:
                return "企图向只读属性的数据库中做写操作 "
            case SQLITE_INTERRUPT:
                return "通过sqlite3_interrupt()方法终止操作"
            case SQLITE_IOERR:
                return "磁盘发生错误 "
            case SQLITE_CORRUPT:
                return "数据库磁盘格式不正确 "
            case SQLITE_NOTFOUND:
                return "调用位置操作码 "
            case SQLITE_FULL:
                return "由于数据库已满造成的添加数据失败 "
            case SQLITE_CANTOPEN:
                return "无法打开数据库文件 "
            case SQLITE_PROTOCOL:
                return "数据库锁协议错误 "
            case SQLITE_EMPTY:
                return "数据库为空 "
            case SQLITE_SCHEMA:
                return "数据库模式更改 "
            case SQLITE_TOOBIG:
                return "字符或者二进制数据超出长度 "
            case SQLITE_CONSTRAINT:
                return "违反协议终止 "
            case SQLITE_MISMATCH:
                return "数据类型不匹配 "
            case SQLITE_MISUSE:
                return "库使用不当 "
            case SQLITE_NOLFS:
                return "使用不支持的操作系统 "
            case SQLITE_AUTH:
                return "授权拒绝 "
            case SQLITE_FORMAT:
                return "辅助数据库格式错误 "
            case SQLITE_RANGE:
                return "sqlite3_bind 第二个参数超出范围 "
            case SQLITE_NOTADB:
                return "打开不是数据库的文件 "
            case SQLITE_NOTICE:
                return "来自sqlite3_log()的通知 "
            case SQLITE_WARNING:
                return "来自sqlite3_log() 的警告"
            case SQLITE_ROW:
                return "sqlite3_step() 方法准备好了一行数据 "
            case SQLITE_DONE:
                return "sqlite3_step() 已完成执行"
            default:
                return ""
            }
        }
    }
}
// 查询排序
enum JLSQLiteOrder: String {
    case Asc = "asc"    // 升序
    case Desc = "desc"  // 降序
}
// 数据类型
enum JLSQLiteDataType: String {
    case Integer = "integer" // int
    case Real = "real" // float double
    case Text = "text" // char
    case Blob = "blob" // 二进制
}
// 约束
enum JLSQLiteConstraint: String {
    case NotNull = "not null"       // 非空
    case Unique = "unique"          // 唯一
    case NotNullUnique = "not null unique"// 非空且唯一
    case PrimaryKey = "primary key" // 主键
    case AutoPrimaryKey = "primary key autoincrement"// 自增主键
    case ForeignKey = "foreign key" // 外键
    case Check = "check"            // 检查，确保列中的所有值均满足条件
    case DefaultInt0 = "default 0"  // 默认整型 0
    case DefaultInt1 = "default 1"  // 默认整型 1
    case DefaultString = "default '0000000'"  // 默认字符 '0000000'
    case DefaultTimestamp = "default current_timestamp"// 默认当前时间
    case DefaultUpdateTimestamp = "default current_timestamp on update current_timestamp"// 更新当前时间
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
            log("sqlite3 open failure")
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
    
    /// 创建表
    ///
    /// - Parameters:
    ///   - tbName: 表名
    ///   - tbColumn: 表列（表属性）
    ///   - tbConstraint: 表约束,["id":[.AutoPrimaryKey],"column1,column2":[.PrimaryKey],"table1,column1":[.ForeignKey],]
    ///   - block: 执行结果回调
    func createTable(tbName: String, tbColumn: [String: JLSQLiteDataType], tbConstraint: [String: [JLSQLiteConstraint]] = [:], block: ((JLSQLiteError?) ->())) {
        var columnString = ""
        // 遍历列名称及其数据类型
        for (column, type) in tbColumn {
            columnString.append("\(column) \(type.rawValue)")
            // 遍历列约束
            if tbConstraint.keys.contains(column) {
                for constraint in tbConstraint[column]! {
                    if constraint != .ForeignKey {// 外键需要最后处理
                        columnString.append(" \(constraint.rawValue)")
                    }
                }
            }
            columnString.append(",")
        }
        columnString.remove(at: columnString.index(before: columnString.endIndex))
        // 复合主键、联合主键; 外键
        for (column, constraints) in tbConstraint {
            let columns = column.components(separatedBy: ",")
            if columns.count > 1 {
                for constraint in constraints {
                    if constraint == .PrimaryKey {
                        columnString.append(", \(constraint.rawValue)(\(column))")
                    }
                    if constraint == .ForeignKey {
                        columnString.append(", \(constraint.rawValue)(\(columns[1])) references \(columns[0])(\(columns[1]))")
                    }
                }
            }
        }
        let sql = "create table \(tbName)(\(columnString))"
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
        
        let sql = "insert into \(tbName)(\(mutKey)) values(\(mutValue))"
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
            sql.append(" where \(rowWhere.description)")
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
            sql.append(" where \(rowWhere.description)")
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
    func select(tbName: String, tbColumns: [String]! = nil, rowWhere: String! = nil, orderBy: String! = nil, oreder: JLSQLiteOrder = .Asc, block: (([[String: Any]], JLSQLiteError?) ->())) {
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
            sql.append(" where \(rowWhere.description)")
        }
        if orderBy != nil {
            sql.append(" order by \(orderBy.description) \(oreder.rawValue)")
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
        let code = sqlite3_exec(dbBase, sql.cString(using: String.Encoding.utf8), nil, nil, nil)
        if code != SQLITE_OK {
            print(sql)
            block(JLSQLiteError(code: code))
        }else {
            block(nil)
        }
    }
    
    /// 执行查询sql
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - block: 执行结果回调
    func selectSQL(sql: String, block: (([[String: Any]], JLSQLiteError?) ->())) {
        
        var dicts = [[String: Any]]()
        var stmt: OpaquePointer? = nil
        let code = sqlite3_prepare_v2(dbBase, sql.cString(using: String.Encoding.utf8), -1, &stmt, nil)
        if code != SQLITE_OK {
            print(sql)
            block(dicts, JLSQLiteError(code: code))
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
