//Facet Number
$fn = 12;

// Handle Parameters
// The diameter of the handle
handle_diameter = 4.6; // [0:0.1:15]
// The depth/length of the handle
handle_depth = 52.5; // [0:0.1:140]

// File parameters
// File width
file_blade_width = 3.55; // [0:0.1:8]
// File height
file_blade_height = 5.75; // [0:0.1:10]
// File depth
file_blade_depth = 87.55; // [0:0.1:140]

// File spacing
file_spacing = 4; // [0:0.1:10]

// File number
file_number = 10; // [1:1:20]

// Define parameters for the box
// Offset to ensure the file is fully subtracted from the box
box_offset = 4.0;
// Width of the box
box_base_width = (file_blade_width + box_offset) * file_number;
// Depth of the box
box_base_depth = file_blade_depth + handle_depth + box_offset;
// Height of the box
box_base_height = handle_diameter;

module handle() {
  rotate(a=[90, 0, 0])
    translate([0, 0, handle_depth / 2])
      cylinder(d=handle_diameter, h=handle_depth + 0.001, center=true);
}

module file_blade() {
  translate(v=[0, -file_blade_depth / 2, 0])
    translate(v=[0, -handle_depth, 0])
      cube(size=[file_blade_width, file_blade_depth, file_blade_height], center=true);
}

module file_body() {
  union() {
    file_blade();
    handle();
  }
}

module box() {

  // color("lightblue")
  // Create the parametric box
  union() {
    translate(v=[0, -box_base_depth / 2, (box_base_height / 2) - (box_offset / 2)])
      cube([box_base_width, box_base_depth, box_base_height], center=true);
    translate(v=[0, -box_base_depth / 2, ( (file_blade_height + box_offset / 4) / 2) - (box_offset / 2)])
      translate(v=[0, -(handle_depth / 2) - (box_offset / 4), 0])
        cube([box_base_width, -0.001 + file_blade_depth + box_offset / 2, file_blade_height + box_offset / 4], center=true);
  }
  difference() {
    // color("lightblue")
    translate(v=[0, -box_base_depth / 2, 0.5 + ( (file_blade_height + box_offset / 4) / 2) - (box_offset / 2)])
      cube(size=[box_base_width, box_base_depth, 1 + file_blade_height + box_offset / 4], center=true);
    // color("blue")
    translate(v=[0, -box_base_depth / 2, ( (file_blade_height + box_offset / 4) / 2) - (box_offset / 2)])
      cube(size=[box_base_width - box_offset, box_base_depth - box_offset, 2.001 + file_blade_height + box_offset / 4], center=true);
  }
}

difference() {
  box();
  // Space to push with fingers
  translate(v=[0, -7, 0.501 + (box_base_height / 2) - (box_offset / 2)])
    cube(size=[box_base_width - box_offset + 0.8, 10, box_base_height - 1], center=true);
  // Position and array the files
  for (i = [0:file_number - 1]) {
    translate(v=[(i - (file_number - 1) / 2) * (file_blade_width + file_spacing), -box_offset / 2, box_base_height / 2])
      file_body();
  }
}
