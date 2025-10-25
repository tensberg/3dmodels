use <../module/multicolor.scad>
include <./bügelperlen_common.scad>

$fn = 60;

image_diameter = 140;
image_radius = image_diameter/2;

frame_diameter = image_diameter + outer_margin_width;
frame_radius = frame_diameter/2;
frame_width = frame_diameter;

textframe_width = frame_diameter / 2;
textframe_x = (frame_diameter-textframe_width) / 2;
textframe_y = frame_diameter - textframe_length + outer_border_width/2 - 2;

body_color_name = "Black";
highlight_color_name = "White";

inscription_text = undef; // can be overwritten in including file
has_inscription = inscription_text != undef;

body_color() {
    // lower border half
    side("lower") {
        difference() {
            union() {
                border_half(has_inscription);
                translate([0, 0, frame_height / 2])
                    connectors_round(frame_radius, outer_border_width);
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
                    connectors_round(frame_radius, outer_border_width, connector_tolerance * 2, connector_tolerance);
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
        if (has_inscription) {
            border_half_text();
        }
    }
    // upper border half
    //translate([frame_diameter + 10, 0, 0])
    //    border_half_text();
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

module connectors_round(frame_radius, outer_border_width, tolerance_offset = 0, height_offset = 0) {
    for (i = [0:1:3]) {
        a = i * 90 + 45;
        connector_round(frame_radius, outer_border_width, tolerance_offset, height_offset, a);
    }
}

module connector_round(frame_radius, outer_border_width, tolerance_offset, height_offset, angle) {
    x = frame_radius + (frame_radius-outer_border_width/2) * sin(angle);
    y = frame_radius + (frame_radius-outer_border_width/2) * cos(angle);
    connector(x, y, tolerance_offset, height_offset);
}
