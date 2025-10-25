use <../module/multicolor.scad>
include <./bügelperlen_common.scad>

current_side = "ALL";
//current_side = "lower";
//current_side = "upper";

image_width = 141;
image_length = 141;
frame_width = image_width + outer_margin_width;
frame_length = image_length + outer_margin_width;

textframe_width = frame_width / 2;
textframe_x = (frame_width-textframe_width) / 2;
textframe_y = frame_length - textframe_length + outer_border_width/2 - 1.2;

body_color_name = "Cyan";
highlight_color_name = "DarkOrange";

inscription_text = "Nikolas 2012";

body_color() {
    // lower border half
    side("lower") {
        difference() {
            union() {
                border_half(true);
                translate([0, 0, frame_height / 2])
                    connectors_rect(frame_width, frame_length, outer_border_width);
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
                    connectors_rect(frame_width, frame_length, outer_border_width, connector_tolerance * 2, connector_tolerance + 1);
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

module connectors_rect(frame_width, frame_length, outer_border_width, tolerance_offset = 0, height_offset = 0) {
    for (x = [0:1:1]) {
        for (y = [0:0.5:1]) {
            connector_rect(frame_width, frame_length, outer_border_width, tolerance_offset, height_offset, x, y);
        }
    }
    connector_rect(frame_width, frame_length, outer_border_width, tolerance_offset, height_offset, 0.5, 1);
}

module connector_rect(frame_width, frame_length, outer_border_width, tolerance_offset, height_offset, x_index, y_index) {
    x = outer_border_width / 2 + x_index*(frame_width - outer_border_width);
    y = outer_border_width / 2 + y_index*(frame_length - outer_border_width);
    connector(x, y, tolerance_offset, height_offset);
}
