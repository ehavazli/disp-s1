#!/usr/bin/bash
set -e
set -x # echo on

# Input full directory:
full_dir=delivery_data_full

# output new directory:
new_dir=delivery_data_small
# Match 2 bursts total
# pattern="*08890[56]_iw1*" # California
pattern="*05672[56]-IW1*"

# Layout
mkdir -p $new_dir/input_slcs
mkdir -p $new_dir/dynamic_ancillary_files/static_layers
mkdir -p $new_dir/dynamic_ancillary_files/troposphere_files
mkdir -p $new_dir/dynamic_ancillary_files/ionosphere_files

find "${full_dir}/dynamic_ancillary_files/static_layers/" -name "$pattern" \
    -exec cp {} "$new_dir/dynamic_ancillary_files/static_layers/" \;

# Copy input slcs matching the pattern
# Also match only 4 dates, only in 2022
find "${full_dir}/input_slcs/" -name "$pattern" -name "*20170[234]*" \
    -exec cp {} "$new_dir/input_slcs/" \;

# Copy the full other directories
cp ${full_dir}/dynamic_ancillary_files/troposphere_files/* $new_dir/dynamic_ancillary_files/troposphere_files/
cp ${full_dir}/dynamic_ancillary_files/ionosphere_files/* $new_dir/dynamic_ancillary_files/ionosphere_files/
# Copy the dem and watermask
cp ${full_dir}/dynamic_ancillary_files/dem.tif $new_dir/dynamic_ancillary_files/
cp ${full_dir}/dynamic_ancillary_files/watermask.* $new_dir/dynamic_ancillary_files/

cd $new_dir
# Run the setup config script
python ~/repos/disp-s1/scripts/release/setup_delivery_config.py
