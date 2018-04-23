
##program plotpixels


pixscript = """

function draw(datavec) {

  var canvas = document.getElementById('c');
  var ctx = canvas.getContext('2d');
  var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  var data = imageData.data;
    
    for (var i = 0; i < data.length; i += 4) {
      data[i]     = datavec[i];     // red
      data[i + 1] = datavec[i + 1]; // green
      data[i + 2] = datavec[i + 2]; // blue
      data[i + 3] = datavec[i + 3]; // solid

    }
    ctx.putImageData(imageData, 0, 0);
  };


function xdraw(datavec, colourmap) {

  var canvas = document.getElementById('c');
  var ctx = canvas.getContext('2d');
  var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  var data = imageData.data;
  var j = 0;    
    for (var i = 0; i < data.length; i += 4) {
      var xcol = colourmap[j];

      data[i]     = datavec[xcol];     // red
      data[i + 1] = datavec[xcol + 1]; // green
      data[i + 2] = datavec[xcol + 2]; // blue
      data[i + 3] = datavec[xcol + 3]; // solid

      j++;
    }
    ctx.putImageData(imageData, 0, 0);
  };




""";


function xhtml(tkstr, tkstr2, wmod=40, hmod=40);

myhtml = """
<!doctype html>
<html>
<body bgcolor=#fff>
<canvas id="c" width=$(wmod) height=$(hmod)></canvas>

<script> 
var jstr = $tkstr;

var kstr = $tkstr2;

//var jp = JSON.parse(jstr);

$pixscript

xdraw(jstr, kstr);

</script>

webshaders

webgl

</body></html>
""";

return(myhtml);

end;


function make_tk(arr, xmult=255)
  x = "[" * join(round.(arr .* xmult), ", ") * "]";
  end;


