use <../module/multicolor.scad>
include <../module/qr.scad>

$fn=50;

connector_diameter = 5;
connector_height = 0.5;

white() {
    difference() {
        translate([-3829,-150,-9.6])
            scale(10)
                import("cd_case_upper.stl");

        translate([0,-25,0.3]) {
            linear_extrude(2) scale(0.61) {
                import("ampersand_green.svg");
            }
            linear_extrude(2) scale(0.6) {
                import("ampersand_pink.svg");
            }
        }

        translate([-1, -1, 0]) mirror([0,0,1])
            cube([140, 140, 3]);
        
        connectors(0.1);

    }

    translate([-150,0,0]) mirror([0,0,1]) {
        difference() {
            translate([-3829,-150,-9.6])
                scale(10)
                    import("cd_case_upper.stl");
           

            translate([64,64,-1]) rotate([0,180,0]) scale([1.1,1.1,0.6])
                qr("https://cloud.webko.ch/s/CEy6aoBcDZA4Qoi?dir=/Musik/Bastille/Ampersand%20%5BExplicit%5D",center=true);

            translate([-1, -1, 0])
                cube([140, 140, 3]);

            connectors(0.1);
        }
        
    }
    
    translate([-150, 150, 0])
        connectors(0, 2);

}

translate([0,200,0]) {
    cyan() {
    linear_extrude(2) scale(0.6)
        import("ampersand_green.svg");
    }
}

translate([0,100,0]) {
    orange() {
    linear_extrude(2) scale(0.6)
        import("ampersand_pink.svg");
    }
}

black() {
    translate([200,64,0]) rotate([0,180,0]) scale([1.1,1.1,0.6])
        qr("https://cloud.webko.ch/s/CEy6aoBcDZA4Qoi?dir=/Musik/Bastille/Ampersand%20%5BExplicit%5D",center=true);
}


module connectors(height_offset = 0, height_scale=1) {
    for (x = [0:1:1]) {
        for (y = [0:1:1]) {
            connector(height_offset, height_scale, x, y);
        }
    }
}

module connector(height_offset, height_scale, x, y) {
    translate([15 + x*100, 15 + y*100, -height_offset])
        cylinder(d=connector_diameter, h=connector_height*height_scale + height_offset);
}
