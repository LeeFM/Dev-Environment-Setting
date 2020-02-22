#### expression 修改值 宣告變量

```
(lldb) e int $a = 2
(lldb) p $a * 19
38
(lldb) e NSArray *$array = @[ @"Saturday", @"Sunday", @"Monday" ]
(lldb) p [$array count]
2
(lldb) po [[$array objectAtIndex:0] uppercaseString]
SATURDAY
(lldb) p [[$array objectAtIndex:$a] characterAtIndex:0]
error: no known method '-characterAtIndex:'; cast the message send to the method's return type
error: 1 errors parsing expression

(lldb) p (char)[[$array objectAtIndex:$a] characterAtIndex:0]
```

#### call在斷點調用方法

#### frame select

#### thread return / thread jump --by 1

#### image lookup -a / -name

#### breakpoint

```
breakpoint set --one-shot true --name "-[Class method:]" -c " i > 0 "
breakpoint set -r “setText:” -c ‘(BOOL)[*(int*)($esp + 12) isEqual:@”— points”]’
-[UIControl sendAction:to:forEvent:]
breakpoint set -r “UIControl sendAction:to:forEvent:”
-[UIViewController viewDidLoad:]
-[UIView initWithFrame:]
+[NSObject alloc] -c '(BOOL)[(id)$arg1 isKindOfClass:[CustomVC class]]'

breakpoint set -r “didSelectRow”
breakpoint set -r . -s <PRODUCT_NAME>

Global BreakPoint -> Add Exception Breakpoint manually
```

#### 列出UI圖層

```
   (lldb) po [[[UIApplication sharedApplication] keyWindow] recursiveDescription]
<UIWindow: 0x7f82b1fa8140; frame = (0 0; 320 568); gestureRecognizers = <NSArray: 0x7f82b1fa92d0>; layer = <UIWindowLayer: 0x7f82b1fa8400>>
   | <UIView: 0x7f82b1d01fd0; frame = (0 0; 320 568); autoresize = W+H; layer = <CALayer: 0x7f82b1e2e0a0>>
   
   (lldb) po ((MyClass *)0x7f82b1fa8140)
   (lldb) po unsafeBitCast(0x7f82b1fa8140, MyClass.self)
   (lldb) po unsafeBitCast(0x7f82b1fa8140, MyClass.self).center.y = 200
   (lldb) expression CATransaction.flush()
```

#### 更新UI

```
(lldb) e id $myView = (id)0x7f82b1d01fd0
(lldb) e (void)[$myView setBackgroundColor:[UIColor blueColor]]
(lldb) e (void)[CATransaction flush]
```

#### Push 一个 View Controller

想象一个以 `UINavigationController` 为 root ViewController 的应用。你可以通过下面的命令，轻松地获取它：

```
(lldb) e id $nvc = [[[UIApplication sharedApplication] keyWindow] rootViewController]
```

然后 push 一个 child view controller:

```
(lldb) e id $vc = [UIViewController new]
(lldb) e id $vc = (id)[NSClassFromString(@"TheClass") new]
(lldb) e (void)[[$vc view] setBackgroundColor:[UIColor yellowColor]]
(lldb) e (void)[$vc setTitle:@"Yay!"]
(lldb) e (void)[$nvc pushViewContoller:$vc animated:YES]
(lldb) e (void)[CATransaction flush]
```

#### 查找按钮的 target

想象你在调试器中有一个 `$myButton` 的变量，可以是创建出来的，也可以是从 UI 上抓取出来的，或者是你停止在断点时的一个局部变量。你想知道，按钮按下的时候谁会接收到按钮发出的 action。非常简单：

```
(lldb) po [$myButton allTargets]
{(
    <MagicEventListener: 0x7fb58bd2e240>
)}
(lldb) po [$myButton actionsForTarget:(id)0x7fb58bd2e240 forControlEvent:0]
<__NSArrayM 0x7fb58bd2aa40>(
_handleTap:
)
```

现在你或许想在它发生的时候加一个断点。在 `-[MagicEventListener _handleTap:]` 设置一个符号断点就可以了，在 Xcode 和 LLDB 中都可以，然后你就可以点击按钮并停在你所希望的地方了。

### 观察实例变量的变化

假设你有一个 `UIView`，不知道为什么它的 `_layer` 实例变量被重写了 (糟糕)。因为有可能并不涉及到方法，我们不能使用符号断点。相反的，我们想**监视**什么时候这个地址被写入。

首先，我们需要找到 `_layer` 这个变量在对象上的相对位置：

```
(lldb) p (ptrdiff_t)ivar_getOffset((struct Ivar *)class_getInstanceVariable([MyView class], "_layer"))
(ptrdiff_t) $0 = 8
```

现在我们知道 `($myView + 8)` 是被写入的内存地址：

```
(lldb) watchpoint set expression -- (int *)$myView + 8
Watchpoint created: Watchpoint 3: addr = 0x7fa554231340 size = 8 state = enabled type = w
    new value: 0x0000000000000000
    
(lldb) watchpoint set expression 0x7fee8d5bbf60
(lldb) watchpoint modify -c '(a=100)'
(lldb) watchpoint list
(lldb) bt
```

