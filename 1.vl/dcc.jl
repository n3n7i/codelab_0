
## 2d count chain trie heuristic ?

struct xbloom3
  v3::BitArray{2}
  xbloom3(x1, x2) = new(BitArray(x1, x2))
  end;

function Base.display(x::xbloom3)
  print("xb3_", size(x.v3), " ", sum(x.v3));
  end;

function (xb::xbloom3)()
  xb.v3[:] = false;
  end;

function (xb::xbloom3)(checkx::Int, checky::Int; setval=0)
  if(setval==1)
    if(!xb.v3[checkx, checky])
      xb.v3[checkx, checky] = true;
      return(true);
      end;
    return(false);
    end;
  return(xb.v3[checkx, checky]==true);
  end;

function bincollect(xdata, xbins = 10)
  zdata = similar(xdata);
  binbase = minimum(xdata,1)[:];
  bintop = maximum(xdata,1)[:] .- binbase;
  binr = bintop ./ xbins;
  for iter = 1:size(xdata,1)
    xmark = floor.((xdata[iter,:] .- binbase) ./ binr) .+ 1;
    zdata[iter, :] = xmark;
    end;
  return(zdata);
  end;

function jbloomtables(zdata)
  mbins = Int32.(maximum(zdata,1));
  w = size(zdata,2)-1;
  btvec = Array{xbloom3,1}(0);
  for iter=1:w
    local bt = xbloom3(mbins[iter], mbins[iter+1]);
    bt();
    bt.(zdata[:,iter], zdata[:,iter+1], setval = 1);
    push!(btvec, bt);
    end;
  return(btvec);
  end;

function bloomtables(zdata, mbins)
##  mbins = Int32.(maximum(zdata,1));
  w = size(zdata,2)-1;
#  println(zdata, " ", w, " ", size(zdata));
  local btvec = Array{xbloom3,1}(0);
  for iter=1:w
#    print(iter, "  ");
    local bt = xbloom3(mbins[iter], mbins[iter+1]);
    bt();
    bt.(zdata[:,iter], zdata[:,iter+1], setval = 1);
    push!(btvec, bt);
    end;
  return(btvec);
  end;


function tscan(stab, zpoint, zlen, sv=0)
  tcount=0;
  for iter=1:zlen-1
    tcount += stab[iter](zpoint[iter], zpoint[iter+1], setval = sv);  
    end;
  return tcount;
  end;

function xscan(zid, nsc, nx)
  n = length(zid-1);
  choice=0;
  while(n>0 & choice==0)
    p = nsc[zid[n]] < nx;
    if(p==true) choice = zid[n]; end;
    n = n-1;
    end;
  return(choice);
  end;

function mscan(nstab, zpoint, nscount, msflex=25)
  n = size(nstab,1);
  local xcount = Array{Int}(n);
  xcount[:] = 0;
  zlen = size(zpoint,1);
  xfound = false;
  xmax = 0;
  xid = 0;
  zid = [];

  for iter = 1:n
    local xstab = nstab[iter];
#    println(typeof(xstab));
    xcount[iter] = tscan(xstab, zpoint, zlen);
    xcount[iter] == zlen-1 && (xfound = true;);
    xcount[iter] >= xmax? (xmax = xcount[iter]; xid=iter; push!(zid, iter)):0;    
    end;
  px = 0;
  if (!xfound)
    if (nscount[xid] < (mean(nscount)+msflex))
      px = tscan(nstab[xid], zpoint, zlen, 1);
    else
      xid = xscan(zid, nscount, mean(nscount)+msflex);
      if(xid == 0)
        xid = rand(1:n);
        print("*");
        end;
      print(".");
      px = tscan(nstab[xid], zpoint, zlen, 1);
      end;
    end;

  return(xfound, xid, px);

  end;
    


function nbloom_online(zdata::Array{Int64,2}, ntab::Int64, niter::Int64)

  xbtvec = Array{Array{xbloom3,1},1}(0);

  btcounts = zeros(Int64, ntab);

  bmax = maximum(zdata,1);

  println(bmax);

  for xiter = 1:ntab

    push!(xbtvec, bloomtables(zdata[xiter*2:xiter*2+1, :], bmax));

#    println(xbtvec);

    end;

  println("Init?");

#  return(xbtvec);

  for iter=1:niter

    aclick, aid, btinc = mscan(xbtvec, zdata[iter,:], btcounts);

    if (aclick==false) 

      btcounts[aid] += btinc; 

      end;

    end;

  return(xbtvec, btcounts);
  
  end;


function xmatch(zdata, ztable)

  zt = size(ztable,1);

  zc = zeros(Int, size(zdata,1));

  for iter = 1:zt

    zc = zc .+ ztable[iter].(zdata[:, iter], zdata[:, iter+1]);

    end;

  return(zc .== zt);

  end;  


function nbloom_match(zdata, ztables)

  z = size(ztables, 1);

  w = size(zdata, 2);

  n = size(zdata, 1);

  xmat = xbloom3(n, z);

  for iter = 1:z

    xmat.v3[:, iter] = xmatch(zdata, ztables[iter]);

    end;

  return(xmat);

  end;


function zcombine(ztableA, ztableB)

  ztableC = [];

  for iter = 1:size(ztableA,1)

    local ztC = xbloom3(size(ztableA[iter].v3, 1), size(ztableA[iter].v3, 2))

    ztC.v3[:,:] = ztableA[iter].v3 .& ztableB[iter].v3;

    push!(ztableC, ztC);

    end;

  return(ztableC);

  end;
      

function zcombines(ztables, zvec)

  if(sum(zvec == 1))

    return(ztables[zvec][1]);

    end;

  if(sum(zvec)>0) 

    v1 = ztables[zvec][1];

    iter = 2;

    while(iter<=sum(zvec))

      v1 = zcombine(v1, ztables[zvec][iter]);

      iter+=1;

      end;

    return(v1);

    end;

  end;


function retrie(ztables, zvec)

  x = zcombines(ztables, zvec);

  end;



