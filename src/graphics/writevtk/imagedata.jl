#!/usr/bin/env julia

# Create image data VTK file.
# This corresponds to a rectilinear grid with uniform spacing in each direction.

using WriteVTK
import Compat.UTF8String
const FloatType = Float32
const vtk_filename_noext = "imagedata"

function main()
    # Define grid.
    const Ni, Nj, Nk = 20, 30, 40

    # Create some scalar and vectorial data.
    p = zeros(FloatType, Ni, Nj, Nk)
    q = zeros(FloatType, Ni, Nj, Nk)
    vec = zeros(FloatType, 3, Ni, Nj, Nk)

    for k = 1:Nk, j = 1:Nj, i = 1:Ni
        p[i, j, k] = i*i + k
        q[i, j, k] = k*sqrt(j)
        vec[1, i, j, k] = i
        vec[2, i, j, k] = j
        vec[3, i, j, k] = k
    end

    # Create some scalar data at grid cells.
    # Note that in structured grids, the cells are the hexahedra formed between
    # grid points.
    cdata = zeros(FloatType, Ni-1, Nj-1, Nk-1)
    for k = 1:Nk-1, j = 1:Nj-1, i = 1:Ni-1
        cdata[i, j, k] = 2i + 3k * sin(3*pi * (j-1) / (Nj-2))
    end

    # These are all optional:
    extent = [1, Ni, 1, Nj, 1, Nk] + 42
    origin = [1.2, 4.3, -3.1]
    spacing = [0.1, 0.5, 1.2]

    # Initialise new vti file (image data).
    @time outfiles = vtk_grid(vtk_filename_noext, Ni, Nj, Nk, extent=extent,
                              origin=origin, spacing=spacing) do vtk
        # Add data.
        vtk_point_data(vtk, p, "p_values")
        vtk_point_data(vtk, q, "q_values")
        vtk_point_data(vtk, vec, "myVector")
        vtk_cell_data(vtk, cdata, "myCellData")
    end
    println("Saved:   ", outfiles...)

    return outfiles::Vector{UTF8String}
end

ProjDir = dirname(@__FILE__)
cd(ProjDir*"/output") do

  main()
  
end
