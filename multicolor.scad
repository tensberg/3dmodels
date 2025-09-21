// source: https://erik.nygren.org/2018-3dprint-multicolor-openscad.html

/* Pick a color below for STL export, or "ALL" to show all colors. */
//current_color = "ALL";
current_color = "White";
//current_color = "Cyan";
//current_color = "DarkOrange";
//current_color = "Black";

transparent_aquamarine()
    cube([1, 1, 1]);

orange()
    translate([2, 0, 0])
        sphere(r = 1, $fn=20);

/* Similar to the color function, but can be used for generating multi-color models for printing.
 * The global current_color variable indicates the color to print.
 */
module multicolor(color) {
    if (current_color != "ALL" && current_color != color) { 
        // ignore our children.
    } else {
        color(color)
            children();
    }        
}


module transparent_aquamarine() {
    multicolor("Aquamarine") children();
}

module transparent_light_cyan() {
    multicolor("LightCyan") children();
}

module cyan() {
    multicolor("Cyan") children();
}

module orange() {
    multicolor("DarkOrange") children();
}

module white() {
    multicolor("White") children();
}

module black() {
    multicolor("Black") children();
}