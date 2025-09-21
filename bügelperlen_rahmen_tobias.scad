use <multicolor.scad>

module body_color() {
    multicolor("DarkOrange") children();
}

module highlight_color() {
    multicolor("Cyan") children();
}

$fn = 60;

//current_side = "ALL";
//current_side = "lower";
current_side = "upper";

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

image_diameter = 140;
image_radius = image_diameter/2;

outer_border_width = 8;
outer_border_thickness = 2;
inner_border_width = bead_width * 0.5;

outer_margin_width = (tolerance + outer_border_width) * 2;
margin_height = (tolerance + outer_border_thickness) * 2;
frame_diameter = image_diameter + outer_margin_width;
frame_radius = frame_diameter/2;
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

textframe_width = frame_diameter / 2;
textframe_length = 20;
textframe_border = 2;
textframe_inset = 2;

textframe_x = (frame_diameter-textframe_width) / 2;
textframe_y = frame_diameter - textframe_length + outer_border_width/2 - 2;

body_color() {
    // lower border half
    side("lower") {
        difference() {
            union() {
                border_half(true);
                translate([0, 0, frame_height / 2])
                    connectors();
            }

            translate([frame_diameter / 2, -hanger_connector_inset, (frame_height - hanger_height)/2])
                scale([hanger_tolerance, hanger_tolerance, hanger_tolerance])
                    hanger();
        }
    }

    // upper border half
    side("upper") {
        translate([frame_diameter + 10, 0, 0]) {
            difference() {
                border_half(false);

                translate([0, 0, frame_height / 2 - connector_height - connector_tolerance / 2])
                    connectors(connector_tolerance * 2, connector_tolerance);

                translate([frame_diameter / 2, -hanger_connector_inset, frame_height - (frame_height - hanger_height)/2])
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
        translate([frame_diameter / 2, frame_diameter/2, 0]) {
            hanger();
        }

        // lower border half
        border_half_text();
    }

    // upper border half
    //translate([frame_diameter + 10, 0, 0])
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
            translate([frame_radius, frame_radius, 0])
                cylinder(d=frame_diameter, h=frame_height/2);
        
            if (with_textbox) {
                textbox();
            }
        }

        // inner border of frame
        difference() {
            inner_margin_width = (tolerance + inner_border_width) * 2;
            translate([frame_radius, frame_radius, -1])
                cylinder(d=image_diameter - inner_margin_width, h=frame_height + 2);
            if (with_textbox) {
                textbox();
            }
        }

        // image opening
        translate([frame_radius, frame_radius, outer_border_thickness + tolerance])
            cylinder(d=image_diameter + tolerance*2, h = bead_height + tolerance*2);
        
        // hole for text
        if (with_textbox) {
            border_half_text(1);
        }
    }
}

module border_half_text(additional_inset = 0) {
    translate([frame_diameter / 2, textframe_y + textframe_length/2, -additional_inset]) {
        linear_extrude(textframe_inset + additional_inset) {
            // text
            mirror([0,1])
                text("Tobias 2012", halign="center", valign="center", size = 10, font="Comic Neue:style=Bold");

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
    for (i = [0:1:3]) {
        a = i * 90 + 45;
        connector(tolerance_offset, height_offset, frame_radius + (frame_radius-outer_border_width/2) * sin(a), frame_radius + (frame_radius-outer_border_width/2) * cos(a));
    }
}

module connector(tolerance_offset, height_offset, x, y) {
    echo(x, y);
    translate([x, y, 0])
        cylinder(d=connector_diameter + tolerance_offset, h=connector_height + tolerance_offset + height_offset);
}
