#!/usr/bin/env bash
# encoding: utf-8
set -e

WORK=`pwd`

# 输入方案临时目录
OUTPUT=".tmp"
DST_PATH="release"

rm -rf $DST_PATH && mkdir -p $DST_PATH

# 四叶草全拼输入法
rime_cloverpinyin_version="1.1.4"
rime_cloverpinyin_archive="clover.schema-build-${rime_cloverpinyin_version}.zip"
rime_cloverpinyin_download_url="https://github.com/fkxxyz/rime-cloverpinyin/releases/download/${rime_cloverpinyin_version}/${rime_cloverpinyin_archive}"
rm -rf $OUTPUT/.clover && mkdir -p $OUTPUT/.clover && (
    cd $OUTPUT/.clover
    [ -z "${no_download}" ] && curl -LO "${rime_cloverpinyin_download_url}"
    unzip "${rime_cloverpinyin_archive}" -d .
    rm -rf ${rime_cloverpinyin_archive}
    zip -r cloverpinyin.zip ./*
) && \
cp $OUTPUT/.clover/*.zip $OUTPUT

sbxlm_version="20231129"
sbxlm_archive="Sbxlm4iOS.${sbxlm_version}.zip"
input_scheme_name=sbxlm
sbxlm_download_url="https://github.com/sbxlm/sbxlm.github.io/releases/download/${sbxlm_version}/${sbxlm_archive}"
cd $OUTPUT
[ -z "${no_download}" ] && curl -L "${sbxlm_download_url}" -o $input_scheme_name.zip

# 86版极点五笔
# https://github.com/KyleBing/rime-wubi86-jidian
input_scheme_name=rime-wubi86-jidian
rm -rf $OUTPUT/.$input_scheme_name && \
  git clone --depth 1 https://github.com/KyleBing/rime-wubi86-jidian $OUTPUT/.$input_scheme_name && (
    cd $OUTPUT/.$input_scheme_name
    zip -r $input_scheme_name.zip ./*
  ) && \
  cp -R $OUTPUT/.$input_scheme_name/*.zip $OUTPUT

# 星空键道
# 方案来源: https://github.com/xkinput/Rime_JD
input_scheme_name=Rime_JD
rm -rf $OUTPUT/.$input_scheme_name && \
  git clone -b plum --depth 1 https://github.com/xkinput/$input_scheme_name $OUTPUT/.$input_scheme_name && (
    cd $OUTPUT/.$input_scheme_name
    zip -r $input_scheme_name.zip ./*
  ) && \
  cp -R $OUTPUT/.$input_scheme_name/*.zip $OUTPUT

# 星猫键道
# 方案来源: https://github.com/wzxmer/xkjd6-rime
input_scheme_name=xkjd6-rime
rm -rf $OUTPUT/.$input_scheme_name && \
  git clone --depth 1 https://github.com/wzxmer/$input_scheme_name $OUTPUT/.$input_scheme_name && (
    cd $OUTPUT/.$input_scheme_name/xmjd6-Hamster
    zip -r $input_scheme_name.zip ./*
  ) && \
  cp -R $OUTPUT/.$input_scheme_name/xmjd6-Hamster/*.zip $OUTPUT

# 宇浩输入法
# 方案来源：https://github.com/forFudan/yuhao
input_scheme_name=yuhao
rm -rf $OUTPUT/.$input_scheme_name && \
  git clone --depth 1 https://github.com/forFudan/$input_scheme_name $OUTPUT/.$input_scheme_name && (
    cd $OUTPUT/.$input_scheme_name/dist/yuhao/schema
    zip -r $input_scheme_name.zip ./*
  ) && \
  cp -R $OUTPUT/.$input_scheme_name/dist/yuhao/schema/*.zip $OUTPUT

# 虎码输入法
# 方案来源：https://github.com/0ZDragon/rime-huma/tree/main
input_scheme_name=rime-huma
rm -rf $OUTPUT/.$input_scheme_name && \
  git clone -b main --depth 1 https://github.com/0ZDragon/$input_scheme_name $OUTPUT/.$input_scheme_name && (
    cd $OUTPUT/.$input_scheme_name
    zip -r $input_scheme_name.zip ./*
  ) && \
  cp -R $OUTPUT/.$input_scheme_name/*.zip $OUTPUT


# copy
cp -R $OUTPUT/*.zip ${DST_PATH}/ 
