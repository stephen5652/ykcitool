# Ykfastlane

iOS 通用打包工具的终端门户工具

## Installation

Add this line to your application's Gemfile:

install it on your mac as:

    $ gem install ykfastlane

## Usage

安装之后，使用 ykfastlane --help 查看使用说明， 功能分为 通用配置，证书管理，打包三部分。

### 基础配置
基础配置帮助指令
```shell
ykfastlane init --help
```
- 设置基础配置  -- ykfastlane init config

    本指令集只是一个门户指令，核心打包功能是通过调用fastlane脚本来实现的。 

    配置：
  - 配置fastlane脚本的远程仓库
  
    此套fastlane脚本是配套脚本；考虑到github的访问问题，可将原始仓库代码迁移到gitlab仓库。[【原始仓库地址】]([https://github.com/stephen5652/ykfastlane_scrip.git]) `https://github.com/stephen5652/ykfastlane_scrip.git`
  
  - 配置通知机器人
  
    任务失败时候的，通过企业微信机器人通知开发者。[【企业微信机器人配置】](https://developer.work.weixin.qq.com/document/path/91770)
  
  用例：
    ```shell
    ykfastlane init config -f https://github.com/stephen5652/ykfastlane_scrip.git -t 5ef50d9f-6426-4c4c-94f8-xxxxxxxxxxxx 
    ```

- 显示基础配置 -- ykfastlane init list_config

    在终端打印基础配置的内容

    用例
    ```shell
    ykfastlane init list_confi
    ```

- 同步fastlane脚本 -- ykfastlane init sync_script
  
    同步远端fastlane脚本，此处可以通过参数下载固定的fastlan仓库，也可以使用环境配置的仓库来下载。

    用例：
    ```shell
    ykfastlane init sync_script
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
    ykfastlane certificate edit_config -r http://xxx.xxx.com/xxx.git
    ```
  
    指令集支持显示证书仓库配置
    
    指令：
    ```shell
    ykfastlane certificate list_config
    ```

- 管理员更新证书

    使用脚本平台，更新证书，并推送至证书仓库

    指令：
    ```shell
    ykfastlane certificate update_cer -c /Users/xxx/xxx/xxxx.p12 -p xxxx
    ```
- 管理员更新描述文件

    使用脚本平台，更新描述文件，并推送至证书仓库。
    
    指令：
    ```shell
    ykfastlane certificate update_profile -p /Users/xxx/xxx/xxx.mobileprovision
    ```
- 同步证书和描述文件

    开发者，打包机通过平台同步证书仓库。

    指令：
    ```shell
    ykfastlane certificate sync-cer
    ```

- 显示证书和描述文件
    
    指令集支持显示证书仓库中的证书和描述文件
    
    指令：
    ```shell
    ykfastlane certificate list_cers
    ```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).