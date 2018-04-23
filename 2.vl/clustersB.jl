
##----------------------

## statoil clustering

function xl_dists(data, cent)
  return(sum(abs.(data .- cent'), 2));
  end;
  
function xl_iter(data, cents, dists, gid, init=false, x_dists = xl_dists)
  n = size(cents,1);
  for iter = 1:n
    bdist = x_dists(data, cents[iter, :]);
    bd2 = ((dists .> bdist) .+ (gid .== iter)) .> 0;
    dists[vec(bd2)] = bdist[vec(bd2)];
    gid[vec(bd2)] = iter;
    if(!init) 
      #k2 = gid .== iter;
      k = [ data[vec(bd2), :]; cents[iter, :]' ];
      cents[iter, :] = mean(k, 1);
      end;
    end;
  return(cents, dists, gid);
  end;
  
function xl_cluster(data, cent, iters)
  n = size(data,1);
  cents = data[randperm(n)[1:cent], :];
  dist = zeros(n) .+ 1e6;
  gid = zeros(Int64, n);
  (cents, dist, gid) = xl_iter(data, cents, dist, gid, true);
  for iter = 1:iters
    (cents, dist, gid) = xl_iter(data, cents, dist, gid);
    println("iter $iter / $iters");
    end;
  return(cents);
  end;
  

function zl_iter(data, cents, dists, gid, dflex, init=false, x_dists = xl_dists, fdec = 0.5)
  n = size(cents,1);
  m2 = size(data,1) / n;
  for iter = 1:n
    bdist = x_dists(data, cents[iter, :]);
    x2 = (sum(gid .== iter) + 1) / m2;
    dflex[iter] = dflex[iter].*fdec .+ x2.*(1.0 .- fdec);
    bd2 = (dists .> (bdist .* dflex[iter])) .| (gid .== iter);
    bd2 = vec(bd2);
    dists[bd2] = bdist[bd2] .* dflex[iter];
    gid[bd2] = iter;
    if(!init) 
      #k2 = gid .== iter;
      k = [ data[bd2, :]; cents[iter, :]' ];
      cents[iter, :] = mean(k, 1);
      end;
    end;
  return(cents, dists, gid, dflex);
  end;
  
function zl_cluster(data, cent, iters)
  n = size(data,1);
  cents = data[randperm(n)[1:cent], :];
  dist = zeros(n) .+ 1e6;
  gid = zeros(Int64, n);
  dflex = ones(cent);
  (cents, dist, gid) = xl_iter(data, cents, dist, gid, true);
  for iter = 1:iters
    (cents, dist, gid, dflex) = zl_iter(data, cents, dist, gid, dflex);
    println("iter $iter / $iters :: $(round(mean(dflex),2))");
    end;
  return(cents, gid);
  end;


function xf_dists(data, cent)
  f1 = mean(data .- cent', 2);
  return(sum(abs.((data .- f1) .- cent'), 2));
  end;

function zf_cluster(data, cent, iters, fd = 0.8)
  n = size(data,1);
  cents = data[randperm(n)[1:cent], :];
  dist = zeros(n) .+ 1e6;
  gid = zeros(Int64, n);
  dflex = ones(cent);
  (cents, dist, gid) = xl_iter(data, cents, dist, gid, true, xf_dists);
  for iter = 1:iters
    (cents, dist, gid, dflex) = zl_iter(data, cents, dist, gid, dflex, false, xf_dists, fd);
    println("iter $iter / $iters :: $(round(mean(dflex),2))");
    end;
  return(cents);
  end;


function zf_groups(data,cents)

  n = size(data,1);
##  cents = data[randperm(n)[1:cent], :];
  dist = zeros(n) .+ 1e6;
  gid = zeros(Int64, n);
  dflex = ones(size(cents,1));
  (cents, dist, gid) = xl_iter(data, cents, dist, gid, true, xf_dists);

  return(cents, dist, gid);
  end;

function xl_groups(data,cents)

  n = size(data,1);
##  cents = data[randperm(n)[1:cent], :];
  dist = zeros(n) .+ 1e6;
  gid = zeros(Int64, n);
  dflex = ones(size(cents,1));
  (cents, dist, gid) = xl_iter(data, cents, dist, gid, true, xl_dists);

  return(cents, dist, gid);
  end;



function zf_targhist(gid, gmax, targ, xbins)

  rn = zeros(gmax, xbins);

  zr = (2+maximum(targ) - minimum(targ)) / xbins;

  zc = collect(minimum(targ)-1:zr:maximum(targ)+1);

  for iter = 1:gmax      

    xsel = gid .== iter;

    for iterB = 1:xbins

      rn[iter, iterB] = sum(zc[iterB] .<= targ[xsel] .< zc[iterB+1]);

      end;

    end;

  return(rn);

  end;