
struct binarystring
  partA::Array{UInt8,1}  
  end;

function binarystring!(x::Array{String,1})
  local z = collect(UInt8, x[1]);
  local rx = randperm(length(z));
  local z2 = binarystring(xor.(z, z[rx]));
  x[1] = String(z[rx]);
  return(z2);
  end;

function binarystring!(x::Array{String,1}, y::binarystring)
  local z = collect(UInt8, x[1]);
  x[1] = String(xor.(z, y.partA));
  return 
  end;  