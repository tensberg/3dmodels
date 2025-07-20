// Qualitätstest verschiedener Verbinder-Größen
// druckt verschiedene Durchmesser mit unterschiedlichen Toleranzen

$fn = 30;

block_width = 20;
block_height = 8;

connector_height = 5;
connector_tolerance_min = 0.2;
connector_tolerance_max = 1.0;
tolerance_steps = 5;
tolerance_increment = (connector_tolerance_max - connector_tolerance_min) / (tolerance_steps-1);
connector_diameter_min = 4;
connector_diameter_max = 16;
diameter_steps = 4;
diameter_increment = (connector_diameter_max - connector_diameter_min) / (diameter_steps-1);

text_height = 1;

for (d = [0:1:diameter_steps-1]) {
    for (t = [0:1:tolerance_steps-1]) {
        translate([(block_width + 10)*d*2, (block_width + 5)*t, 0])
            connector(connector_diameter_min + d*diameter_increment, connector_height, connector_tolerance_min + t*tolerance_increment);
    }
}

module connector(diameter, height, tolerance) {
    // male
    connector_base(diameter, tolerance);
    translate([block_width/2, block_width/2, block_height])
        cylinder(d=diameter, h=height);

    // female
    translate([block_width + 10, 0, 0]) {
        difference() {
            connector_base(diameter, tolerance);
            translate([block_width/2, block_width/2, block_height - height - tolerance])
                cylinder(d=diameter, h=height + tolerance + 1);
        }
    }
}

module connector_base(diameter, tolerance) {
    cube([block_width, block_width, block_height]);

    translate([0, 0, -text_height]) {
        linear_extrude(text_height) {
            translate([2, block_width - 2]) {
                resize([block_width - 4, block_width - 4]) {
                    mirror([0,1]) {
                        text(str(diameter), font="Quicksand Light:style=Bold", halign="left", valign="bottom");
                        translate([0, block_width/2 + 1])
                            text(str(tolerance), font="Quicksand Light:style=Bold", halign="left", valign="bottom");
                    }
                }
            }
        }
    }
}
