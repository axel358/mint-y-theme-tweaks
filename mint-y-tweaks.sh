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
sed -i '8s/#383838/#202020/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i '8s/#383838/#202020/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#base_color
sed -i '10s/#404040/#252525/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i '10s/#404040/#252525/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#borders_color
sed -i '18s/6%/5%/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i '18s/6%/5%/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#separator_color
sed -i '19s/6%/5%/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i '19s/6%/5%/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#vbox and hbox separators
sed -i '2433s/black, 0.9/$borders_color, 0.5/g' src/Mint-Y/gtk-3.0/sass/_common.scss
sed -i '2644s/black, 0.9/$borders_color, 0.5/g' src/Mint-Y/gtk-4.0/sass/_common.scss

#header_bg
sed -i '43s/5%), darken($bg_color, 5%)/5%), darken($bg_color, 2%)/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i '43s/5%), darken($bg_color, 5%)/5%), darken($bg_color, 2%)/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#header_highlight
sed -i '47s/#373737/$header_bg/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i '47s/#373737/$header_bg/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

#dark_sidebar_bg
sed -i '53s/#353535/$bg_color/g' src/Mint-Y/gtk-3.0/sass/_colors.scss
sed -i '53s/#353535/$bg_color/g' src/Mint-Y/gtk-4.0/sass/_colors.scss

echo 'Removing highlight from HdyViewSwitcher'
sed -i '81s/border-color: $selected_bg_color;//g' src/Mint-Y/gtk-3.0/sass/_libhandy.scss

echo 'Darkening Cinnamon'

#base_color
sed -i '8s/#404040/#242424/g' src/Mint-Y/cinnamon/sass/_colors.scss

#bg_color
sed -i '10s/#2f2f2f/#1F1F1F/g' src/Mint-Y/cinnamon/sass/_colors.scss

#favorites-box
sed -i '1420s/5%/1%/g' src/Mint-Y/cinnamon/sass/_common.scss

echo 'Generating themes'
./generate-themes.py

OUT_DIR=usr/share/themes/
INSTALL_DIR=~/.local/share/

echo 'Deleting Mint-X'
rm -r ${OUT_DIR}Mint-X*

echo "Done. Themes are under $OUT_DIR"
while true; do
    read -p "Would you like to install themes to $INSTALL_DIR ? [Y/N] " yn
    case $yn in
        [Yy]* ) cp -r ${OUT_DIR} $INSTALL_DIR; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
