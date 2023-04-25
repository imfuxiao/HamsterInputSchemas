#!/usr/bin/env bash
# encoding: utf-8
set -e

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
    cd $OUTPUT/.xmjd6/xmjd6
    rm -rf README.md default.custom.yaml weasel.custom.yaml
  ) && \
  cp $OUTPUT/.xmjd6/xmjd6/*.yaml ${DST_PATH} && \
  cp $OUTPUT/.xmjd6/xmjd6/*.txt ${DST_PATH} && \
  cp $OUTPUT/.xmjd6/xmjd6/lua/*.lua ${DST_PATH}/lua/ && \
  cp $OUTPUT/.xmjd6/xmjd6/opencc/* ${DST_PATH}/opencc/ && \
  cat $OUTPUT/.xmjd6/xmjd6/rime.lua >> ${DST_PATH}/rime.lua

# 宇浩输入法
# 方案来源：https://github.com/forFudan/yuhao
rm -rf $OUTPUT/.yuhao && \
  git clone --depth 1 https://github.com/forFudan/yuhao $OUTPUT/.yuhao && (
    cd $OUTPUT/.yuhao/schema
    rm -rf default.custom.yaml
  ) &&  \
  cp $OUTPUT/.yuhao/schema/*.yaml ${DST_PATH} && \
  cp -r $OUTPUT/.yuhao/schema/lua/* ${DST_PATH}/lua/ && \
  cp $OUTPUT/.yuhao/schema/opencc/* ${DST_PATH}/opencc/ && \
  echo '-- 宇浩输入法' >> ${DST_PATH}/rime.lua && \
  echo 'yuhao_char_filter = require("yuhao/yuhao_char_filter")' >> ${DST_PATH}/rime.lua && \
  echo 'yuhao_char_first = yuhao_char_filter.yuhao_char_first' >> ${DST_PATH}/rime.lua && \
  echo 'yuhao_char_only = yuhao_char_filter.yuhao_char_only' >> ${DST_PATH}/rime.lua && \
  echo 'yuhao_single_char_only_for_full_code = require("yuhao/yuhao_single_char_only_for_full_code")' >> ${DST_PATH}/rime.lua && \
  echo 'yuhao_postpone_full_code = require("yuhao/yuhao_postpone_full_code")' >> ${DST_PATH}/rime.lua && \
  echo 'yuhao_helper = require("yuhao/yuhao_helper")' >> ${DST_PATH}/rime.lua

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
# 隐藏星猫键道方案依赖的xmjddz-xmjd6cx-xmjd_W-xmjd_Y-xmjd_Z-xmjd6en
ls *.schema.yaml | grep -v pinyin_simp.schema.yaml | grep -v liangfen.schema.yaml \
  | grep -v xmjd6en.schema.schema.yaml | grep -v xmjddz.schema.yaml \
  | grep -v xmjd6cx.schema.yaml | grep -v xmjd_W.schema.yaml \
  | grep -v xmjd_Y.schema.yaml | grep -v xmjd_Z.schema.yaml \
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
# 先将squirrel.yaml拷贝出来
cp -R SharedSupport/* ${DST_PATH}/ 

# TODO: 提前编译
# export DYLD_FALLBACK_LIBRARY_PATH=$DYLD_FALLBACK_LIBRARY_PATH:$PWD/.deps/dist/lib
# .deps/dist/bin/rime_deployer --build ${DST_PATH}

cp -R .deps/share/opencc ${DST_PATH}

# 压缩输入方案
(
  cd .tmp
  zip -r SharedSupport.zip SharedSupport
) && cp $OUTPUT/*.zip .
