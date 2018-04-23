
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


""";


function xhtml(tkstr, wmod=40, hmod=40);

myhtml = """
<!doctype html>
<html>
<body bgcolor=#fff>
<canvas id="c" width=$(wmod) height=$(hmod)></canvas>

<script> 
var jstr = $tkstr;
//var jp = JSON.parse(jstr);

$pixscript

draw(jstr);

</script>

webshaders

webgl

</body></html>
""";

return(myhtml);

end;


function make_tk(arr)
  x = "[" * join(round.(arr * 255), ", ") * "]";
  end;


