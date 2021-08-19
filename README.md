# synoindex
解决群晖transmission下载pt种子后nas不自动索引，总是需要手动全部索引

拷贝到nas的文件可以自动索引上，但下载的确不行，真的挺闹心

前提：

1.transmission默认的下载目录是volume1/movie

2.拷贝index.sh到volume1/movie下

如果路径不同请更改

ssh进nas

```
cd /volume1/movie
ls -l /volume1/movie |awk '/^d/ {print $NF}' > /volume1/movie/dir.txt
find /volume1/movie -regex ".*\.mkv\|.*\.mp4\|.*\.MP4\|.*\.MKV" > /volume1/movie/name.txt
nohup bash ./index.sh &
```

然后退出就可以了

3min索引一次，只索引新增的电影和目录

只针对了mp4和mkv两种视频格式

只针对解决了文件名中的空格和[]三种符号，如果需要可以自己加

