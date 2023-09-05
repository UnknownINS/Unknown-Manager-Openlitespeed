createFile404(){
cat > $1 << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Error Page</title>
    <style>
    html,
body {
  height: 100%;
  min-height: 450px;
  font-family: "Dosis", sans-serif;
  font-size: 32px;
  font-weight: 500;
  color: #5d7399;
  margin:0px;
  padding:0px;
}

.content {
  height: 100%;
  position: relative;
  z-index: 1;
  background-color: #d2e1ec;
  background-image: linear-gradient(to bottom, #bbcfe1 0%, #e8f2f6 80%);
  overflow: hidden;
}

.snow {
  position: absolute;
  top: 0;
  left: 0;
  pointer-events: none;
  z-index: 20;
}

.main-text {
  padding: 20vh 20px 0 20px;
  text-align: center;
  line-height: 2em;
  font-size: 5vh;
}

.home-link {
  font-size: 0.6em;
  font-weight: 400;
  color: inherit;
  text-decoration: none;
  opacity: 0.6;
  border-bottom: 1px dashed rgba(93, 115, 153, 0.5);
}
.home-link:hover {
  opacity: 1;
}

.ground {
  height: 160px;
  width: 100%;
  position: absolute;
  bottom: 0;
  left: 0;
  background: #f6f9fa;
  box-shadow: 0 0 10px 10px #f6f9fa;
}
.ground:before, .ground:after {
  content: "";
  display: block;
  width: 250px;
  height: 250px;
  position: absolute;
  top: -62.5px;
  z-index: -1;
  background: transparent;
  transform: scaleX(0.2) rotate(45deg);
}
.ground:after {
  left: 50%;
  margin-left: -166.6666666667px;
  box-shadow: -330px 270px 15px #94a3be, -625px 575px 15px #bac4d5, -920px 880px 15px #8e9eba, -1205px 1195px 15px #8e9eba, -1540px 1460px 15px #a4b1c8, -1800px 1800px 15px #bac4d5, -2095px 2105px 15px #91a1bc, -2370px 2430px 15px #8193b2, -2690px 2710px 15px #8e9eba, -2965px 3035px 15px #91a1bc, -3255px 3345px 15px #9dabc4, -3625px 3575px 15px #8e9eba, -3850px 3950px 15px #b7c1d3, -4160px 4240px 15px #b4bed1, -4505px 4495px 15px #9aa9c2, -4775px 4825px 15px #adb9cd;
}
.ground:before {
  right: 50%;
  margin-right: -166.6666666667px;
  box-shadow: 310px -290px 15px #8e9eba, 635px -565px 15px #a4b1c8, 920px -880px 15px #adb9cd, 1155px -1245px 15px #94a3be, 1465px -1535px 15px #8798b6, 1775px -1825px 15px #adb9cd, 2095px -2105px 15px #bac4d5, 2425px -2375px 15px #8193b2, 2745px -2655px 15px #aab6cb, 3005px -2995px 15px #8798b6, 3305px -3295px 15px #9aa9c2, 3595px -3605px 15px #a1aec6, 3860px -3940px 15px #bac4d5, 4175px -4225px 15px #8798b6, 4510px -4490px 15px #b7c1d3, 4755px -4845px 15px #8e9eba;
}

.mound {
  margin-top: -80px;
  font-weight: 800;
  font-size: 180px;
  text-align: center;
  color: #dd4040;
  pointer-events: none;
}
.mound:before {
  content: "";
  display: block;
  width: 600px;
  height: 200px;
  position: absolute;
  left: 50%;
  margin-left: -300px;
  top: 50px;
  z-index: 1;
  border-radius: 100%;
  background-color: #e8f2f6;
  background-image: linear-gradient(to bottom, #dee8f1, #f6f9fa 60px);
}
.mound:after {
  content: "";
  display: block;
  width: 28px;
  height: 6px;
  position: absolute;
  left: 50%;
  margin-left: -150px;
  top: 68px;
  z-index: 2;
  background: #dd4040;
  border-radius: 100%;
  transform: rotate(-15deg);
  box-shadow: -56px 12px 0 1px #dd4040, -126px 6px 0 2px #dd4040, -196px 24px 0 3px #dd4040;
}

.mound_text {
  transform: rotate(6deg);
}

.mound_spade {
  display: block;
  width: 35px;
  height: 30px;
  position: absolute;
  right: 50%;
  top: 42%;
  margin-right: -250px;
  z-index: 0;
  transform: rotate(35deg);
  background: #dd4040;
}
.mound_spade:before, .mound_spade:after {
  content: "";
  display: block;
  position: absolute;
}
.mound_spade:before {
  width: 40%;
  height: 30px;
  bottom: 98%;
  left: 50%;
  margin-left: -20%;
  background: #dd4040;
}
.mound_spade:after {
  width: 100%;
  height: 30px;
  top: -55px;
  left: 0%;
  box-sizing: border-box;
  border: 10px solid #dd4040;
  border-radius: 4px 4px 20px 20px;
}
</style>
<script>
(function () {
  function ready(fn) {
    if (document.readyState != "loading") {
      fn();
    } else {
      document.addEventListener("DOMContentLoaded", fn);
    }
  }

  function makeSnow(el) {
    var ctx = el.getContext("2d");
    var width = 0;
    var height = 0;
    var particles = [];

    var Particle = function () {
      this.x = this.y = this.dx = this.dy = 0;
      this.reset();
    };

    Particle.prototype.reset = function () {
      this.y = Math.random() * height;
      this.x = Math.random() * width;
      this.dx = Math.random() * 1 - 0.5;
      this.dy = Math.random() * 0.5 + 0.5;
    };

    function createParticles(count) {
      if (count != particles.length) {
        particles = [];
        for (var i = 0; i < count; i++) {
          particles.push(new Particle());
        }
      }
    }

    function onResize() {
      width = window.innerWidth;
      height = window.innerHeight;
      el.width = width;
      el.height = height;

      createParticles((width * height) / 10000);
    }

    function updateParticles() {
      ctx.clearRect(0, 0, width, height);
      ctx.fillStyle = "#f6f9fa";

      particles.forEach(function (particle) {
        particle.y += particle.dy;
        particle.x += particle.dx;

        if (particle.y > height) {
          particle.y = 0;
        }

        if (particle.x > width) {
          particle.reset();
          particle.y = 0;
        }

        ctx.beginPath();
        ctx.arc(particle.x, particle.y, 5, 0, Math.PI * 2, false);
        ctx.fill();
      });

      window.requestAnimationFrame(updateParticles);
    }

    onResize();
    updateParticles();

    window.addEventListener("resize", onResize);
  }

  ready(function () {
    var canvas = document.getElementById("snow");
    makeSnow(canvas);
  });
})();

</script>
  </head>
  <body>

<div class="content">
  <canvas class="snow" id="snow"></canvas>
  <div class="main-text">
     <h3>Page not Found</h3>
  </div>
  <div class="ground">
    <div class="mound"> 
      <div class="mound_text">404</div>
      <div class="mound_spade"></div>
    </div>
  </div>
</div>

  </body>
</html>
EOF
}
