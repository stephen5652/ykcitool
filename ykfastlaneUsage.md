# Ykfastlane

iOS 通用打包工具的终端门户工具
本指令集适用与ruby 2.7.5 ~ 3.0.3

- [Ykfastlane](#ykfastlane)
    - [环境配置](#环境配置)
    - [ykfastlane基础参数配置](#ykfastlane基础参数配置)
    - [证书配置](#证书配置)
      - [配置证书管理仓库](#配置证书管理仓库)
      - [同步git仓库中证书](#同步git仓库中证书)
      - [添加本地P2](#添加本地p2)
      - [添加本机profile](#添加本机profile)
      - [同步苹果后台profile](#同步苹果后台profile)
    - [打包功能](#打包功能)
      - [打包配置](#打包配置)
      - [xcworkspace 字段说明](#xcworkspace-字段说明)
      - [打包指令](#打包指令)
        - [fir平台](#fir平台)
        - [蒲公英平台](#蒲公英平台)
        - [test flight 平台](#test-flight-平台)

### 环境配置

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

### ykfastlane基础参数配置

- 配置基础参数
  
  - 帮助指令
  
    ```shell
    ykfastlane init config --help
    ```

  - 指令样例

    帮助指令提供了可用的两个 git url。

    ```shell
    ykfastlane init config -t 5ef50d9f-6426-4c4c-94f8-f08a4f0e1611 -f xxxx
    ```

- 安装fastlane脚本

  ```shell
  ykfastlane init sync-script
  ```

### 证书配置

#### 配置证书管理仓库

- 帮助指令：

  ```shell
  ykfastlane certificate sync-git --help
  ```

- 指令样例
  
  help指令会提供默认的git url，也可以自己创建；
  sync-git同时会同步certificate 和 mobileprovision file 。

  ```shell
  ykfastlane certificate sync-git -r xxxxx
  ```

#### 同步git仓库中证书

```shell
ykfastlane certificate sync-git
```

#### 添加本地P2

- 帮助指令
  
  ```shell
  ykfastlane certificate update_cer --help
  ```

- 添加p12

  cer_path: 可以是绝对路径， 也可以是当前终端工作路径的相对路径。

  ```shell
  ykfastlane certificate update_cer -p xxxxx -c xxx/xxx/xxx/xxx.p12
  ```

#### 添加本机profile
  
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

#### 同步苹果后台profile

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

### 打包功能

#### 打包配置

- 配置发包平台参数

  - 帮助指令
  
    ```shell
    ykfastlane archive platform_edit_user --help
    ```

  - 指令样例
  
    ```shell
    ykfastlane archive platform_edit_user -u xxxxx -a xxxxx -f xxxxx -c xxxxx -p xxxxx --verbose
    ```

#### xcworkspace 字段说明
  
#### 打包指令

- 打包指令帮助
  
  ```shell
  ykfastlane archive --help
  ```
  
##### fir平台

- 帮助指令

  ```shell
  ykfastlane archive fir --help
  ```

- 指令样例 【当前终端路径是工程目录】
  
  > xcworkspace 字段使用方式，参考 [xcworkspace 字段说明](#xcworkspace-字段说明)

  ```shell
  ykfastlane archive fir -s ShuabaoQ -e enterprise -x "123/xxx.xcworkspace"
  ```

##### 蒲公英平台

- 帮助指令

  ```shell
  ykfastlane archive pgyer --help
  ```

- 指令样例 【当前终端路径是工程目录】

  > xcworkspace 字段使用方式，参考 [xcworkspace 字段说明](#xcworkspace-字段说明)

  ```shell
  ykfastlane archive pgyer -s YKLeXiangBan  -e enterprise -x "123/xxx.xcworkspace"
  ```

##### test flight 平台

- 帮助指令

  ```shell
  ykfastlane archive tf --help
  ```

- 指令样例

  > xcworkspace 字段使用方式，参考 [xcworkspace 字段说明](#xcworkspace-字段说明)

  ```shell
  ykfastlane archive tf -s YKLeXiangBan  -e enterprise -x "123/xxx.xcworkspace"
  ```
