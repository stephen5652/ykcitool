# Ykfastlane

iOS 通用打包工具的终端门户工具
本指令集适用与ruby 2.7.5 ~ 3.0.3

- [Ykfastlane](#ykfastlane)
  - [环境配置](#环境配置)
  - [ykfastlane基础参数配置](#ykfastlane基础参数配置)
    - [基础参数配置 帮助](#基础参数配置-帮助)
    - [基础参数配置 样例](#基础参数配置-样例)
  - [同步基础配置](#同步基础配置)
    - [同步基础配置 帮助](#同步基础配置-帮助)
      - [同步基础配置 样例](#同步基础配置-样例)
  - [证书管理](#证书管理)
    - [证书仓库同步](#证书仓库同步)
    - [添加本地P2](#添加本地p2)
    - [添加本机profile](#添加本机profile)
    - [同步苹果后台profile](#同步苹果后台profile)
  - [打包功能](#打包功能)
    - [xcworkspace 字段说明](#xcworkspace-字段说明)
    - [打包指令](#打包指令)
      - [fir平台](#fir平台)
      - [蒲公英平台](#蒲公英平台)
      - [test flight 平台](#test-flight-平台)

## 环境配置

- ruby环境配置

  ruby版本管理有两种方式 rvm 与 rbenv, 建议使用rbenv.
安装对应的ruby版本，建议使用2.7.5；并切换ruby版本到满足需求的版本。</br>

  - rbenv 安装

    ```shell
    brew install rbenv
    ```

  - 配置rbenv环境变量
  
    - 编辑 ～/.bash_profile
  
      ```shell
      vi ~/.bash_profile
      ```

    - 输入rbenv环境信息

      ```shell
      # rbenv
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init -)"
      ```

    - 保存

      ```shell
      :wq
      ```

    - 载入环境变量

      ```shell
      source ~/.bash_profile
      ```

    - 配置rbenv文件权限

      ```shell
      sudo chown -R $(whoami) $HOME/.rbenv
      ```

  - ruby 2.7.5 安装

    ```shell
    rbenv install 2.7.5 --verbose
    ```
  
  - 配置 ruby 版本

    ```shell
    rbenv global 2.7.5
    ```

  - 安装bundler

    ```shell
    gem install bundler
    ```

  - 安装ykfastlane

    ```shell
    gem install ykfastlane
    ```

## ykfastlane基础参数配置

### 基础参数配置 帮助
  
```shell
ykfastlane init edit-configs -h
```

or

```shell
ykfastlane init edit-configs --help
```

<font size=2 style="font-weight:bold;font-style:italic;">参数说明:</font>

- --fastfile-remote 执行文件仓库
  
  - 本脚本只是门户指令集， 功能核心是fastlane执行文件
  - fastlane执行文件在单独仓库托管，帮助指令提供了可用的两个仓库
  - 配置此参数的同时，会自动下载fastlane执行文件

- --profile-remote-url 证书托管仓库
  
  - 打包功能需要用到 p12 与 mobileprovision
  - p12 & mobileprovision 由git仓库托管, 需使用者配置该仓库
  - 帮助指令提供了我司已配置的仓库，用于管理我司的相关 p12 与 mobileprovison
  - 配置此参数的同时，会自动下载仓库，并安装 p12 和 mobileprovision

- 发包平台口令
  
  - 平台支持配置全局统一的发包平台参数
  - --pgyer-user & --pgyer-api --> 蒲公英平台参数
  - --apple-account & --apple-password  -->  tf【Apple test flight】平台参数
  - --fir-api-token --> fir im 平台参数

- 企业微信机器人
  
  - --wx-access-token --> 平台支持配置统一的企业微信机器人
  
<font size=2 style="font-weight:bold;font-style:italic;">参数使用细节:</font>

- 参数都是可选项， 即【可以一次性配置所有参数，也可以只配置部分参数】
- 如果对应平台已经配置过，再次执行本指令，会覆盖已配置的参数

### 基础参数配置 样例

```shell
    ykfastlane init edit-configs -l https://gitlab.xxx.com/xxx/xxx/xxx.git -t xxxx-xxxx-xxx -r https://gitlab.xxx.com/xxx/xxx/xxx.git -u xxxxx -a xxxxx -c xxxxxx
-p xxxxxx -f xxxxxx
```

## 同步基础配置

### 同步基础配置 帮助

```shell
ykfastlane init execute_configs -h
```

or

```shell
ykfastlane init execute_configs --help
```

<font size=2 style="font-weight:bold;font-style:italic;">参数说明:</font>

- --all --> 同时更新fastlane仓库 和 certificate-profile 仓库
- --script --> 只更新fastlane仓库
- --profile --> 只更新 certificate & profile 仓库

<font size=2 style="font-weight:bold;font-style:italic;">参数使用细节:</font>

- 参数都是可选项，非必需
- --all 参数会覆盖其余参数
- --no-xxx 可以不使用, 只要不传--xxxx即可

#### 同步基础配置 样例

- fastlane 执行文件 和 certificate & profile 都有独立的git仓库管理；可一次性更新所有配置,也可以仅更新某一项配置。

- 更新 fastlane 执行文件仓库
  
  > ```shell
  > ykfastlane init execute_configs -s
  > ```

- 更新 certificate & profile 仓库

  > ```shell
  > ykfastlane init execute_configs -p
  >```

## 证书管理

### 证书仓库同步

- 帮助指令：

  ```shell
  ykfastlane certificate sync-git --help
  ```

- 指令样例【该指令无参数】

  ```shell
  ykfastlane certificate sync-git
  ```

### 添加本地P2

- 帮助指令
  
  ```shell
  ykfastlane certificate update_cer --help
  ```

- 添加p12

  cer_path: 可以是绝对路径， 也可以是当前终端工作路径的相对路径。

  ```shell
  ykfastlane certificate update_cer -p xxxxx -c xxx/xxx/xxx/xxx.p12
  ```

### 添加本机profile
  
- 帮助指令
  
  ```shell
  ykfastlane certificate update_profile --help
  ```

- 指令样例
  
  可以同步一个或多个profile
  > profile-path:
  >
  > - profile 可以是绝对路径, 也可以是相对路径
  > - 多个profile, 使用空格隔开
  > - 某一个profile, 如果名称或路径存在空格, 需要使用英文双引号【""】包括
  
  ```shell
  ykfastlane certificate update_profile -p 123 456 "7 8 9"
  ```

### 同步苹果后台profile

- 帮助指令
  
  ```shell
  ykfastlane certificate sync_apple_profile --help
  ```

- 指令样例
  
  可以通过bundle_id同步，也可以通过工程workspace同步。

  > workspace:
  >
  > - 可以不传【即不使用workspace同步profile】;
  > - 可以是相对路径，请使用 ./
  > - 可以是绝对路径

  > bundle_ids
  >
  > - 多个bundleId 使用空格隔开
  > - 每个bundleId 使用英文双引号包括。

  ```shell
  ykfastlane certificate sync_apple_profile -u xxxxxxx -p xxxxx -b xxxxx "xxx xxx" "1234" -w ./
  ```

## 打包功能

### xcworkspace 字段说明
  
### 打包指令

- 打包指令帮助
  
  ```shell
  ykfastlane archive --help
  ```
  
#### fir平台

- 帮助指令

  ```shell
  ykfastlane archive fir --help
  ```

- 指令样例 【当前终端路径是工程目录】
  
  > xcworkspace 字段使用方式，参考 [xcworkspace 字段说明](#xcworkspace-字段说明)

  ```shell
  ykfastlane archive fir -s ShuabaoQ -e enterprise -x "123/xxx.xcworkspace"
  ```

#### 蒲公英平台

- 帮助指令

  ```shell
  ykfastlane archive pgyer --help
  ```

- 指令样例 【当前终端路径是工程目录】

  > xcworkspace 字段使用方式，参考 [xcworkspace 字段说明](#xcworkspace-字段说明)

  ```shell
  ykfastlane archive pgyer -s YKLeXiangBan  -e enterprise -x "123/xxx.xcworkspace"
  ```

#### test flight 平台

- 帮助指令

  ```shell
  ykfastlane archive tf --help
  ```

- 指令样例

  > xcworkspace 字段使用方式，参考 [xcworkspace 字段说明](#xcworkspace-字段说明)

  ```shell
  ykfastlane archive tf -s YKLeXiangBan  -e enterprise -x "123/xxx.xcworkspace"
  ```
