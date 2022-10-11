# Ykfastlane

iOS 通用打包工具的终端门户工具
本指令集适用与ruby 2.7.5 ~ 3.0.3

- [Ykfastlane](#ykfastlane)
    - [环境配置](#环境配置)
    - [ykfastlane基础参数配置](#ykfastlane基础参数配置)
    - [证书配置](#证书配置)
    - [打包配置](#打包配置)
    - [打包功能](#打包功能)

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
  
```shell
ykfastlane init config -f http://gitlab.yeahka.com/App/iOS/ykfastlane.git  -t 5ef50d9f-6426-4c4c-94f8-f08a4f0e1611
```

- 安装fastlane脚本

```shell
ykfastlane init sync-script
```

### 证书配置

- 配置证书管理仓库
```shell
ykfastlane certificate edit_config -r http://gitlab.yeahka.com/App/iOS/certificates/YKCertificateProfiles.git
```

- 同步证书

```shell
ykfastlane certificate sync-cer
```

- 添加本机证书
    
  - 帮助指令
  
  ```shell
  ykfastlane certificate update_cer --help
  ```

  - 添加p12

  ```shell
  ykfastlane certificate update_cer -p xxxxx -c xxx/xxx/xxx/xxx.p12
  ```

- 同步苹果后台profile

  - 帮助指令
  ```shell
  ykfastlane certificate sync_apple_profile --help
  ```
  - 同步profile
  
    可以通过bundle_id同步
    也可以通过工程workspace同步
  
    指令样例：【当前终端路径是工程目录】
    ```shell
    ykfastlane certificate sync_apple_profile -u xxxxxxx -p xxxxx -b "com.Isale.cn.YKLeXiangBan,com.yeahka.agent","com.lsale.cn.LSsaleChainForIpad,com.topsida.lyl","com.YeahKa.KuaiFuBa","com.YeahKa.KuaiFuBa123" -w ./
    ```

### 打包配置

- 配置发包平台参数

  - 帮助指令
  ```shell
  ykfastlane archive platform_edit_user --help
  ```
  - 指令样例
  ```shell
  ykfastlane archive platform_edit_user -u xxxxx -a xxxxx -f xxxxx -c xxxxx -p xxxxx --verbose
  ```

### 打包功能
- 打包功能
  
  - 打包指令帮助
  ```shell
  ykfastlane archive --help
  ```
  
  - fir平台
    
    帮助指令
    ```shell
    ykfastlane archive fir --help
    ```
    
     指令样例 【当前终端路径是工程目录】
     ```shell
     ykfastlane archive fir -s ShuabaoQ -e enterprise
     ```

  - 蒲公英平台

    帮助指令
    ```shell
    ykfastlane archive pgyer --help
    ```

    指令样例 【当前终端路径是工程目录】
    ```shell
    ykfastlane archive pgyer -s YKLeXiangBan  -e enterprise
    ```

  - test flight 平台

    帮助指令
    ```shell
    ykfastlane archive tf --help
    ```

    指令样例 【当前终端路径是工程目录】
    ```shell
    ykfastlane archive tf -s YKLeXiangBan  -e enterprise
    ```