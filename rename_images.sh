#!/bin/bash

# Rename all .JPG files to .jpg recursively
find assets/images -name "*.JPG" -type f | while read file; do
    mv "$file" "${file%.JPG}.jpg"
    echo "Renamed: $file -> ${file%.JPG}.jpg"
done

# Also check for other common uppercase extensions
find assets/images -name "*.PNG" -type f | while read file; do
    mv "$file" "${file%.PNG}.png"
    echo "Renamed: $file -> ${file%.PNG}.png"
done

echo "Renaming complete!"