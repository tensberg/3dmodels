use <../module/multicolor.scad>

module body_color() {
    multicolor("Cyan") children();
}

module highlight_color() {
    multicolor("DarkOrange") children();
}

$fn = 50;

current_side = "ALL";
//current_side = "lower";
//current_side = "upper";

module side(side) {
    if (current_side != "ALL" && current_side != side) {
        // ignore children
    } else {
        children();
    }
}

tolerance = 1;

bead_width = 5;
bead_inner_diameter = 2;
bead_height = 4;

image_width = 141;
image_length = 141;

outer_border_width = 8;
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

hanger_height = frame_height / 2;
hanger_length_offset = 5;
hanger_connector_length = outer_border_width*2/3;
hanger_outer_diameter = 12;
hanger_inner_diameter = 6;
hanger_radius = hanger_outer_diameter / 2;
hanger_connector_width = hanger_inner_diameter;
hanger_connector_height = (frame_height - hanger_height)/2 - 1;
hanger_connector_inset = sqrt(hanger_radius^2 - (hanger_connector_width/2)^2);
hanger_tolerance = 1.01;

textframe_width = frame_width / 2;
textframe_length = 20;
textframe_border = 2;
textframe_inset = 2;

textframe_x = (frame_width-textframe_width) / 2;
textframe_y = frame_length - textframe_length + outer_border_width/2 - 1.2;

body_color() {
    // lower border half
    side("lower") {
        difference() {
            union() {
                border_half(true);
                translate([0, 0, frame_height / 2])
                    connectors();
            }

            translate([frame_width / 2, -hanger_connector_inset, (frame_height - hanger_height)/2])
                scale([hanger_tolerance, hanger_tolerance, hanger_tolerance])
                    hanger();
        }
    }

    // upper border half
    side("upper") {
        translate([frame_width + 10, 0, 0]) {
            difference() {
                border_half(false);

                translate([0, 0, frame_height / 2 - connector_height - connector_tolerance])
                    connectors(connector_tolerance * 2, connector_tolerance + 1);

                translate([frame_width / 2, -hanger_connector_inset, frame_height - (frame_height - hanger_height)/2])
                    mirror([0, 0, 1])
                        scale([hanger_tolerance, hanger_tolerance, hanger_tolerance])
                            hanger();        
            }
        }
    }

}

highlight_color() {
    side("lower") {
        // hanger
        translate([frame_width / 2, frame_length/2, 0]) {
            hanger();
        }

        // lower border half
        border_half_text();
    }

    // upper border half
    //translate([frame_width + 10, 0, 0])
    //    border_half_text();
}

module hanger() {
    difference() {
        union() {
            // outer
            cylinder(d = hanger_outer_diameter, h = hanger_height);
            // frame connector
            translate([0, hanger_connector_inset + hanger_connector_length/2, hanger_height/2]) {
                cube([hanger_connector_width, hanger_connector_length, hanger_height], center = true);
                translate([0, 0, hanger_height/2])
                    cylinder(d=connector_diameter, h=hanger_connector_height - connector_tolerance);
            }
        }
        // inner hole
        translate([0,0,-1])
            cylinder(d = hanger_inner_diameter, h = hanger_height + 2);
    }
}

module border_half(with_textbox) {
    difference() {
        // outer border of frame
        union() {
            linear_extrude(frame_height/2)
                offset(frame_offset) offset(-frame_offset)
                    square([frame_width, frame_length]);
        
            if (with_textbox) {
                textbox();
            }
        }

        // inner border of frame
        difference() {
            inner_margin_width = (tolerance + inner_border_width) * 2;
            translate([outer_border_width + inner_border_width + tolerance, outer_border_width + inner_border_width + tolerance, -1])
                linear_extrude(frame_height + 2)
                    offset(frame_offset/2) offset(-frame_offset/2)
                        square([image_width - inner_margin_width, image_length - inner_margin_width]);
            if (with_textbox) {
                textbox();
            }
        }

        // image opening
        translate([outer_border_width, outer_border_width, outer_border_thickness + tolerance])
            cube([image_width + tolerance*2, image_length + tolerance*2, bead_height + tolerance*2]);
        
        // hole for text
        if (with_textbox) {
            border_half_text(1);
        }
    }
}

module border_half_text(additional_inset = 0) {
    translate([frame_width / 2, textframe_y + textframe_length/2, -additional_inset]) {
        linear_extrude(textframe_inset + additional_inset) {
            // text
            mirror([0,1])
                text("Nikolas 2012", halign="center", valign="center", size = 10, font="Comic Neue:style=Bold");

            // border
            difference() {
                offset(frame_offset) offset(-frame_offset)
                    square([textframe_width, textframe_length], center=true);
                offset(frame_offset) offset(-frame_offset)
                    square([textframe_width - 4, textframe_length - 4], center=true);
            }
        }
    }
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

    connector(tolerance_offset, height_offset, 0.5, 1);
}

module connector(tolerance_offset, height_offset, x, y) {
    translate([outer_border_width / 2 + x*(frame_width - outer_border_width), outer_border_width / 2 + y*(frame_length - outer_border_width), 0])
        cylinder(d=connector_diameter + tolerance_offset, h=connector_height + tolerance_offset + height_offset);
}
