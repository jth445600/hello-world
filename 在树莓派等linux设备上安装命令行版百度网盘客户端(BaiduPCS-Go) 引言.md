### 在树莓派等linux设备上安装命令行版百度网盘客户端(BaiduPCS-Go)
**引言**

> baidupcs-go是GitHub上的一个破解百度网盘下载限速的项目,因为是开源的支持很多平台,而且非会员下载速度也很快.好景不长,百度开始收紧这方面的业务,限速破解就不能用了.再后来有个x盘的开发者被抓了,就删库了.

我在GitHub上找到一个fork,里面也包含了 release,这就很方便.
这是GitHub项目地址: [点这](https://github.com/felixonmars/BaiduPCS-Go) `https://github.com/felixonmars/BaiduPCS-Go`


可以在release这下载对应平台的执行文件  [点这](https://github.com/felixonmars/BaiduPCS-Go/releases)

##### 需要说明:这个已经不能破解限速了,只能是当做一个linux系统的命令行客户端来使用

**也有很多的应用场景:**

**比如说,可以安装在树莓派上,当做一个下载机来使用.**

##### 也可以部署在 vps上,用于转存百度网盘里的内容到 谷歌网盘或者onedrive

![image.png](https://i.loli.net/2021/03/30/OuyImaAMs2UjP46.png)

因为我安装的是`64位的`树莓派系统，所以这里我选择的是`BaiduPCS-Go-v3.6.2-linux-arm64.zip
`
> 推荐使用我安装的`64bit`的树莓派系统。具体下载和安装步骤见我的第八期视频：
> https://youtu.be/6NHwnvsMPqk [点这](https://youtu.be/6NHwnvsMPqk)

一种方法是使用`wget`下载.另外一种办法是在使用本地Windows电脑下载,然后在下载完成之后在使用`lrzsz`工具上传到树莓派上.
`lrzsz`的安装命令为 
```shell
sudo apt install lrzsz -y
```
然后使用`rz`命令,浏览目录找到下载文件所在的位置,选中之后点击确定,就开始上传了.

![1617107423632](https://i.loli.net/2021/03/30/QO7Bah2D56YUFTo.png)

![1617107489534](https://i.loli.net/2021/03/30/8lETefYBwbkd7pK.png)

完成之后,只需要解压就可以使用了.
![1617107518392](https://i.loli.net/2021/03/30/YtaVUOwnXy32Tqf.png)
就是使用命令 `unzip BaiduPCS-xxx.zip`就可以解压了
解压完成之后可以看到一个文件夹,进入之后,就可以看到执行文件了
![1617107754029](https://i.loli.net/2021/03/30/iUFSekT9aqdLbpZ.png)

之后 输入

```shell
./Baidupcs-go
```

就可以开始运行了

如何登录呢?

输入 `login`就可以使用账户和密码进行登录了

![image-20210330205451378](https://i.loli.net/2021/03/30/WFi2EOj3VsDqSIn.png)

可以看到需要输入验证码

baidupcs-go提供两种方式,一个是查看位于`tmp`目录下的验证码图片(不推荐这种方法),另外一种方法就是访问所给链接,只需要将该链接放到浏览器的地址栏,回车之后就可以看到验证码的图片.

正确输入验证码之后,就可以登录到账号中了,这时就可以看到网盘里的内容了.

![image-20210330210343958](https://i.loli.net/2021/03/30/6BhdlmSYDciPayW.png)

比如说,我们想要进入到`bili`这个目录中

我们只需要输入`cd bili`就可以进入到该目录中

![image-20210330210516292](https://i.loli.net/2021/03/30/CgrHxQK6to5wJYV.png)

可以看到这个文件夹里并没有内容.

使用`cd ..`就可以回到上一级目录

![image-20210330210656477](https://i.loli.net/2021/03/30/rb3BPLstWjMmQKX.png)

##### 测试一下下载速度

> 这里我是有百度网盘的超级会员的,正如前面所说.这个已经不能破解限速了,只能是当做一个linux系统的命令行客户端来使用

![image-20210330211257959](https://i.loli.net/2021/03/30/E49WwhsRyLZUXqA.png)

可以看到下载速度还是挺快的.

![image-20210330211342378](https://i.loli.net/2021/03/30/px3zCyBYJ7mgjDO.png)

我们还可以配置一下,提高下载速度

![image-20210330211605962](https://i.loli.net/2021/03/30/CjoYZwm8v5Nre1h.png)

使用改命令

``` config set -appid=309847```

配置`appid`为`309807`

其实也快不了多少.

其他的一些操作具体看一下GitHub主页的详细说明.

GitHub项目地址: [点这](https://github.com/felixonmars/BaiduPCS-Go) 




