#!/usr/bin/bash

THEMES_DIR=mint-themes

if [ ! -d "$THEMES_DIR" ]; then
    git clone https://github.com/linuxmint/mint-themes
fi

cd $THEMES_DIR

echo 'Darkening assets'

#delete relevant assets only
find . -wholename '*src/Mint-Y/*gtk-4.0/assets/*unchecked*dark*png' -type f -delete
find . -wholename '*src/Mint-Y/*gtk-3.0/assets/*unchecked*dark*png' -type f -delete

#replace colors
find . -wholename '*src/Mint-Y/*gtk-4.0/assets.svg' -type f -exec sed -i 's/'2d2d2d'/'1b1b1b'/gI' {} \;
find . -wholename '*src/Mint-Y/*gtk-3.0/assets.svg' -type f -exec sed -i 's/'2d2d2d'/'1b1b1b'/gI' {} \;

#render variations
find . -wholename '*src/Mint-Y/variations/*gtk-4.0/render-assets.sh' -type f -execdir bash '{}' \;
find . -wholename '*src/Mint-Y/variations/*gtk-3.0/render-assets.sh' -type f -execdir bash '{}' \;

echo 'Darkening GTK3 and GTK4'

#bg_color
sed -i 's/#383838/#202020/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/#383838/#202020/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#base_color
sed -i 's/#ffffff, #404040/#ffffff, #252525/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/#ffffff, #404040/#ffffff, #252525/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#borders_color, separator_color
sed -i 's/darken($bg_color, 6%)/darken($bg_color, 5%)/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/darken($bg_color, 6%)/darken($bg_color, 5%)/g' src/Mint-Y/gtk-4.0/sass/_colors.scss
sed -i 's/darken($bg_color,6%)/darken($bg_color, 5%)/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/darken($bg_color,6%)/darken($bg_color, 5%)/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#vbox and hbox separators
sed -i 's/  background-color: transparentize(black, 0.9);/  background-color: transparentize($borders_color, 0.5);/g' src/Mint-Y/gtk-4.0/sass/_common.scss
sed -i 's/  background-color: transparentize(black, 0.9);/  background-color: transparentize($borders_color, 0.5);/g' src/Mint-Y/gtk-3.0/sass/_common.scss

#header_bg
sed -i 's/darken($bg_color, 5%), darken($bg_color, 5%)/darken($bg_color, 5%), darken($bg_color, 2%)/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/darken($bg_color, 5%), darken($bg_color, 5%)/darken($bg_color, 5%), darken($bg_color, 2%)/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#header_highlight
sed -i 's/#EEEEEE, #373737/#EEEEEE, $header_bg/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/#EEEEEE, #373737/#EEEEEE, $header_bg/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#dark_sidebar_bg
sed -i 's/5%), #353535/5%), $bg_color/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/5%), #353535/5%), $bg_color/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#tooltip_bg_color
sed -i 's/#fbeaa0/$bg_color/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/#fbeaa0/$bg_color/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#tooltip_fg_color
sed -i 's/#4a4a4a/$text_color/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/#4a4a4a/$text_color/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#tooltip_border_color
sed -i 's/#d0d0d0/$borders_color/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i 's/#d0d0d0/$borders_color/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

echo 'Removing highlight from HdyViewSwitcher'
sed -i 's/border-color: $selected_bg_color;//g' src/Mint-Y/gtk-3.0/sass/_libhandy.scss

echo 'Darkening Cinnamon'

#base_color
sed -i 's/#404040/#242424/g' src/Mint-Y/cinnamon/sass/_colors.scss

#bg_color
sed -i 's/#2f2f2f/#1F1F1F/g' src/Mint-Y/cinnamon/sass/_colors.scss


#tooltip_bg_color
sed -i 's/#fbeaa0/$bg_color/g' src/Mint-Y/cinnamon/sass/_colors.scss

#tooltip_fg_color
sed -i 's/#4a4a4a/$text_color/g' src/Mint-Y/cinnamon/sass/_colors.scss

#tooltip_border_color
sed -i 's/#d0d0d0/$borders_color/g' src/Mint-Y/cinnamon/sass/_colors.scss

#favorites-box
sed -i 's/background-color: darken($base_color, 5%);/background-color: darken($base_color, 1%);/g' src/Mint-Y/cinnamon/sass/_common.scss

echo 'Generating themes'
./generate-themes.py

echo 'Deleting Mint-X'
rm -r usr/share/themes/Mint-X*

echo 'Done. Themes are under usr/share/themes/'
