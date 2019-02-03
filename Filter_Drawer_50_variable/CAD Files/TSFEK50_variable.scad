//------------------------------------------------------------------
// see https://customizer.makerbot.com/docs
label = "H-alpha"; // this label will be printed on top of the filter drawer, can be used e.g. for the filter name,
// be careful to fill only the available space of the lock
//surface finish: black matte

filter_dia = 36.0;
filter_thick = 2.0;
filter_overlap = 1.0; // filter edge area without optical coating, used for retaining the filter
print = "lock"; // part to render: "all", "drawer", "lock"
//------------------------------------------------------------------
direction = "FRONT";
filter_tolerance = 0.2; // clearance to the drawer slot
filter_chamfer = 0.3; // not relevant

//------------------------------------------------------------------
filter_d_active = filter_dia - 2 * filter_overlap;

drawer_width = 56.0 - 0.5; // width of the internal part of the drawer, includes tolerance!
drawer_length = 56.0 - 0.5; // length of the internal part of the drawer (without cap!)
fixation_screw_pos = drawer_length - 56.0; // relative to the optical center in x-direction
drawer_thick = 6.0 - 0.1; // includes tolerance!
holder_height = drawer_length - drawer_width / 2; // for internal use

THREAD_M3 = 3.0;
WAF_HEX_M3 = 5.5;
NUT_HEIGHT_M3 = 2.4;
THREAD_M4 = 4.0;
WAF_HEX_M4 = 7.0;
NUT_HEIGHT_M4 = 3.2 + 0.3; // includes tolerance!
KNURLED_HEAD_DIA = 10.5;
KNURLED_HEAD_HGT = 8.1;

// global settings:
$fn = 240;
min_wt = 1.0; // minimum wall thickness

module filter()
{
	chmf_dia = filter_dia;
	chmf_height = chmf_dia / 2;
 
	intersection()
		{
			intersection()
				{
					cylinder(d=filter_dia, h=filter_thick, center=true);
					union()
						{
							translate([0,0, chmf_height/2 + filter_thick/2 - filter_chamfer]) cylinder(d1=chmf_dia, d2=0, h=chmf_height, center=true);
							translate([0,0,-(filter_thick+10)/2+filter_thick/2 - filter_chamfer]) cylinder(d=filter_dia+1, h=filter_thick+10, center=true);
						}
				}
			union()
				{
					translate([0,0, -(chmf_height/2 + filter_thick/2 - filter_chamfer)]) cylinder(d1=0, d2=chmf_dia, h=chmf_height, center=true);
					translate([0,0,-(-(filter_thick+10)/2+filter_thick/2 - filter_chamfer)]) cylinder(d=filter_dia+1, h=filter_thick+10, center=true);
				}
		}
}

module Screw_Knurled_M4(length)
{
	thread = THREAD_M4;
	waf = WAF_HEX_M4;
	head_dia = KNURLED_HEAD_DIA;
	head_height = KNURLED_HEAD_HGT;
	union()
		{
			translate([0,0,-length/2]) cylinder(d=thread, h=length, center=true);
			translate([0,0,head_height/2]) cylinder(d=head_dia, h=head_height, center=true);
		}
}

module drawer()
{
	filter_slot_length = drawer_length;
	holder_chamfer = 0.5;
	aperture_chamfer = 0.3;
	
	difference()
		{
			difference()
				{
					union()
						{
							difference() // filter holder
								{
									union()
										{
											translate([holder_height/2,0,0]) cube([holder_height,drawer_width,drawer_thick], center=true);
											intersection()
												{
													chamfer_hld = drawer_width + 2*drawer_thick - 2*(holder_chamfer)/sqrt(2) + 2*0.1+1.1;
													translate([0,0,0]) cylinder(d=drawer_width, h=drawer_thick, center=true);
													translate([0,0,+((chamfer_hld/2)/2-drawer_thick/2-1.1/2)]) cylinder(d1=chamfer_hld, d2=0, h=chamfer_hld/2, center=true); // round chamfer
													translate([0,0,-((chamfer_hld/2)/2-drawer_thick/2-1.1/2)]) cylinder(d2=chamfer_hld, d1=0, h=chamfer_hld/2, center=true); // round chamfer
												}
										}
									union()
										{
											cylinder(d=filter_d_active, h=drawer_thick+1, center=true); // filter aperture
											chamfer_ap = filter_d_active + 2*(aperture_chamfer)/sqrt(2)+1.1;
											translate([0,0,+((chamfer_ap/2-drawer_thick)/2-1.1/2)]) cylinder(d1=chamfer_ap, d2=0, h=chamfer_ap/2, center=true); // aperture chamfer
											translate([0,0,-((chamfer_ap/2-drawer_thick)/2-1.1/2)]) cylinder(d2=chamfer_ap, d1=0, h=chamfer_ap/2, center=true); // aperture chamfer
										}
									union()
										{
											translate([holder_height/2,+(drawer_width+0.1)/2,+(drawer_thick+0.1)/2]) rotate([45,0,0]) cube([holder_height+0.1, holder_chamfer, holder_chamfer], center=true); // straight chamfer
											translate([holder_height/2,+(drawer_width+0.1)/2,-(drawer_thick+0.1)/2]) rotate([45,0,0]) cube([holder_height+0.1, holder_chamfer, holder_chamfer], center=true); // straight chamfer
											translate([holder_height/2,-(drawer_width+0.1)/2,+(drawer_thick+0.1)/2]) rotate([45,0,0]) cube([holder_height+0.1, holder_chamfer, holder_chamfer], center=true); // straight chamfer
											translate([holder_height/2,-(drawer_width+0.1)/2,-(drawer_thick+0.1)/2]) rotate([45,0,0]) cube([holder_height+0.1, holder_chamfer, holder_chamfer], center=true); // straight chamfer
										}
								}
							union() // cap
								{
									translate([holder_height+(NUT_HEIGHT_M4+2*2.0)/2,0,0]) cube([NUT_HEIGHT_M4+2*2.0, drawer_width+THREAD_M4+0.5, KNURLED_HEAD_DIA], center=true);
									translate([holder_height+(NUT_HEIGHT_M4+2*2.0)/2,(drawer_width+THREAD_M4+0.5)/2,0]) rotate([0,90,0]) cylinder(d=KNURLED_HEAD_DIA, h=NUT_HEIGHT_M4+2*2.0, center=true);
									rotate([180,0,0])
									translate([holder_height+(NUT_HEIGHT_M4+2*2.0)/2,(drawer_width+THREAD_M4+0.5)/2,0]) rotate([0,90,0]) cylinder(d=KNURLED_HEAD_DIA, h=NUT_HEIGHT_M4+2*2.0, center=true);
								}
						}
					union() // filter slot
						{
							translate([filter_slot_length/2, 0, 0]) cube([filter_slot_length, filter_dia+2*filter_tolerance, filter_thick+2*filter_tolerance], center=true);
							translate([0,0,0]) cylinder(d=filter_dia+2*filter_tolerance, h=filter_thick+2*filter_tolerance, center=true);
						}
				}
			union() // screw nuts
				{
					sn_slot_l = THREAD_M4+KNURLED_HEAD_DIA+5;
					hole_length = NUT_HEIGHT_M4+2*2.0;
					
					translate([holder_height+(NUT_HEIGHT_M4+2*2.0)/2,(drawer_width+THREAD_M4+0.5)/2,0])
					union()
						{
							rotate([90,0,90]) cylinder(d=(WAF_HEX_M4*2)/sqrt(3), h=NUT_HEIGHT_M4, center=true, $fn=6); // screw nut
							translate([0,sn_slot_l/2,0]) cube([NUT_HEIGHT_M4,sn_slot_l,WAF_HEX_M4], center=true); // slot
							rotate([0,90,0]) cylinder(d=THREAD_M4+0.4, h=hole_length+0.1, center=true); // screw hole
						}
					rotate([180,0,0])
					translate([holder_height+(NUT_HEIGHT_M4+2*2.0)/2,(drawer_width+THREAD_M4+0.5)/2,0])
					union()
						{
							rotate([90,0,90]) cylinder(d=(WAF_HEX_M4*2)/sqrt(3), h=NUT_HEIGHT_M4, center=true, $fn=6); // screw nut
							translate([0,sn_slot_l/2,0]) cube([NUT_HEIGHT_M4,sn_slot_l,WAF_HEX_M4], center=true); // slot
							rotate([0,90,0]) cylinder(d=THREAD_M4+0.4, h=hole_length+0.1, center=true); // screw hole
						}
				}
			translate([fixation_screw_pos,0,0])
			union() // fixation screw hutch
				{
					hutch_dia = 5.0;
					translate([0,drawer_width/2+hutch_dia/2-0.8,0]) sphere(d=hutch_dia, center=true);
					rotate([180,0,0])
					translate([0,drawer_width/2+hutch_dia/2-0.8,0]) sphere(d=hutch_dia, center=true);
				}
			translate([holder_height+(NUT_HEIGHT_M4+2*2.0)/2,0,KNURLED_HEAD_DIA/2]) rotate([0,0,90]) scale([0.4,0.4,1]) linear_extrude(height=2.0, center=true) text(str("\u00D8",filter_dia, "mm x ", filter_thick, "mm"), halign="center", valign="center"); // size label
			translate([holder_height+(NUT_HEIGHT_M4+2*2.0)/2,0,-KNURLED_HEAD_DIA/2]) rotate([0,180,90]) scale([0.4,0.4,1]) linear_extrude(height=2.0, center=true) text(direction, halign="center", valign="center"); // direction label
		}
} // drawer

module lock()
{
	cap_height = 2.5;
	ring_height = 0.8; // distance ring for the screws
	handle_thick = 5.0;
	handle_height = 20.0;
	handle_width = 40.0;
	handle_fillet_dia = 20.0;
	hole_length = cap_height + ring_height;
	
	difference()
		{
			union()
				{
					union() // cap
						{
							translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+cap_height/2,0,0]) cube([cap_height, drawer_width+THREAD_M4+0.5, KNURLED_HEAD_DIA], center=true);
							
							translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+cap_height/2,(drawer_width+THREAD_M4+0.5)/2,0]) rotate([0,90,0]) cylinder(d=KNURLED_HEAD_DIA, h=cap_height, center=true);
							rotate([180,0,0])
							translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+cap_height/2,(drawer_width+THREAD_M4+0.5)/2,0]) rotate([0,90,0]) cylinder(d=KNURLED_HEAD_DIA, h=cap_height, center=true);
						}
					translate([(holder_height+(NUT_HEIGHT_M4+2*2.0))/2, 0, 0]) cube([holder_height+(NUT_HEIGHT_M4+2*2.0), filter_dia+2*filter_tolerance, filter_thick], center=true); // filter barrier
					
					translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+cap_height+0.0,0,0]) rotate([90,0,90]) scale([0.5,0.5,1]) linear_extrude(height=2.0, center=true, $fn=36) text(label, halign="center", valign="center"); // label
					
					translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+cap_height+ring_height/2,(drawer_width+THREAD_M4+0.5)/2,0])
					rotate([0,90,0]) cylinder(d=THREAD_M4+2*1.5, h=ring_height, center=true); // screw offset ring
					rotate([180,0,0])
					translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+cap_height+ring_height/2,(drawer_width+THREAD_M4+0.5)/2,0])
					rotate([0,90,0]) cylinder(d=THREAD_M4+2*1.5, h=ring_height, center=true); // screw offset ring
					union() // handle
						{
							translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+cap_height,0,0])
							union()
								{
									
									translate([(handle_height-handle_fillet_dia/2)/2,(handle_width-handle_thick)/2,0]) rotate([0,90,0]) cylinder(d=handle_thick, h=handle_height-handle_fillet_dia/2, center=true);
									translate([(-handle_thick)/2+handle_height,(handle_width/2-handle_fillet_dia/2)/2,0]) rotate([90,0,0]) cylinder(d=handle_thick, h=handle_width/2-handle_fillet_dia/2, center=true);
									translate([handle_height-handle_fillet_dia/2,handle_width/2-handle_fillet_dia/2,0])
									intersection()
										{
											rotate_extrude(convexity=10) translate([(handle_fillet_dia-handle_thick)/2,0,0]) circle(r=handle_thick/2);
											translate([(handle_fillet_dia+1)/2,(handle_fillet_dia+1)/2,0]) cube([handle_fillet_dia+1,handle_fillet_dia+1,handle_thick+1],center=true);
										}
								}
							rotate([180,0,0])
							translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+cap_height,0,0])
							union() // mirrored
								{
									translate([(handle_height-handle_fillet_dia/2)/2,(handle_width-handle_thick)/2,0]) rotate([0,90,0]) cylinder(d=handle_thick, h=handle_height-handle_fillet_dia/2, center=true);
									translate([(-handle_thick)/2+handle_height,(handle_width/2-handle_fillet_dia/2)/2,0]) rotate([90,0,0]) cylinder(d=handle_thick, h=handle_width/2-handle_fillet_dia/2, center=true);
									translate([handle_height-handle_fillet_dia/2,handle_width/2-handle_fillet_dia/2,0])
									intersection()
										{
											rotate_extrude(convexity=10) translate([(handle_fillet_dia-handle_thick)/2,0,0]) circle(r=handle_thick/2);
											translate([(handle_fillet_dia+1)/2,(handle_fillet_dia+1)/2,0]) cube([handle_fillet_dia+1,handle_fillet_dia+1,handle_thick+1],center=true);
										}
								}
						}
				}
			union() // filter cutout
				{
					translate([12/2, 0, 0]) cube([12, drawer_width+2*2.0, filter_thick+0.1], center=true);
					translate([0,0,0]) cylinder(d=filter_dia+2*filter_tolerance, h=filter_thick+0.1, center=true);
				}
			union()
				{
					translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+(cap_height+ring_height)/2,(drawer_width+THREAD_M4+0.5)/2,0])
					rotate([0,90,0]) cylinder(d=THREAD_M4+0.4, h=hole_length+0.1, center=true); // screw hole
					rotate([180,0,0])
					translate([holder_height+(NUT_HEIGHT_M4+2*2.0)+(cap_height+ring_height)/2,(drawer_width+THREAD_M4+0.5)/2,0])
					rotate([0,90,0]) cylinder(d=THREAD_M4+0.4, h=hole_length+0.1, center=true); // screw hole
				}
			translate([holder_height+(NUT_HEIGHT_M4+2*2.0)-0.2*10-1,0,filter_thick/2]) rotate([0,0,90]) scale([0.25,0.4,1]) linear_extrude(height=2.0, center=true, $fn=36) text(str("\u00D8",filter_dia, "mm x ", filter_thick, "mm"), halign="center", valign="center"); // size label
		}
} // lock

module TS_FS50_Drawer()
{
	cap_height = 2.5;
	ring_height = 0.8; // distance ring for the screws
	handle_thick = 5.0;
	handle_height = 20.0;
	handle_width = 40.0;
	handle_fillet_dia = 20.0;
	hole_length = cap_height + ring_height;
	
	if (filter_thick >= drawer_thick - 2 * min_wt)
		{
			echo("filter too thick!");
			text(str("filter too thick!"), halign="center", valign="center");
		}
	else
		{
			if (filter_dia >= drawer_width - 2 * min_wt)
				{
					echo("filter too large!");
					text(str("filter too large!"), halign="center", valign="center");
				}
			else
				{
					if (print == "all")
						{
							translate([10.8+holder_height,27.25,0]) rotate([0,90,0]) Screw_Knurled_M4(10);
							translate([10.8+holder_height,-27.25,0]) rotate([0,90,0]) Screw_Knurled_M4(10);
						}
					if (print == "all" || print == "drawer") drawer();
					if (print == "all" || print == "lock") lock();
				}
		}
}

//------------------------------------------------------------------
*#filter();
TS_FS50_Drawer();
