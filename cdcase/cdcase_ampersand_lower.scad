use <../3dmodels/multicolor.scad>
include <qr.scad>

white() {
    translate([-3830,0,0])
        scale(10)
            import("cd_case_lower_slim.stl");
}
