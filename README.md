# Swift_Runtime_Serialization
## 运行环境
    Xcode 9.1、Swift 4.0
## 功能
    利用Runtime实现(反)序列化/(解)归档
## 核心代码及解释
### 归档
    func encode(with aCoder: NSCoder) {
        
    //        1.获取所有属性
    //        1.1.创建保存属性个数的变量
        var count: UInt32 = 0
    //        1.2.获取变量的指针
        let outCount: UnsafeMutablePointer<UInt32> = withUnsafeMutablePointer(to: &count) { (outCount: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<UInt32> in
            return outCount
        }
    //        1.3.获取属性数组
        let ivars = class_copyIvarList(Person.self, outCount)
        for i in 0..<outCount.pointee {
    //            2.获取键值对
    //            2.1.获取ivars中的值
            let ivar = ivars![Int(i)];
    //            2.2.获取键
            let ivarKey = String(cString: ivar_getName(ivar)!)
    //            2.3.获取值
            let ivarValue = value(forKey: ivarKey)
            
    //            3.归档
            aCoder.encode(ivarValue, forKey: ivarKey)
        }
        
    //        4.释放内存
        free(ivars)
    }
### 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
    //        1.获取所有属性
    //        1.1.创建保存属性个数的变量
        var count: UInt32 = 0
    //        1.2.获取变量的指针
        let outCount = withUnsafeMutablePointer(to: &count) { (outCount: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<UInt32> in
            return outCount
        }
    //        1.3.获取属性数组
        let ivars = class_copyIvarList(Person.self, outCount)
        for i in 0..<count {
    //            2.获取键值对
    //            2.1.获取ivars中的值
            let ivar = ivars![Int(i)]
    //            2.2.获取键
            let ivarKey = String(cString: ivar_getName(ivar)!)
    //            2.3.获取值
            let ivarValue = aDecoder.decodeObject(forKey: ivarKey)
            
    //            3.设置属性的值
            setValue(ivarValue, forKey: ivarKey)
        }
        
    //        4.释放内存
        free(ivars)
    }
    
## 编写项目时，容易出现的错误
### 当为类添加属性时，如果不在属性前加上 @objc
    eg: var age: NSInteger = 0 <br>
    此时会发生以下错误
    eg: @objc var age: NSInteger = 0 <br>
### 如果之前没有使用Runtime机制, 而是手写
    此时可能会发生以下错误
