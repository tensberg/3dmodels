$fn = 50;

tolerance = 1;

bead_width = 5;
bead_inner_diameter = 2;
bead_height = 4;

image_width = 141;
image_length = 141;

outer_border_width = 10;
outer_border_thickness = 2;
inner_border_width = bead_width * 0.5;

outer_margin_width = (tolerance + outer_border_width) * 2;
margin_height = (tolerance + outer_border_thickness) * 2;
frame_width = image_width + outer_margin_width;
frame_length = image_length + outer_margin_width;
frame_height = bead_height + margin_height;
frame_offset = 4;

connector_tolerance = 0.1;
connector_diameter = 5;
connector_height = frame_height / 2 / 2;

hanger_height_offset = 2;
hanger_length_offset = 5;
hanger_outer_diameter = 12;
hanger_inner_diameter = 6;

textframe_width = frame_width / 2;
textframe_length = 20;
textframe_border = 2;
textframe_inset = 2;

textframe_x = (frame_width-textframe_width) / 2;
textframe_y = frame_length - textframe_length;

// lower border half
border_half();
translate([0, 0, frame_height / 2])
    connectors();

// hanger
translate([frame_width / 2, -hanger_length_offset, hanger_height_offset]) {
    difference() {
        cylinder(d = hanger_outer_diameter, h = frame_height - hanger_height_offset*2);
        // inner hole
        translate([0,0,-1])
            cylinder(d = hanger_inner_diameter, h = frame_height);
        // frame cutout
        translate([0, outer_border_width/2 + hanger_length_offset - connector_tolerance, frame_height/2])
            cube([hanger_outer_diameter + 2, outer_border_width, bead_height], center = true);
    }
}

// upper border half
translate([frame_width + 10, 0, 0]) {
    difference() {
        border_half();

        translate([0, 0, frame_height / 2 - connector_height - connector_tolerance])
            connectors(connector_tolerance * 2, connector_tolerance + 1);
    }
}

// deko
translate([40, 40, 0]) {
    for (x = [0:1:3]) {
        for (y = [0:1:1]) {
            translate([(bead_width + 2)*3*x, (bead_width + 2)*3*y, 0])
                bead_deko();
        }
    }
}


module border_half() {
    difference() {
        // outer border of frame
        union() {
            linear_extrude(frame_height/2)
                offset(frame_offset) offset(-frame_offset)
                    square([frame_width, frame_length]);
        
            textbox();
        }

        // inner border of frame
        difference() {
            inner_margin_width = (tolerance + inner_border_width) * 2;
            translate([outer_border_width + inner_border_width + tolerance, outer_border_width + inner_border_width + tolerance, -1])
                cube([image_width - inner_margin_width, image_length - inner_margin_width, frame_height + 2]);
            textbox();
        }

        // image opening
        translate([outer_border_width, outer_border_width, outer_border_thickness + tolerance])
            cube([image_width + tolerance*2, image_length + tolerance*2, bead_height + tolerance*2]);

        // passepartout
        passepartout_width = image_width - (inner_border_width + tolerance) * 2;
        passepartout_length = image_length - (inner_border_width + tolerance) * 2;
        difference() {
            translate([outer_border_width + tolerance + inner_border_width + passepartout_width/2, outer_border_width + tolerance + inner_border_width + passepartout_length/2, outer_border_thickness])
                mirror([0,0,1])
                    linear_extrude(height = outer_border_thickness + 1, scale=1.1)
                        square([passepartout_width, passepartout_length], center=true);
            
            textbox();
        }
        
        // textbox inset
        translate([textframe_x + textframe_border, textframe_y + textframe_border, - textframe_inset])
            linear_extrude(textframe_inset + 1)
                offset(frame_offset-1) offset(-frame_offset+1)
                    square([textframe_width - textframe_border * 2, textframe_length - textframe_border * 2]);
    }
    
    // text
    translate([frame_width / 2, frame_length - textframe_length / 2, 0])
        linear_extrude(textframe_inset)
            mirror([0,1])
                text("Nikolas 2012", halign="center", valign="center", size = 10, font="Comic neue");

}

module textbox() {
    linear_extrude(frame_height/2)
        translate([textframe_x, textframe_y])
            offset(frame_offset) offset(-frame_offset)
                square([textframe_width, textframe_length]);
}

module connectors(tolerance_offset = 0, height_offset = 0) {
    for (x = [0:1:1]) {
        for (y = [0:0.5:1]) {
            connector(tolerance_offset, height_offset, x, y);
        }
    }
    connector(tolerance_offset, height_offset, 0.5, 0);
    connector(tolerance_offset, height_offset, 0.5, 1);
}

module connector(tolerance_offset, height_offset, x, y) {
    translate([outer_border_width / 2 + x*(frame_width - outer_border_width), outer_border_width / 2 + y*(frame_length - outer_border_width), 0])
        cylinder(d=connector_diameter + tolerance_offset, h=connector_height + tolerance_offset + height_offset);
}

module bead_deko() {
    deko_height = 2;
    rowscols = 3;
    difference() {
        beads(rowscols, rowscols, deko_height);
        translate([0, 0, deko_height/2])
            cube([bead_width * rowscols, bead_width * rowscols, deko_height/2 + 1]);
    }
}

module beads(rows = 1, cols = 1, height = bead_height, overlap = 0.2) {
    linear_extrude(height) {
        difference() {
            // draw the beads
            union() {
                for (x = [0:1:rows - 1]) {
                    for (y = [0:1:cols - 1]) {
                            translate([bead_width * x, bead_height * y]) {
                                difference() {
                                    circle(d = bead_width + overlap);
                                    circle(d = bead_inner_diameter);
                                }
                            }
                        }
                    }
                }

            // cut off the outer overlap
            translate([-bead_width/2, -bead_width/2]) {
                difference() {
                    translate([-1, -1])
                        square([bead_width*rows + overlap*2 + 2, bead_width*cols + overlap*2 + 2]);
                    square([bead_width*rows, bead_width*cols]);
                }
            }
        }
    }
}