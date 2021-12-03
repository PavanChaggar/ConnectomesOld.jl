using LightXML

# create an empty XML document
xdoc = XMLDocument()

# create & attach a root node
xroot = create_root(xdoc, "States")

# create the first child
xs1 = new_child(xroot, "State")

# add the inner content
add_text(xs1, "Massachusetts")

# set attribute
set_attribute(xs1, "tag", "MA")

# likewise for the second child
xs2 = new_child(xroot, "State")
add_text(xs2, "Illinois")
# set multiple attributes using a dict
set_attributes(xs2, Dict("tag"=>"IL", "cap"=>"Springfield"))

testdoc = XMLDocument()
g = create_root(testdoc, "graphml")
c1 = new_child(g, "key")
set_attribute(c1, "attr.name", "FA_std")
set_attribute(c1, "attr.type", "double")
set_attribute(c1, "for", "edge")
set_attribute(c1, "id", "d13")


function add_keys!(root)
    for i in 1:13
        c = new_child(root, "key")
        set_attribute(c, "attr.name", name_dict[i])
        set_attribute(c, "attr.type", type_dict[i])
        set_attribute(c, "for", for_dict[i])
        set_attribute(c, "id", "d$i")
    end
end


for_dict = Dict(1 => "node", 
                2 => "node",
                3 => "node", 
                4 => "node", 
                5 => "node",
                6 => "node",
                7 => "node",
                8 => "node",
                9 => "edge",
                10 => "edge", 
                11 => "edge",
                12 => "edge",
                13 => "edge"
)

type_dict = Dict(1 => "double", 
                 2 => "double",
                 3 => "double", 
                 4 => "string", 
                 5 => "string",
                 6 => "string",
                 7 => "string",
                 8 => "string",
                 9 => "int",
                 10 => "double", 
                 11 => "double",
                 12 => "double",
                 13 => "double"
)

name_dict = Dict(1 => "dn_position_x", 
                 2 => "dn_position_y",
                 3 => "dn_position_z", 
                 4 => "dn_correspondence_id", 
                 5 => "dn_region",
                 6 => "fn_fsname",
                 7 => "dn_name",
                 8 => "dn_hemisphere",
                 9 => "number_of_fibers",
                 10 => "FA_mean", 
                 11 => "fiber_length_std",
                 12 => "fiber_length_mean",
                 13 => "FA_std"
)



function make_xml()
    xdoc = XMLDocument()
    root = create_root(xdoc, "graphml")
    add_keys!(root)

    xdoc
end

