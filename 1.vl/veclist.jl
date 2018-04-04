
mutable struct VecList
  point::Array
  dex::Array{Int32, 1}
  prex::Array{Int32, 1}

  clen::Int32;
  clear::Any;
  first::Int32;
  last::Int32;
  putptr::Int32;
  VecList(t::DataType, sizehint::Int, xcl::Any) = clear!(new(Array{t}(sizehint), Array{Int32,1}(sizehint), Array{Int32,1}(sizehint), sizehint, xcl, 1, 1, 1));
  end;

function clear!(x::VecList)
  x.point[:] = x.clear;
  x.dex[:] = -1;
  x.prex[:] = -1;
  x.putptr = 1;
  x.first = 1;
  x.last = 1;
  x.clen = size(x.dex, 1);
  return x
  end;

function copy!(x::VecList, y::Array{T,1}) where T

  n = size(y,1);

  if(x.clen<n)
    resize!(x.point, n);
    resize!(x.dex, n);
    resize!(x.prex, n);
    x.clen = n;
    end;

  x.first=1;

  for iter = 1:n
    x.point[iter] = y[iter];
    x.dex[iter] = iter+1;
    x.prex[iter] = iter-1;
    end;

  x.dex[n] = 0;
  x.putptr = n+1;
  x.last = n;
  ##x.first = 1;
  end;

function flatten!(x::VecList)

  n = x.clen;
  xtemp = similar(x.point);
  ii = 0;
  jj = x.first;
  while (ii<n)
    ii+=1;
    xtemp[ii] = x.point[jj];
    if(x.dex[jj] < 1) break; end;
    jj = x.dex[jj];
    end;
  x.point[1:ii] = xtemp[1:ii];
  x.dex[1:ii] = Int32[collect(2:ii); 0];
  x.prex[1:ii] = Int32.(collect(0:ii-1));
  end;


function put!(x::VecList, val::Any)
  n = x.putptr;
  if(n>x.clen)
    resize!(x.point, n+1);
    resize!(x.dex, n+1);
    x.clen = n+1;
    end;
  x.point[n] = val;
  x.dex[x.last] = n;
  x.dex[n] = 0;
  x.putptr += 1;
  end;

function insertat!(x::VecList, dest::Int, targ::Int)

  t1 = x.dex[dest];     #  t1b = x.prex[dest];
  t2 = x.dex[targ];
  t2b = x.prex[targ];

  x.dex[t2b] = t2; #+20;
  x.dex[dest] = targ; # +60;
  x.dex[targ] = t1; # +120;

  x.prex[t2] = t2b; # +40;
  x.prex[targ] = dest; # +80;
  x.prex[t1] = targ; # +160;

  end;

function Base.getindex(x::VecList, i::Int64)
  x.point[i];
  end;

function Base.length(x::VecList)
  x.putptr-1;
  end;

function Base.start(x::VecList)
  x.first;
  end;

function Base.done(x::VecList, i::Int32)
  i<1;
  end;

function Base.next(x::VecList, i::Int32)
  (x.point[i], x.dex[i]);
  end;

