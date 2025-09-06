// Nipper params
// The brand text of the nipper
nipper_brand = "GodHand";
// The model text of the nipper
nipper_model = "SNP-120";
// The size of the text
text_size = 10.0; // [0:0.1:30]
// The depth of the text carving on the nipper
text_carve_depth = 0.8; // [0:0.1:2]
// The offset of the text from the edge of the nipper cap
text_offset = 2.0; // [0:0.1:10]

// Define parameters for the nipper
nipper_width = 60.0; // [0:0.1:128]
nipper_depth = 141.0; // [0:0.1:230]
nipper_height = 11.0; // [0:0.1:50]

nipper_offset = 4.0; // Offset to ensure the nipper is fully subtracted from the box

// Nipper cap parameters
nipper_cap_width = 34.6; // [0:0.1:128]
nipper_cap_depth = 61.0; // [0:0.1:230]
nipper_cap_rect = nipper_cap_depth - (nipper_cap_width / 2); // the nipper cap rectangle depth which is the nipper cap depth minus the radius of the semicircle
nipper_cap_round_offset = nipper_cap_rect / 2;

// Nipper body parameters
nipper_body_width = nipper_width;
nipper_body_depth = nipper_depth - nipper_cap_depth;
nipper_body_offset = nipper_cap_rect + (nipper_body_depth / 2);
// depth of the bottom square part of the nipper body
nipper_body_bottom_square_depth = 40.0; // [0:0.1:230] 

nipper_box_offset = (nipper_cap_width / 2) + nipper_offset / 2; // Offset to ensure the nipper is centred in the box

// Define parameters for the box
box_width = nipper_width + nipper_offset; // Width of the box
box_depth = nipper_depth + nipper_offset; // Depth of the box
box_height = nipper_height + nipper_offset / 2; // Height of the box

module brand() {
  // The brand text of the nipper
  translate(v=[-box_width / 2 + (text_size + 2), -nipper_cap_depth - text_offset, box_height - text_carve_depth + 0.001]) {
    rotate(a=[0, 0, 90]) {
      linear_extrude(height=text_carve_depth) {
        text(nipper_brand, font="Liberation Sans:style=Bold Italic", size=text_size);
      }
    }
  }
}

module model() {
  // The model text of the nipper
  translate(v=[box_width / 2 - 2, -nipper_cap_depth - text_offset, box_height - text_carve_depth + 0.001]) {
    rotate(a=[0, 0, 90]) {
      linear_extrude(height=text_carve_depth) {
        text(nipper_model, font="Liberation Sans:style=Bold Italic", size=text_size);
      }
    }
  }
}

module nipper() {
  // nipper cap
  color("orange")
    circle(d=nipper_cap_width);
  translate(v=[0, -nipper_cap_round_offset, 0])
    square([nipper_cap_width, nipper_cap_rect], center=true);
  // nipper body
  translate(v=[0, -nipper_body_offset, 0]) {
    // color("red")
    //  square([nipper_body_width, nipper_body_depth], center=true);
    color("darkred")
      polygon(
        points=[
          [nipper_body_width / 2, -nipper_body_depth / 2],
          [nipper_body_width / 2, ( -nipper_body_depth / 2) + nipper_body_bottom_square_depth],
          // for (i = [nipper_cap_width / 2: 0.2 : nipper_body_width / 2 ]) [ i, nipper_body_width / 2 - i],
          [nipper_cap_width / 2, nipper_body_depth / 2],
          [-nipper_cap_width / 2, nipper_body_depth / 2],
          [-nipper_body_width / 2, ( -nipper_body_depth / 2) + nipper_body_bottom_square_depth],
          [-nipper_body_width / 2, -nipper_body_depth / 2],
        ]
      );
  }
}

module box() {

  color("lightblue")
    // Create the parametric box
    translate(v=[0, -box_depth / 2, box_height / 2])
      cube([box_width, box_depth, box_height], center=true);
}

difference() {
  box();
  translate([0, -nipper_box_offset, nipper_offset / 2])
    linear_extrude(height=nipper_height + 0.01)
      nipper();
  // Carve the brand text
  brand();
  model();
}
