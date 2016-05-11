# JianSan-Wallpaper

采用swift编写的一个壁纸类app，PHP后台源码地址: [源码地址](https://github.com/6ag/JianSan-Wallpaper-php) 。项目持续更新完善中，如果您有啥建议请提交 `issues` 给我。

本应用已经上架: [AppStore地址](https://itunes.apple.com/cn/app/id1110293594)

#### 控制器切换

![image](https://github.com/6ag/JianSan-Wallpaper/blob/master/1.gif)

#### 一键设置壁纸

![image](https://github.com/6ag/JianSan-Wallpaper/blob/master/2.gif)

#### 自适应操作选项

![image](https://github.com/6ag/JianSan-Wallpaper/blob/master/3.gif)

## 可抽取框架
### **一、JFContextSheet**

这是一个自适应的弹出选项封装，可以适用于各种功能菜单。

#### 导入框架

将项目中 `Vender` 目录下的 `JFContextSheet` 目录拖到你自己的项目。

#### 初始化 **JFContextSheet**

**JFContextSheet** 初始化需要自己创建 `JFContextItem` 对象，每个 `JFContextItem` 代表一个选项，需要传递选项的标题和图片。然后将这些选项通过构造方法传递给 **JFContextSheet** 进行初始化。
**注意:** 选项的点击事件是根据代理来回调的，所以我们需要指定代理对象，这里指定为当前控制器。

```swift
let contextItem1 = JFContextItem(itemName: "返回", itemIcon: "content_icon_back")
let contextItem2 = JFContextItem(itemName: "预览", itemIcon: "content_icon_preview")
let contextItem3 = JFContextItem(itemName: "下载", itemIcon: "content_icon_download")
let contextSheet = JFContextSheet(items: [contextItem1, contextItem2, contextItem3])
contextSheet.delegate = self
```

#### 实现代理 **JFContextSheetDelegate**

这个方法会返回按钮的标题，可以根据标题判断点击的选项

```swift
func contextSheet(contextSheet: JFContextSheet, didSelectItemWithItemName itemName: String) {
  switch (itemName) {
  case "返回":
    break
  case "预览":
    break
  case "下载":
    break
  default:
    break
  }
}
```

### **二、WallPaperTool** 一键设置壁纸

总所周知，iPhone设置壁纸非常的坑爹！！！这是一个利用 `运行时` 一键设置iPhone壁纸的分类，可以实现一键设置锁屏壁纸、一键设置主屏幕壁纸、一键设置锁屏和主屏幕壁纸的功能。`运行时` 创建的对象原先属于 `私有api` ，但现在不需要导入私有框架 `PhotoLibrary` 都能成功设置了。我今天下载了几十个壁纸app，发现有几个app里也有这个功能，不知道上架 `AppStore` 需不需要做一些手段。

#### 导入框架

将项目中 `Vender` 目录下的 `WallPaperTool` 目录拖到你自己的项目，并导入分类头文件 `UIImage+WallPaper.h` 。

#### 如何设置

只需要用 `UIImage` 对象调用分类方法进行设置壁纸。

```objc
/*
 *  保存为桌面壁纸和锁屏壁纸
 */
- (BOOL)saveAsHomeScreenAndLockScreen;

/*
 *  保存为桌面壁纸
 */
- (BOOL)saveAsHomeScreen;

/*
 *  保存为锁屏壁纸
 */
- (BOOL)saveAsLockScreen;
```

#### 实例代码

```swift
let alertController = UIAlertController()

let lockScreen = UIAlertAction(title: "设为锁屏壁纸", style: UIAlertActionStyle.Default, handler: { (action) in
    
    if self.image?.saveAsLockScreen() == true {
        SVProgressHUD.showSuccessWithStatus("设置成功")
    } else {
        SVProgressHUD.showInfoWithStatus("设置失败")
    }
})

let homeScreen = UIAlertAction(title: "设为桌面壁纸", style: UIAlertActionStyle.Default, handler: { (action) in
    
    if self.image?.saveAsHomeScreen() == true {
        SVProgressHUD.showSuccessWithStatus("设置成功")
    } else {
        SVProgressHUD.showInfoWithStatus("设置失败")
    }
})

let homeScreenAndLockScreen = UIAlertAction(title: "设为锁屏和桌面壁纸", style: UIAlertActionStyle.Default, handler: { (action) in
    
    if self.image?.saveAsHomeScreenAndLockScreen() == true {
        SVProgressHUD.showSuccessWithStatus("设置成功")
    } else {
        SVProgressHUD.showInfoWithStatus("设置失败")
    }
})

let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (action) in
    
})

// 添加动作
alertController.addAction(lockScreen)
alertController.addAction(homeScreen)
alertController.addAction(homeScreenAndLockScreen)
alertController.addAction(cancel)

// 弹出选项
presentViewController(alertController, animated: true, completion: { 
    
})
```

