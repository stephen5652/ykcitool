# Ykfastlane

iOS 通用打包工具的终端门户工具

- [Ykfastlane](#ykfastlane)
  - [Installation](#installation)
  - [Usage](#usage)
    - [基础配置](#基础配置)
    - [证书管理](#证书管理)
    - [打包](#打包)
  - [异常情况处理](#异常情况处理)
  - [License](#license)
    - [建议](#建议)

## Installation

本指令集适用与ruby 2.7.5 ~ 3.0.3

- 安装ruby

ruby版本管理有两种方式 rvm 与 rbenv, 建议使用rbenv.
安装对应的ruby版本，建议使用2.7.5；并切换ruby版本到满足需求的版本。

- 安装ykfastlane

```shell
gem install ykcitool
```

- 做基础配置
- 安装fastlane脚本

## Usage

安装之后，使用 ykfastlane --help 查看使用说明， 功能分为 通用配置，证书管理，打包三部分。

### 基础配置

基础配置帮助指令
```shell
ykcitool init --help
```
- 设置基础配置  -- ykfastlane init config

    本指令集只是一个门户指令，核心打包功能是通过调用fastlane脚本来实现的。 

    配置：
  - 配置fastlane脚本的远程仓库
  
    此套fastlane脚本是配套脚本；考虑到github的访问问题，可将原始仓库代码迁移到gitlab仓库[^1]。[【原始仓库地址】](https://github.com/stephen5652/ykfastlane_scrip.git)
  
  - 配置通知机器人
  
    任务失败时候的，通过企业微信机器人通知开发者[^2]。[【企业微信机器人配置】](https://developer.work.weixin.qq.com/document/path/91770)
  
  用例：
    ```shell
    ykcitool init config -f https://github.com/stephen5652/ykfastlane_scrip.git -t 5ef50d9f-6426-4c4c-94f8-xxxxxxxxxxxx 
    ```

- 显示基础配置 -- ykfastlane init list_config

    在终端打印基础配置的内容

    用例
    ```shell
    ykcitool init list_config
    ```

- 同步fastlane脚本 -- ykfastlane init sync_script
  
    同步远端fastlane脚本，此处可以通过参数下载固定的fastlan仓库，也可以使用环境配置的仓库来下载。

    用例：
    ```shell
    ykcitool init sync_script
    ```

### 证书管理

iOS证书管理有多种方案：

> - 使用app store connect API进行管理；
> - 使用fastlane match 管理【适用于单账号】
> - 半手动管理

考虑到此平台是通用打包平台，且适用于多个Apple账号下的app打包，所以使用半自动管理证书的形式。
具体实施方案：

> - 账号管理员创建/维护签名证书和描述文件，并上传至证书仓库；
> - 开发者电脑，打包机同步证书仓库，并安装证书和描述文件；
> - 各个项目配置手动签名配置；
> - 打包平台依据项目签名配置，进行打包。

操作步骤：

- 管理员，开发者，打包机电脑配置证书仓库

    指令集通过git仓库来维护证书。

    指令
    ```shell
    ykcitool certificate edit_config -r http://xxx.xxx.com/xxx.git
    ```
  
    指令集支持显示证书仓库配置

    指令：
    ```shell
    ykcitool certificate list_config
    ```

- 管理员更新证书

    使用脚本平台，更新证书，并推送至证书仓库

    指令：

    ```shell
    ykcitool certificate update_cer -c /Users/xxx/xxx/xxxx.p12 -p xxxx
    ```

- 管理员更新描述文件

    使用脚本平台，更新描述文件，并推送至证书仓库。

    指令：

    ```shell
    ykcitool certificate update_profile -p /Users/xxx/xxx/xxx.mobileprovision
    ```

- 同步证书和描述文件

    开发者，打包机通过平台同步证书仓库。

    指令：

    ```shell
    ykcitool certificate sync-cer
    ```

- 显示证书和描述文件

    指令集支持显示证书仓库中的证书和描述文件

    指令：

    ```shell
    ykcitool certificate list_cers
    ```

- 缺点

    此种形式的证书管理，也是存在缺点的。

    缺点：

  - 多个Apple账号的证书在同一个git仓库管理；
  - 每台电脑都安装了所有Apple账号的证书和项目描述文件。

### 打包

指令集通过调用fastlane脚本进行打包，依据发不的平台，分为三种打包：fir平台，蒲公英平台，TF

- fir打包

  - 打包指令帮助：

    ```shell
    ykcitool archive fire --help
    ```
  
  - 使用方式
  
      支持两种打包方式， 在.xcworkspace 路径打包 / 在其他目录打包。

      > 在 .xcworkspace 同级打包
      > ```shell
      > ykcitool archive fire -s XXXX -f xxxx -e enterprise -n "iOS测试包" -w xxxx
      > ```

      > 在其他目录打包：
      由于.xcworkspace未必在git仓库根目录，所以可以用参数 -x 指定 .xcworkspace 的相对路径 </br>
      如果终端工作路径在 .xcworkspace同级目录，则可以不使用参数 -x </br>
      如果不用专门通知企业微信业务群，可以不指定 -w 参数，会默认使用env中配置的企微机器人。</br>
      > ```shell
      > ykcitool archive fire -s XXXX -x ～/users/xxx/xxx/xxxx.xcworkspace -f xxxx -e enterprise -n "iOS测试包" -w xxxx
      > ```
    
- 蒲公英打包

    使用方式同 fir 打包


- TF打包

    由于TF打包一定是app store包，所以此指令没有 -e 参数，无法指定包类型
    - 打包指令帮助：
      ```shell
      ykcitool archive tf --help
      ```
  
    - 使用方式

      通用支持两种打包方式， 通过 -x 参数来指定 .xcworkspace 的路径
      > 此处需要特别说明 -u -p -w -c 参数 </br>
      -u 开发者的Apple ID </br>
      -p 开发者Apple ID的App专属密钥[^3]。[【传送门】](https://appleid.apple.com/account/manage) </br>
      -w 企微机器人，如果不指定，则默认使用env中配置的机器人。 </br>
      -c 是否需要pod install， 默认不执行。
    
      指令范例：
      ```shell
      ykcitool archive tf -s XXX -u xxxx.@xxx.com  -p xxxx-xxxx-xxxx-xxxx -n iOS测试包 -w xxxxx -c 1
      ```

## 异常情况处理

- public_suffix 版本冲突

  - 清空gem
  
    ```shell
    gem clean
    ```

  - 卸载 public_suffix

    ```shell
    gem uninstall public_suffix
    ```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[^1]:fastlane脚本原始仓库地址: https://github.com/stephen5652/ykfastlane_scrip.git

[^2]:企业微信机器人配置网址: https://developer.work.weixin.qq.com/document/path/91770

[^3]: 配置App专属密钥的网址: https://appleid.apple.com/account/manage


### 建议

fire-api-token 做全局配置

tf tag参数化，可以控制是否打tag

builde 号不交付苹果管理，指令集也不管理，交由工程配置

显示打包结果的存储路径