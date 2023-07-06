#!/usr/bin/env bash
# encoding: utf-8
set -e

WORK=`pwd`

# 下载已编译过的rimelib
rime_version=1.8.5
rime_git_hash=08dd95f

if [[ ! -d .deps ]] 
then
  rime_archive="rime-${rime_git_hash}-macOS.tar.bz2"
  rime_download_url="https://github.com/rime/librime/releases/download/${rime_version}/${rime_archive}"

  rime_deps_archive="rime-deps-${rime_git_hash}-macOS.tar.bz2"
  rime_deps_download_url="https://github.com/rime/librime/releases/download/${rime_version}/${rime_deps_archive}"

  rm -rf .deps && mkdir -p .deps && (
      cd .deps
      [ -z "${no_download}" ] && curl -LO "${rime_download_url}"
      tar --bzip2 -xf "${rime_archive}"
      [ -z "${no_download}" ] && curl -LO "${rime_deps_download_url}"
      tar --bzip2 -xf "${rime_deps_archive}"
  )
fi

# # 输入方案临时目录
OUTPUT=".tmp"
DST_PATH="$OUTPUT/SharedSupport"
rm -rf .plum $OUTPUT
mkdir -p $DST_PATH
mkdir -p $DST_PATH/lua
mkdir -p $DST_PATH/opencc
mkdir -p $DST_PATH/build
git clone --depth 1 https://github.com/rime/plum.git $OUTPUT/.plum

# 可以在这里添加rime的开源输入方案
# https://github.com/rime/rime-double-pinyin.git
# for package in essay prelude rime-double-pinyin; do
for package in prelude; do
  bash $OUTPUT/.plum/scripts/install-packages.sh "${package}" $DST_PATH
done

# 四叶草全拼输入法
rime_cloverpinyin_version="1.1.4"
rime_cloverpinyin_archive="clover.schema-build-${rime_cloverpinyin_version}.zip"
rime_cloverpinyin_download_url="https://github.com/fkxxyz/rime-cloverpinyin/releases/download/${rime_cloverpinyin_version}/${rime_cloverpinyin_archive}"
rm -rf $OUTPUT/.clover && mkdir -p $OUTPUT/.clover && (
    cd $OUTPUT/.clover
    [ -z "${no_download}" ] && curl -LO "${rime_cloverpinyin_download_url}"
    unzip "${rime_cloverpinyin_archive}" -d .
    rm -rf ${rime_cloverpinyin_archive}
) && \
cp -R $OUTPUT/.clover/*.yaml $DST_PATH/ && \
cp -R $OUTPUT/.clover/build/* $DST_PATH/build/ && \
cp -R $OUTPUT/.clover/opencc/* ${DST_PATH}/opencc/

# 内置极点五笔, qq五笔, 小鹤双拼
#internalSchemas=("wubi86_jidian" "wubi86_qq" "double_pinyin")
internalSchemas=("double_pinyin")
for schema in "${internalSchemas[@]}"
do
  cp -R Schemas/${schema}/* $DST_PATH/
done

# 五笔方案
# 方案来源: https://github.com/networm/Rime
rm -rf $OUTPUT/.networm && \
  git clone --depth 1 https://github.com/networm/Rime $OUTPUT/.networm && (
    cd $OUTPUT/.networm
    rm -rf .git .gitignore README.md rime.lua default.custom.yaml weasel.custom.yaml
  ) && cp -R $OUTPUT/.networm/* $DST_PATH/

# 星空键道
# 方案来源: https://github.com/xkinput/Rime_JD
rm -rf $OUTPUT/.rime_jd && \
  bash $OUTPUT/.plum/scripts/install-packages.sh xkinput/Rime_JD@plum $OUTPUT/.rime_jd && \
  cp $OUTPUT/.rime_jd/xkjd6.*.yaml ${DST_PATH} && \
  cp $OUTPUT/.rime_jd/lua/* ${DST_PATH}/lua/ && \
  cp $OUTPUT/.rime_jd/opencc/EN2en.* ${DST_PATH}/opencc/ && \
  cat $OUTPUT/.rime_jd/rime.lua >> ${DST_PATH}/rime.lua

# 星猫键道
# 方案来源: https://github.com/wzxmer/xkjd6-rime
rm -rf $OUTPUT/.xmjd6 && \
  git clone --depth 1 https://github.com/wzxmer/xkjd6-rime $OUTPUT/.xmjd6 && (
    cd $OUTPUT/.xmjd6/xmjd6-Hamster
    rm -rf README.md default.custom.yaml
  ) && \
  cp $OUTPUT/.xmjd6/xmjd6-Hamster/*.yaml ${DST_PATH} && \
  cp $OUTPUT/.xmjd6/xmjd6-Hamster/*.txt ${DST_PATH} && \
  cp $OUTPUT/.xmjd6/xmjd6-Hamster/lua/*.lua ${DST_PATH}/lua/ && \
  cp $OUTPUT/.xmjd6/xmjd6-Hamster/opencc/* ${DST_PATH}/opencc/ && \
  cat $OUTPUT/.xmjd6/xmjd6-Hamster/rime.lua >> ${DST_PATH}/rime.lua

# 宇浩输入法
# 方案来源：https://github.com/forFudan/yuhao
mkdir -p $DST_PATH/yuhao
rm -rf $OUTPUT/.yuhao && \
  git clone --depth 1 https://github.com/forFudan/yuhao $OUTPUT/.yuhao && (
    cd $OUTPUT/.yuhao/dist/yuhao/schema
    rm -rf default.custom.yaml
  ) &&  \
  cp $OUTPUT/.yuhao/dist/yuhao/schema/*.yaml ${DST_PATH} && \
  cp $OUTPUT/.yuhao/dist/yuhao/schema/yuhao/*.yaml ${DST_PATH}/yuhao/ && \
  cp -r $OUTPUT/.yuhao/dist/yuhao/schema/lua/* ${DST_PATH}/lua/ && \
  echo '' >> ${DST_PATH}/rime.lua && \
  cat $OUTPUT/.yuhao/dist/yuhao/schema/rime.lua >> ${DST_PATH}/rime.lua

# 虎码输入法
# 方案来源：https://github.com/0ZDragon/rime-huma/tree/main
rm -rf $OUTPUT/.tiger && \
	git clone https://github.com/0ZDragon/rime-huma -b main $OUTPUT/.tiger && \
	cp $OUTPUT/.tiger/* $DST_PATH/

# 绘文字
# 方案来源: https://github.com/rime/rime-emoji
rime_emoji_version="15.0"
rime_emoji_archive="rime-emoji-${rime_emoji_version}.zip"
rime_emoji_download_url="https://github.com/rime/rime-emoji/archive/refs/tags/${rime_emoji_version}.zip"
rm -rf $OUTPUT/.emoji && mkdir -p $OUTPUT/.emoji && (
    cd $OUTPUT/.emoji
    [ -z "${no_download}" ] && curl -Lo "${rime_emoji_archive}" "${rime_emoji_download_url}"
    unzip "${rime_emoji_archive}" -d .
    rm -rf ${rime_emoji_archive}
    cd rime-emoji-${rime_emoji_version}
    for target in category word; do
      ${WORK}/.deps/bin/opencc -c ${WORK}/.deps/share/opencc/t2s.json -i opencc/emoji_${target}.txt > ${target}.txt
      # workaround for rime/rime-emoji#48
      # macOS sed 和 GNU sed 不同，见 https://stackoverflow.com/a/4247319/6676742
      sed -i'.original' -e 's/鼔/鼓/g' ${target}.txt
      cat ${target}.txt opencc/emoji_${target}.txt | awk '!seen[$1]++' > ../emoji_${target}.txt
    done
  ) && \
cp ${OUTPUT}/.emoji/emoji_*.txt ${DST_PATH}/opencc/ && \
cp ${OUTPUT}/.emoji/rime-emoji-${rime_emoji_version}/opencc/emoji.json ${DST_PATH}/opencc/

# 整理 DST_PATH 输入方案文件, 生成最终版版本default.yaml
pushd "${DST_PATH}" > /dev/null

# 减少essay.txt词库
# awk '($2 >= 500) {print}' essay.txt > essay.txt.min
# mv essay.txt.min essay.txt

# sed -n '{
#   s/^version: \(["]*\)\([0-9.]*\)\(["]*\)$/version: \1\2.minimal\3/
#   /^#以下爲詞組$/q;p
# }' luna_pinyin.dict.yaml > luna_pinyin.dict.yaml.min
# mv luna_pinyin.dict.yaml.min luna_pinyin.dict.yaml

# for schema in *.schema.yaml; do
#   sed '{
#     s/version: \(["]*\)\([0-9.]*\)\(["]*\)$/version: \1\2.minimal\3/
#     s/\(- stroke\)$/#\1/
#     s/\(- reverse_lookup_translator\)$/#\1/
#   }' ${schema} > ${schema}.min
#   mv ${schema}.min ${schema}
# done

# 隐藏五笔方案依赖的pinyin_simp.schema.yaml
# 隐藏星猫键道方案依赖的xmjd6.dz/cx/W/Y/Z/en
# 隐藏宇浩输入法依赖的 yuhao_pinyin / yuhao_chaifen / yuhao_chaifen_tw
ls *.schema.yaml | grep -v pinyin_simp.schema.yaml | grep -v liangfen.schema.yaml \
  | grep -v xmjd6.en.schema.yaml \
  | grep -v xmjd6.cx.schema.yaml | grep -v xmjd6.W.schema.yaml \
  | grep -v xmjd6.Y.schema.yaml | grep -v xmjd6.Z.schema.yaml \
  | grep -v yuhao_tc.schema.yaml | grep -v yuhao_pinyin.schema.yaml | grep -v yuhao_chaifen.schema.yaml | grep -v yuhao_chaifen_tw.schema.yaml | grep -v yustar_chaifen.schema.yaml \
  | sed 's/^\(.*\)\.schema\.yaml/  - schema: \1/' > schema_list.yaml
# 这里不需要只替换luna_pinyin
# grep -Ff schema_list.yaml default.yaml > schema_list.yaml.min
# mv schema_list.yaml.min schema_list.yaml
sed '{
  s/^config_version: \(["]*\)\([0-9.]*\)\(["]*\)$/config_version: \1\2.minimal\3/
  /- schema:/d
  /^schema_list:$/r schema_list.yaml
}' default.yaml > default.yaml.min
rm schema_list.yaml
mv default.yaml.min default.yaml

popd > /dev/null


# copy
cp -R SharedSupport/*.yaml ${DST_PATH}/ 

# TODO: 提前编译
# export DYLD_FALLBACK_LIBRARY_PATH=$DYLD_FALLBACK_LIBRARY_PATH:$PWD/.deps/dist/lib
# .deps/dist/bin/rime_deployer --build ${DST_PATH}

cp -R .deps/share/opencc ${DST_PATH}

# 压缩输入方案
(
  cd .tmp
  zip -r SharedSupport.zip SharedSupport
) && cp $OUTPUT/*.zip .
