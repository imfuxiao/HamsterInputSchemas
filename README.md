# RIME输入方案

感谢大家使用仓输入法，仓输入法的云端下载功能已完成。后续仓内置输入方案将迁移至云端，不会在随 App 一起发布商店。

> 这里的云端是指 Apple 提供的 CloudKit。

注意：之前已经内置到 App 中的方案，我会先一步推送至云端，后续请作者发邮件给我，我会为将您加入至单独维护云端方案 App 的测试列表中。

# 如何上传方案至仓的云端？

基于安全原因，仓输入法不会内置开源方案的上传/修改/删除功能，此功能我已开发了单独的 App，但不会上架，只会发布 TF 版本。

如果您需要将自己的方案上传至云端， 目前暂行步骤是：

1. Fork 本仓库，参考 `build.sh` 中已有的输入方案的脚本，并向其中添加您的输入方案。（如果这步太难，您也可以直接修改 README.md 中“云端支持方案”部分，添加您的输入方案信息）
2. 向我的邮箱（morse.hsiao@gmail.com）发封邮件，邮件中请附上您的 iCloud 账户，我会将您的 iCloud 账户添加到 TF 版本测试员列表中。
3. 在我添加后，您的 iCloud 对应的邮箱会有一封邀请邮件，点击链接网页会显示一个邀请码，在 TestFlight 应用中输入这个邀请码，您就可以在 TestFlight 中看到「仓输入方案管理」应用了。

因为 App 不收集大家的用户信息，所以不会有账户权限的限制，请大家自觉遵守：只修改/删除/发布自己的输入方案。

# 上传云端的方案有什么要求

1. 方案需要是自己创作的，且自己有版权的。这一步是为了防止后续不必要的争端。
2. 为了防止方案之间相互冲突，方案必须遵守一些规则：

    * 方案中不要使用 `rime.lua` 文件，且 `lua` 采用**模块化方式**编写。

    取消 `rime.lua` 的[参考示例](https://github.com/wzxmer/rime-txjx/blob/main/txjx.schema.yaml), 这是 [**天行键**](https://github.com/wzxmer/rime-txjx) 输入方案的配置。

    ```yaml
    ...
      translators:
        - lua_translator@*txjx_calculator
        - lua_translator@*txjx_time
        - lua_translator@*txjx_zimu
    ...
    ```

    注意：这种新的配置方法，可能不支持 rime 的低版本，如果您有向下兼容的需求，请提供一份仓的专属版本。

    * 方案文件的文件名需要有统一前缀格式，比如[**天行键**](https://github.com/wzxmer/rime-txjx)的方案文件是已 `txjx`开头。
3. 上传方案的 zip 包不要包含根目录，嵌套一层目录会导致部署失败，已[**天行键**](https://github.com/wzxmer/rime-txjx)的 zip 包制作过程为例: 

```sh
git clone https://github.com/wzxmer/rime-txjx
cd rime-txjx
# 制作云端使用的 zip 文件
zip -r rime-txjx.zip *

# 查看 zip 文件内容，你会看到 zip 包的目录结构是已用户目录文件为树的根节点的。
zipinfo -1 rime-txjx.zip

README.md
default.custom.yaml
...
lua/
lua/txjx_smartTwo.lua
...
opencc/
opencc/SGCharacters.txt
...
opencc/txjx.emoji.json
txjx.custom.yaml
...
```

# 云端支持方案（排名不分先后）

* [🍀四叶草拼音输入方案](https://github.com/fkxxyz/rime-cloverpinyin)
* [86版极点五笔](https://github.com/KyleBing/rime-wubi86-jidian)
* [星空键道6](https://github.com/xkinput/Rime_JD)
* [星猫键道百万词库版](https://github.com/wzxmer/xkjd6-rime)
* [宇浩输入法](https://github.com/forFudan/yuhao)

如有侵权, 请联系我删除. 