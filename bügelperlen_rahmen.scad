tolerance = 1;

bead_width = 5;
bead_height = 4;

image_width = 141;
image_length = 141;

outer_border_width = 10;
outer_border_thickness = 3;
inner_border_width = bead_width *1.5;

outer_margin_width = (tolerance + outer_border_width) * 2;
margin_height = (tolerance + outer_border_thickness) * 2;
frame_width = image_width + outer_margin_width;
frame_length = image_length + outer_margin_width;
frame_height = bead_height + margin_height;


difference() {
    // outer border of frame
    cube([frame_width, frame_length, frame_height]);

    // inner border of frame
    inner_margin_width = (tolerance + inner_border_width) * 2;
    translate([outer_border_width + inner_border_width + tolerance, outer_border_width + inner_border_width + tolerance, -1])
        cube([image_width - inner_margin_width, image_length - inner_margin_width, frame_height + 2]);

    // image opening
    translate([outer_border_width, outer_border_width, outer_border_thickness + tolerance])
        cube([image_width + tolerance*2, image_length + tolerance*2, bead_height + tolerance*2]);
}
