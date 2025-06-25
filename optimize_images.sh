#!/bin/bash

# FFmpeg Image Optimization Script for All Ann Assessment Directories
# This script compresses images and overwrites the originals

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}Error: ffmpeg is not installed${NC}"
    echo "Install ffmpeg:"
    echo "  macOS: brew install ffmpeg"
    echo "  Ubuntu: sudo apt update && sudo apt install ffmpeg"
    echo "  Windows: Download from https://ffmpeg.org/download.html"
    exit 1
fi

# Configuration
BASE_DIR="assets/images/ann_assessment"
MAX_WIDTH=800
MAX_HEIGHT=600
QUALITY=75
TEMP_SUFFIX="_temp_optimized"

# Check if base directory exists
if [ ! -d "$BASE_DIR" ]; then
    echo -e "${RED}Error: Directory $BASE_DIR not found${NC}"
    exit 1
fi

echo -e "${BLUE}FFmpeg Image Optimization Starting...${NC}"
echo "Base directory: $BASE_DIR"
echo "Max size: ${MAX_WIDTH}x${MAX_HEIGHT}"
echo "Quality: $QUALITY%"
echo ""

# Initialize counters
total_files=0
total_original_size=0
total_optimized_size=0
failed_files=0

# Find all subdirectories in ann_assessment
for dir in "$BASE_DIR"/*/ ; do
    [ ! -d "$dir" ] && continue
    
    dir_name=$(basename "$dir")
    echo -e "${YELLOW}Processing directory: $dir_name${NC}"
    
    # Process each image file in the directory
    for file in "$dir"*.{jpg,jpeg,JPG,JPEG,png,PNG} 2>/dev/null; do
        # Skip if no files match the pattern
        [[ ! -f "$file" ]] && continue
        
        filename=$(basename "$file")
        extension="${filename##*.}"
        name="${filename%.*}"
        temp_file="${file}${TEMP_SUFFIX}.jpg"
        
        # Get original file size
        original_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
        original_kb=$(echo "scale=1; $original_size/1024" | bc 2>/dev/null || echo "$(($original_size/1024))")
        
        echo -e "  ${YELLOW}Processing:${NC} $filename (${original_kb}KB)"
        
        # FFmpeg optimization with error handling
        if ffmpeg -i "$file" \
            -vf "scale='min($MAX_WIDTH,iw)':'min($MAX_HEIGHT,ih)':force_original_aspect_ratio=decrease" \
            -q:v $((31-$QUALITY*31/100)) \
            -y \
            "$temp_file" \
            -loglevel error 2>/dev/null; then
            
            # Get optimized file size
            optimized_size=$(stat -c%s "$temp_file" 2>/dev/null || stat -f%z "$temp_file" 2>/dev/null)
            optimized_kb=$(echo "scale=1; $optimized_size/1024" | bc 2>/dev/null || echo "$(($optimized_size/1024))")
            
            # Calculate compression ratio
            if [ "$original_size" -gt 0 ]; then
                compression_ratio=$(echo "scale=1; (1-$optimized_size/$original_size)*100" | bc 2>/dev/null || echo "50")
            else
                compression_ratio="0"
            fi
            
            # Replace original with optimized version
            if [ -f "$temp_file" ]; then
                # Determine output filename (always .jpg)
                if [[ "$extension" =~ ^[Pp][Nn][Gg]$ ]]; then
                    output_file="${file%.*}.jpg"
                    rm "$file"  # Remove original PNG
                else
                    output_file="$file"
                fi
                
                mv "$temp_file" "$output_file"
                echo -e "    ${GREEN}✓ Optimized:${NC} ${optimized_kb}KB (${compression_ratio}% reduction)"
                
                # Update totals
                total_files=$((total_files + 1))
                total_original_size=$((total_original_size + original_size))
                total_optimized_size=$((total_optimized_size + optimized_size))
            else
                echo -e "    ${RED}✗ Temp file creation failed${NC}"
                failed_files=$((failed_files + 1))
            fi
        else
            echo -e "    ${RED}✗ FFmpeg processing failed${NC}"
            failed_files=$((failed_files + 1))
            # Clean up temp file if it exists
            [ -f "$temp_file" ] && rm "$temp_file"
        fi
    done
    
    echo ""
done

# Summary
echo -e "${GREEN}=== Optimization Summary ===${NC}"
echo "Files processed: $total_files"
echo "Files failed: $failed_files"

if [ $total_files -gt 0 ]; then
    total_original_mb=$(echo "scale=2; $total_original_size/1024/1024" | bc 2>/dev/null || echo "$(($total_original_size/1024/1024))")
    total_optimized_mb=$(echo "scale=2; $total_optimized_size/1024/1024" | bc 2>/dev/null || echo "$(($total_optimized_size/1024/1024))")
    total_savings=$(echo "scale=1; (1-$total_optimized_size/$total_original_size)*100" | bc 2>/dev/null || echo "50")
    
    echo "Original total size: ${total_original_mb}MB"
    echo "Optimized total size: ${total_optimized_mb}MB"
    echo "Total space saved: ${total_savings}%"
    echo ""
    echo -e "${GREEN}All images have been optimized and replaced!${NC}"
else
    echo -e "${YELLOW}No image files found to process.${NC}"
fi