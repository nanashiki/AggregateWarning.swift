# 概要
Xcodeのwaningを集計するツールです

# 使用方法

* clean build後xcodeのbuildログの `save...` をclickし保存
![img1](https://github.com/nanashiki/AggregateWarning.swift/blob/master/img1.png?raw=true "img1")
* swiftコードを実行
```
swift AggregateWarning.swift /path/to/build_log_file.rtf
```
* 実行結果
```
| deprecated | count |
| --- | --- |
| characters | 6 |

| others | count |
| --- | --- |
| Plain Style unsupported in a Navigation Item\ | 1 |

| type | count |
| --- | --- |
| deprecated | 6 |
| others | 1 |
| sum | 7 |
```
