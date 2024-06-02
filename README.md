# RIME 输入方案

感谢大家使用仓输入法，仓输入法的「方案下载」功能已完成，后续「仓」内置输入方案将会迁移至苹果的「CloudKit」中，不在跟随 App 一起发布。

## 方案版权(或授权)

为了避免版权上的纠纷，上传方案需要满足：

* 您是否是方案的作者，或者您有方案作者的授权。
* 如果您是在别人方案上做的改造，请确认自己是否具有分发方案的权力。

## 如何上传方案？

1. 使用苹果账号登录 [仓输入方案管理](https://ihsiao.com/apps/hamster/manage)
2. 在方案管理中维护自己的输入方案

注意：

* 首次登录需要授权，请按网页提示内容发邮件给我，另外邮件内容请附上您的输入方案。
* 上传方案文件上限为 100 MB，如您的方案文件大于此限制，请邮件联系我，由我代为上传。

## 方案规约

为了防止方案之间相互冲突，输入方案需要遵守一些规则：

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

* 上传方案的 zip 包不要包含根目录，嵌套一层目录会导致部署失败，已[**天行键**](https://github.com/wzxmer/rime-txjx)的 zip 包制作过程为例:

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

# 已支持的方案（排名不分先后）

* [🍀四叶草拼音输入方案](https://github.com/fkxxyz/rime-cloverpinyin)
* [86版极点五笔](https://github.com/KyleBing/rime-wubi86-jidian)
* [星空键道6](https://github.com/xkinput/Rime_JD)
* [星猫键道](https://github.com/hugh7007/xmjd6-rere)
* [宇浩输入法](https://github.com/forFudan/yuhao)

如有侵权, 请联系我删除.