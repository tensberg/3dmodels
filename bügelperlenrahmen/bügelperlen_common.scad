// Common parameters and modules for bügelperlen frames

// --- Parameters ---
$fn = 50; // Default, can be overridden in main file

tolerance = 1;
bead_width = 5;
bead_inner_diameter = 2;
bead_height = 4;

outer_border_width = 8;
outer_border_thickness = 2;
inner_border_width = bead_width * 0.5;

outer_margin_width = (tolerance + outer_border_width) * 2;
margin_height = (tolerance + outer_border_thickness) * 2;
frame_height = bead_height + margin_height;

frame_offset = 4;

connector_tolerance = 0.1;
connector_diameter = 5;
connector_height_factor = 0.25; // Used to calculate connector height

connector_height = frame_height * connector_height_factor;
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

textframe_length = 20;
textframe_border = 2;
textframe_inset = 2;

// --- Common modules ---

module body_color() {
    multicolor(body_color_name) children();
}

module highlight_color() {
    multicolor(highlight_color_name) children();
}

module side(side) {
    if (current_side != "ALL" && current_side != side) {
        // ignore children
    } else {
        children();
    }
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

module connector(x, y, tolerance_offset, height_offset) {
    translate([x, y, 0])
        cylinder(d=connector_diameter + tolerance_offset, h=connector_height + tolerance_offset + height_offset);
}

module textbox() {
    linear_extrude(frame_height/2)
        translate([textframe_x, textframe_y])
            offset(frame_offset) offset(-frame_offset)
                square([textframe_width, textframe_length]);
}

module border_half_text(additional_inset = 0) {
    translate([frame_width / 2, textframe_y + textframe_length/2, -additional_inset]) {
        linear_extrude(textframe_inset + additional_inset) {
            // text
            mirror([0,1])
                text(inscription_text, halign="center", valign="center", size = 10, font="Comic Neue:style=Bold");

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
