#!/usr/bin/env bash
#===============================================================================
# Script to check/generate local customisations for asciidoctor and asciidoctor-pdf
#
# To check whether there are newer versions of the source files:
# ls -l /opt/homebrew/opt/asciidoctor/libexec/gems/**/data/stylesheets/asciidoctor-default.css
# ls -l /opt/homebrew/Cellar/asciidoctor/**/libexec/gems/**/data/themes/default-theme.yml
#===============================================================================

script_dir=$(dirname $(realpath ${0}))

source_css=/opt/homebrew/opt/asciidoctor/libexec/gems/asciidoctor-2.0.23/data/stylesheets/asciidoctor-default.css
stage_css=~/tmp/css_local.css
target_css=${script_dir}/../gen_html/css_local.css

source_pdf=/opt/homebrew/Cellar/asciidoctor/2.0.23/libexec/gems/asciidoctor-pdf-2.3.15/data/themes/default-theme.yml
stage_pdf=~/tmp/local-theme.yml
target_pdf=${script_dir}/../gen_pdf/local-theme.yml

mkdir -p ~/tmp

cp -p ${source_css} ${stage_css}
sed -i 's/h1:first-child{color:rgba(0,0,0,.85)/h1:first-child{color:#21587/g' ${stage_css}
sed -i 's/color:#7a2518/color:#215687/g' ${stage_css}
sed -i 's/color:#ba3925/color:#215687/g' ${stage_css}
sed -i 's/color:#a53221/color:#215687/g' ${stage_css}
sed -i 's/"Noto Serif"/"Verdana","Arial","Noto Serif"/g' ${stage_css}
sed -i 's/"Open Sans"/"Tahoma","Arial","Open Sans"/g' ${stage_css}

cp -p ${source_pdf} ${stage_pdf}
# NB: Cannot use jq for easier editing as it will not preserve escape sequences
sed -i '/^codespan:/,/  font_family:/ { s/font_color: B12146/font_color: 696969/ }' ${stage_pdf}
sed -i '/^heading:/,/  font_style:/ { s/font_color: \$base_font_color/font_color: 215687/ }' ${stage_pdf}
sed -i '/^title_page:/,/  font_size:/ { s/top: 55%/top: 25%/ }' ${stage_pdf}
sed -i '/^title_page:/,/  font_style:/ { s/font_color: \$role_subtitle_font_color/font_color: 215687/ }' ${stage_pdf}

sha256sum ${target_css} ${stage_css}
sha256sum ${target_pdf} ${stage_pdf}

diff ${target_css} ${stage_css}
diff ${target_pdf} ${stage_pdf}

# code --diff ${target_css} ${stage_css}
# code --diff ${target_pdf} ${stage_pdf}
