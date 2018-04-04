

module sfdb

  type sfdb_struct

    tables;
    tabfield;
    tablink;
    tabdata;
    sfdb_struct() = new([], [], [], []);
    end;

  xobj = sfdb_struct();

  function newtable(tabname, tabfield)
    
    push!(xobj.tables, tabname);
    push!(xobj.tabfield, tabfield);
    push!(xobj.tablink, []);
    push!(xobj.tabdata, []);
    end;

  function getxobj()
    return(xobj);
    end;


  function addrec(tabid, rec)

    push!(xobj.tabdata[tabid], rec);

    end;


  function setlink(tabid1, colid1, tabid2, colid2, d=false)

    push!(xobj.tablink[tabid1], [tabid1 colid1 tabid2 colid2]);

    if(d) push!(xobj.tablink[tabid2], [tabid2 colid2 tabid1 colid1]); end;

    end;


  function getrec(tabid, rec)

    return(xobj.tabdata[tabid][rec]);

    end;


  function getcont(tabid, xcol, xval)
  
    v0 = map(x->x[xcol]==xval, xobj.tabdata[tabid]);

    return(xobj.tabdata[tabid][v0]);

    end;



  function getlinks(tabid)

    tlink = copy(xobj.tablink[tabid]);

    tcomp = [tabid];

    i=1;

    while(i<=size(tlink,1))

      println(tlink[i]);

      jt = tlink[i][3];

      if(!contains(==, tcomp, jt))

        jlink = xobj.tablink[jt];

        println("j", jlink);

        for iter=1:size(jlink,1)

          if(!contains(==, tcomp, jlink[iter][3]))

            push!(tlink, jlink[iter]);

            end;

          end;

        push!(tcomp, jt);

        end;

      i+=1;

      end;

    return(tlink);

    end;


  function xconcat(arr1, arr2)

    n = size(arr2,1);

    arr3 = copy(arr1);

    for iter = 1:n

      push!(arr3, arr2[iter]);

      end;

    return(arr3);

    end;



  function link_Cont(tabi, reci)

    linkarr = getlinks(tabi);

    contarr = Array{Array}(size(xobj.tables,1));

    contarr[tabi] = [getrec(tabi, reci)];

    xtarr = Array{Int64}(size(xobj.tables,1));

    xtarr[tabi] = size(contarr[tabi],1);

    for itera = 1:size(linkarr,1)

      xlink = linkarr[itera];

      cspare = [];

      for iterb = 1:xtarr[xlink[1]];

        jtemp = getcont(xlink[3], xlink[4], contarr[xlink[1]][iterb][xlink[2]]);

        cspare = xconcat(cspare, jtemp);

        end;

      xtarr[xlink[3]] = size(cspare,1);

      contarr[xlink[3]] = cspare;

      end;

    return(contarr);

    end;

       

  end;


sfdb.newtable("weasel", ["id", "classid"]);
sfdb.newtable("meercat", ["classid", "classname"]);
sfdb.newtable("tab3", ["classname", "xattr", "xval"]);
sfdb.newtable("tab4", ["xattr", "val"]);
sfdb.newtable("tab5", ["xval", "val"]);

sfdb.addrec(1, ["frame", 0]);
sfdb.addrec(2, [0, "2b"]);
sfdb.addrec(2, [1, "2a"]);
sfdb.addrec(3, ["2b", "nextlink", "altlink"]);
sfdb.addrec(3, ["2a", "nextlink", "allink"]);
sfdb.addrec(4, [0, "atr1", "nextlink"]);
sfdb.addrec(4, [1, "atr2", "nextlink"]);
sfdb.addrec(5, ["2x", "altlink"]);
sfdb.addrec(5, ["1x", "allink"]);


sfdb.setlink(1,2, 2,1, true);
sfdb.setlink(2,2, 3,1, true);
sfdb.setlink(3,2, 4,3, true);
sfdb.setlink(3,3, 5,2, true);



"""
sfdb.newtable("T1", ["c1", "c2"]);

sfdb.newtable("T2", ["c1", "c2"]);


sfdb.setlink(1,2,2,1);
sfdb.setlink(2,1,1,2);

sfdb.addrec(1, ["test0", 0]);
sfdb.addrec(1, ["test1", 1]);
sfdb.addrec(1, ["test2", 2]);
sfdb.addrec(1, ["test3", 3]);

sfdb.addrec(2, [1, "test3"]);
sfdb.addrec(2, [2, "test0"]);
sfdb.addrec(2, [3, "test1"]);
sfdb.addrec(2, [0, "test2"]);
"""




