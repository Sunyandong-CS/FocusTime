# 专注时间

> _专注时间iOS端，提供专注时间倒计时，专注时间设置，专注时间统计、离开提醒等功能，旨在于帮助人们管理和专注于时间。_

## Features

- [x] 倒计时

- [ ] 完成和退出的提醒

- [x] 专注设置

- [x] 个人中心

- [ ] 倒计时

- [ ] 番茄逻辑

- [ ] 休息时长统计

- [ ] 换肤功能

## 更新进度

    ********5.13更新，数据本地化存储实现，今日统计页面UI和数据展示实现

    ********5.14更新，透明状态栏以及番茄法则逻辑更改

    ********5.15更新，休息逻辑的实现，休息时间的统计，休息的提醒，部分bug的修复

    ********5.17更新，个人中心页面显示和UI优化，新增换肤页面，休息逻辑的优化

    ********5.18更新，统一设置透明导航栏，通过继承一个SYDNavigationController ，减少重复性代码

### 部分功能实现逻辑

* 自适应导航栏和状态栏高度（适配iPhoneX）

```

#define getRectNavAndStatusHight self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

```

* 透明导航栏，在SYDNavigationController添加方法

```

- (void)setNeedsNavigationBackground:(CGFloat)alpha {

	// 导航栏背景透明度设置

	UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];// _UIBarBackground

	UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView

	if (self.navigationController.navigationBar.isTranslucent) {

		if (backgroundImageView != nil && backgroundImageView.image != nil) {

			barBackgroundView.alpha = alpha;

		} else {

			UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView

			if (backgroundEffectView != nil) {

				backgroundEffectView.alpha = alpha;

			}

		}

	} else {

		barBackgroundView.alpha = alpha;

	}

	self.navigationController.navigationBar.clipsToBounds = alpha == 0.0;

}

```

## Demonstrate

### 各部分页面截图
* 首页 ![](https://github.com/Sunyandong-CS/FocusTime/raw/master/ScreenShot/home.png)
* 暂停开始 ![](https://github.com/Sunyandong-CS/FocusTime/raw/master/ScreenShot/rest.png)![](https://github.com/Sunyandong-CS/FocusTime/raw/master/ScreenShot/pause.png)![](https://github.com/Sunyandong-CS/FocusTime/raw/master/ScreenShot/finish.png)
* 个人中心 ![](https://github.com/Sunyandong-CS/FocusTime/raw/master/ScreenShot/selfCenter.png)
* 设置 ![](https://github.com/Sunyandong-CS/FocusTime/raw/master/ScreenShot/setting.png)

### 页面展示: (开始、暂停、继续、退出)

![](https://github.com/Sunyandong-CS/FocusTime/raw/master/ScreenShot/Demonstrate.gif)
