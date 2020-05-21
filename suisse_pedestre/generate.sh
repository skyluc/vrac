#!/bin/bash -e

if [ "$DEBUG" = "true" ]
then
  set -x
fi

FILE="generated.svg"

FIRST_COL=89
LAST_COL=94
FIRST_ROW=152
LAST_ROW=155

# $1 - width
# $2 - height
function svg_start {
  cat > "$FILE" << EOF
<svg
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
  xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
EOF
echo "  width=\"$1\"" >> "$FILE"
echo "  height=\"$2\"" >> "$FILE"
echo "  viewBox=\"0 0 $1 $2\">" >> "$FILE"
}

function svg_end {
  cat >> "$FILE" << EOF
</svg>
EOF
}

# $1 - layer id
# $2 - layer name
function layer_start {
  cat >> "$FILE" << EOF
   <g
EOF
echo "    inkscape:label=\"$2\"" >> "$FILE"
echo "    id=\"$1\"" >> $FILE
  cat >> "$FILE" << EOF
    inkscape:groupmode="layer"
    style="display:inline"
    sodipodi:insensitive="true">
EOF
}

function layer_end {
  cat >> "$FILE" << EOF
   </g>
EOF
}

# $1 - row
# $2 - col
function imageFond {

  if [ ! -f "21/$2/$1.jpeg" ]
  then
    echo "Missing 21/$2/$1.jpeg"
    return 0
  fi

  imageId="image$IMG_COUNT"
  IMG_COUNT=$(($IMG_COUNT+1))
  
  x=$(((col - FIRST_COL) * 256))
  y=$(((row - FIRST_ROW) * 256))

  cat >> "$FILE" << EOF
    <image
EOF
echo "      xlink:href=\"21/$2/$1.jpeg\"" >> "$FILE"
echo "      x=\"$x\"" >> "$FILE"
echo "      y=\"$y\"" >> "$FILE"
echo "      id=\"$imageId\"" >> "$FILE"
  cat >> "$FILE" << EOF
      width="256"
      height="256"
      style="image-rendering:optimizeSpeed" />
EOF
}

# $1 - row
# $2 - col
function imageChemins {

  if [ ! -f "21/$2/$1.png" ]
  then
    echo "Missing 21/$2/$1.png"
    return 0
  fi

  imageId="image$IMG_COUNT"
  IMG_COUNT=$(($IMG_COUNT+1))
  
  x=$(((col - FIRST_COL) * 256))
  y=$(((row - FIRST_ROW) * 256))

  cat >> "$FILE" << EOF
    <image
EOF
echo "      xlink:href=\"21/$2/$1.png\"" >> "$FILE"
echo "      x=\"$x\"" >> "$FILE"
echo "      y=\"$y\"" >> "$FILE"
echo "      id=\"$imageId\"" >> "$FILE"
  cat >> "$FILE" << EOF
      width="256"
      height="256"
      style="image-rendering:optimizeSpeed" />
EOF
}

# $1 - row
# $2 - col
function imageRandos {

  if [ ! -f "21/$1/$2.png" ]
  then
    echo "Missing 21/$1/$2.png"
    return 0
  fi

  imageId="image$IMG_COUNT"
  IMG_COUNT=$(($IMG_COUNT+1))
  
  x=$(((col - FIRST_COL) * 256))
  y=$(((row - FIRST_ROW) * 256))

  cat >> "$FILE" << EOF
    <image
EOF
echo "      xlink:href=\"21/$1/$2.png\"" >> "$FILE"
echo "      x=\"$x\"" >> "$FILE"
echo "      y=\"$y\"" >> "$FILE"
echo "      id=\"$imageId\"" >> "$FILE"
  cat >> "$FILE" << EOF
      width="256"
      height="256"
      style="image-rendering:optimizeSpeed" />
EOF
}

############
# create svg
##########

IMG_COUNT=1

svg_start $(((LAST_COL - FIRST_COL + 1) * 256)) $(((LAST_ROW - FIRST_ROW + 1) * 256))

layer_start "layer1" "Fond de carte"

for ((col=$FIRST_COL;$col<=$LAST_COL;col++))
do
  for ((row=$FIRST_ROW;$row<=$LAST_ROW;row++))
  do
    imageFond $row $col
  done
done

layer_end

layer_start "layer2" "Chemins"

for ((col=$FIRST_COL;$col<=$LAST_COL;col++))
do
  for ((row=$FIRST_ROW;$row<=$LAST_ROW;row++))
  do
    imageChemins $row $col
  done
done

layer_end

layer_start "layer3" "Randos"

for ((col=$FIRST_COL;$col<=$LAST_COL;col++))
do
  for ((row=$FIRST_ROW;$row<=$LAST_ROW;row++))
  do
    imageRandos $row $col
  done
done

layer_end

svg_end
