# VideoThumbnail
获取视频指定时间第一帧图片

内存缓存图片，五分钟后滑动cell会重新下载图片！

支持`M3u8格式`的直播流url截图，线程并发处理
***
代码示例 
```oc
#import "WHVideoThumbnail.h"
...
[imageView wh_setImageWithURL:[NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"]];
```
***
使用注意: 需要在工程

  `Build Settings` 的 `Header Search Paths`  加入 `$(inherited)`, `$(PROJECT_DIR)/xxxxx/VideoThumbnail/FFmpeg/include`
  
  `Build Settings` 的 `Library Search Paths` 加入 `$(inherited)`, `$(PROJECT_DIR)/xxxxx/VideoThumbnail/FFmpeg/lib` 
  
xxxx 表示项目里面到VideoThumbnail文件夹的路径

* 正常`Library Search Paths` 里面会默认导入路径

引入三个系统库 
  1. `libz.tbd`
  2. `libbz2.tbd`
  3. `libiconv.tbd`
  4. `VideoToolbox.framework`

工程里面需要导入，`YYcache` 框架
  1. 做了本地`url`时间戳缓存，每个url对应一个时间戳！每次先读取本地`url`比对时间有没有超过五分钟，超过了重新下载图片
  2. 因为没有做图片本地缓存，所以每次APP杀进程重新进入，图片会重新下载对应的`url`时间戳也会更新
