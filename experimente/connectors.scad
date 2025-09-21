// Qualitätstest verschiedener Verbinder-Größen
// druckt verschiedene Durchmesser mit unterschiedlichen Toleranzen

$fn = 30;

block_width = 12;
block_height = 3;

connector_height = 2;
block_height_female = block_height + connector_height;
connector_tolerance_min = 0.0;
connector_tolerance_max = 0.1;
tolerance_steps = 3;
tolerance_increment = (connector_tolerance_max - connector_tolerance_min) / (tolerance_steps-1);
connector_diameter_min = 3;
connector_diameter_max = 5;
diameter_steps = 3;
diameter_increment = (connector_diameter_max - connector_diameter_min) / (diameter_steps-1);

text_height = 0.8;
text_size = 4;

for (d = [0:1:diameter_steps-1]) {
    for (t = [0:1:tolerance_steps-1]) {
        translate([(block_width + 10)*d*2, (block_width + 5)*t, 0])
            connector(connector_diameter_min + d*diameter_increment, connector_height, connector_tolerance_min + t*tolerance_increment);
    }
}

module connector(diameter, height, tolerance) {
    // male
    connector_base(diameter, tolerance, block_height);
    translate([block_width/2, block_width/2, block_height])
        cylinder(d=diameter, h=height - tolerance);

    // female
    translate([block_width + 10, 0, 0]) {
        difference() {
            connector_base(diameter, tolerance, block_height_female);
            translate([block_width/2, block_width/2, block_height_female - height])
                cylinder(d=diameter + tolerance, h=height + 1);
        }
    }
}

module connector_base(diameter, tolerance, height) {
    difference() {
        cube([block_width, block_width, height]);

        translate([0, 0, -1]) {
            linear_extrude(text_height + 1) {
                translate([1.5, block_width - 1.5]) {
                    resize([block_width - 3, block_width - 3]) {
                        mirror([0,1]) {
                            text(str(diameter), font="Quicksand Light:style=Bold", halign="left", valign="bottom", size=text_size);
                            translate([0, block_width/2])
                                text(str(tolerance), font="Quicksand Light:style=Bold", halign="left", valign="bottom", size=text_size);
                        }
                    }
                }
            }
        }
    }
}
